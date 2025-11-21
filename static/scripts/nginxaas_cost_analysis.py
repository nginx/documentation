#!/usr/bin/env python3
"""
NGINX for Azure Cost Analysis Tool

This script analyzes your actual NGINX for Azure usage and calculates precise hourly costs
based on real Azure Monitor metrics with 1-minute granularity aggregated to hourly intervals.
"""

from datetime import datetime
from azure.identity import InteractiveBrowserCredential
from azure.mgmt.monitor import MonitorManagementClient
import argparse
import sys

# Tier-specific pricing for NGINX and NGINX + WAF
PRICING = {
    "Tier 1": {
        "fixed": {"NGINX": 0.25, "NGINX + WAF": 0.45},
        "ncu": {"NGINX": 0.008, "NGINX + WAF": 0.0144},
        "data_processing": 0.005  # Per GB
    },
    "Tier 2": {
        "fixed": {"NGINX": 0.33, "NGINX + WAF": 0.594},
        "ncu": {"NGINX": 0.01064, "NGINX + WAF": 0.01952},
        "data_processing": 0.005  # Per GB
    },
    "Tier 3": {
        "fixed": {"NGINX": 0.42, "NGINX + WAF": 0.75},
        "ncu": {"NGINX": 0.01328, "NGINX + WAF": 0.0239},
        "data_processing": 0.005  # Per GB
    }
}

# Regional tier mapping
TIER_MAPPING = {
    "Tier 1": ["eastus2","centraluseuap", "northeurope", "southcentralus", "westcentralus", "westus2", "westus3"],
    "Tier 2": ["canadacentral", "centralindia", "centralus", "eastus", "germanywestcentral", "koreacentral",
               "northcentralus", "southeastasia", "swedencentral", "westeurope", "westus"],
    "Tier 3": ["australiaeast", "brazilsouth", "japaneast", "southindia", "uksouth", "ukwest"]
}

def determine_tier(location):
    """Determine the regional tier based on location."""
    for tier, locations in TIER_MAPPING.items():
        if location in locations:
            return tier
    raise ValueError(f"Location '{location}' is not recognized in any tier mapping.")

def validate_date_range(date_range):
    """Validates that the date range does not exceed 30 days."""
    try:
        start_date, end_date = date_range.split("/")
        start_date = datetime.fromisoformat(start_date.replace("Z", "+00:00"))
        end_date = datetime.fromisoformat(end_date.replace("Z", "+00:00"))
        if end_date < start_date:
            raise ValueError("End date must be greater than the start date.")
        
        days_diff = (end_date - start_date).days
        if days_diff > 30:
            raise ValueError(f"The date range exceeds the allowed maximum of 30 days. Current range: {days_diff} days.")
        
    except ValueError as e:
        raise ValueError(f"Invalid date range: {e}")

def get_metrics_azure_sdk(client, resource_id, metric_name, start_time, end_time):
    """Fetch metrics using Azure Monitor SDK with 1-minute granularity."""
    metrics_data = client.metrics.list(
        resource_uri=resource_id,
        timespan=f"{start_time}/{end_time}",
        interval="PT1M",  # 1-minute intervals
        metricnames=metric_name,
        aggregation="Average,Maximum,Total",
    )
    return metrics_data

def aggregate_hourly_data(metrics_data, metric_name):
    """Aggregate 1-minute metric data into hourly values."""
    from datetime import datetime, timezone
    
    # Check if we have valid SDK format data
    if not (metrics_data.value and len(metrics_data.value) > 0 and 
            metrics_data.value[0].timeseries and len(metrics_data.value[0].timeseries) > 0):
        return []
    
    data_points = metrics_data.value[0].timeseries[0].data
    hourly_aggregates = {}
    
    for point in data_points:
        # SDK format - use time_stamp attribute
        timestamp = point.time_stamp
        hour_key = timestamp.replace(minute=0, second=0, microsecond=0)
        
        if hour_key not in hourly_aggregates:
            hourly_aggregates[hour_key] = {
                'timestamp': hour_key.isoformat().replace('+00:00', 'Z'),
                'values': [],
                'totals': []
            }
        
        if metric_name == "system.interface.total_bytes":
            total_val = point.total or 0
            hourly_aggregates[hour_key]['totals'].append(total_val)
        else:
            avg_val = point.average or 0
            max_val = point.maximum or 0
            hourly_aggregates[hour_key]['values'].append(max_val if max_val > 0 else avg_val)
    
    result = []
    for hour_key in sorted(hourly_aggregates.keys()):
        hour_data = hourly_aggregates[hour_key]
        
        if metric_name == "system.interface.total_bytes":
            final_value = sum(hour_data['totals'])
        else:
            final_value = max(hour_data['values']) if hour_data['values'] else 0
        
        result.append({
            'timestamp': hour_data['timestamp'],
            'value': final_value
        })
    
    return result

def calculate_cost_breakdown(date_range, resource_id, location, credential, subscription_id=None):
    """Calculates the cost breakdown for the specified date range and resource using Azure SDK."""
    validate_date_range(date_range)

    start_time, end_time = date_range.split("/")
    
    if subscription_id is None:
        try:
            subscription_id = resource_id.split('/')[2]
        except IndexError:
            raise ValueError("Unable to extract subscription ID from resource ID. Please provide it explicitly.")
    
    client = MonitorManagementClient(credential, subscription_id)

    tier = determine_tier(location)
    pricing = PRICING[tier]

    waf_metrics_raw = get_metrics_azure_sdk(client, resource_id, "waf.enabled", start_time, end_time)
    ports_metrics_raw = get_metrics_azure_sdk(client, resource_id, "ports.used", start_time, end_time)
    ncu_metrics_raw = get_metrics_azure_sdk(client, resource_id, "ncu.provisioned", start_time, end_time)
    network_metrics_raw = get_metrics_azure_sdk(client, resource_id, "system.interface.total_bytes", start_time, end_time)
    
    waf_hourly = aggregate_hourly_data(waf_metrics_raw, "waf.enabled")
    ports_hourly = aggregate_hourly_data(ports_metrics_raw, "ports.used")
    ncu_hourly = aggregate_hourly_data(ncu_metrics_raw, "ncu.provisioned")
    network_hourly = aggregate_hourly_data(network_metrics_raw, "system.interface.total_bytes")
    
    cost_breakdown = []
    
    if not (waf_hourly and ports_hourly and ncu_hourly and network_hourly):
        raise Exception("No metric data available for the specified time range")
    
    min_length = min(len(waf_hourly), len(ports_hourly), len(ncu_hourly), len(network_hourly))
    print(f"📈 Processing {min_length} hours of data...")
    
    for i in range(min_length):
        timestamp = waf_hourly[i]['timestamp']
        waf_enabled = waf_hourly[i]['value'] == 1  # 1 means WAF is enabled
        ports_used = ports_hourly[i]['value']
        ncu_provisioned = ncu_hourly[i]['value']
        total_bytes = network_hourly[i]['value']
        
        # Convert total bytes to GB
        data_processed_gb = total_bytes / (1024 ** 3) if total_bytes else 0
        
        # Check if deployment is active (both NCU and ports > 0 indicates active deployment)
        deployment_active = ncu_provisioned > 0 or ports_used > 0
        
        # Cost components - only charge fixed costs if deployment is active
        if deployment_active:
            fixed_deployment_cost = pricing["fixed"]["NGINX"]
            waf_cost = pricing["fixed"]["NGINX + WAF"] - fixed_deployment_cost if waf_enabled else 0
        else:
            fixed_deployment_cost = 0
            waf_cost = 0
        
        base_ncu_cost = ncu_provisioned * pricing["ncu"]["NGINX"]
        waf_ncu_cost = (ncu_provisioned * (pricing["ncu"]["NGINX + WAF"] - pricing["ncu"]["NGINX"])) if waf_enabled else 0
        
        ports_cost = (max(ports_used - 5, 0) * pricing["ncu"]["NGINX"])  # Cost for ports > 5
        data_processing_cost = data_processed_gb * pricing["data_processing"]
        
        # Total hourly cost
        total_cost = fixed_deployment_cost + waf_cost + base_ncu_cost + waf_ncu_cost + ports_cost + data_processing_cost
        
        # Append hourly cost breakdown
        cost_breakdown.append({
            "timestamp": timestamp,
            "fixed_deployment_cost": round(fixed_deployment_cost, 6),
            "waf_cost": round(waf_cost, 6),
            "base_ncu_cost": round(base_ncu_cost, 6),
            "waf_ncu_cost": round(waf_ncu_cost, 6),
            "ports_cost": round(ports_cost, 6),
            "data_processing_cost": round(data_processing_cost, 6),
            "total_cost": round(total_cost, 6)
        })

    return cost_breakdown

def parse_arguments():
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(
            description='NGINX for Azure Cost Analysis Tool (Interactive Login)',
            formatter_class=argparse.RawDescriptionHelpFormatter,
            epilog="""
Example usage:
    python3 nginxaas_cost_analysis.py \
        --resource-id "/subscriptions/xxx/resourceGroups/my-rg/providers/Nginx.NginxPlus/nginxDeployments/my-nginx" \
        --location "eastus2" \
        --date-range "2025-11-18T00:00:00Z/2025-11-19T23:59:59Z" \
        --tenant-id "your-tenant-id" \
        --output "my-cost-analysis.csv"

Note: --tenant-id is required for authentication.
            """
    )
    
    # Required arguments
    parser.add_argument('--resource-id', '-r', required=True,
                       help='Azure resource ID of the NGINX deployment')
    parser.add_argument('--location', '-l', required=True,
                       help='Azure region where NGINX is deployed (e.g., eastus2, westus2)')
    parser.add_argument('--date-range', '-d', required=True,
                       help='Analysis period in ISO format: start/end (e.g., 2025-11-18T00:00:00Z/2025-11-19T23:59:59Z)')
    
    # Required tenant-id argument
    parser.add_argument('--tenant-id', '-t', required=True,
                       help='Azure AD Tenant ID (required for authentication)')
    parser.add_argument('--subscription-id', 
                       help='Azure Subscription ID (extracted from resource-id if not provided)')
    parser.add_argument('--output', '-o', default='nginxaas_cost_breakdown.csv',
                       help='Output CSV filename (default: nginxaas_cost_breakdown.csv)')
    parser.add_argument('--verbose', '-v', action='store_true',
                       help='Enable verbose debug output')
    
    return parser.parse_args()

def main():
    """Main function to run the cost breakdown analysis."""
    
    args = parse_arguments()
    
    config = {
        "subscription_id": args.subscription_id,
        "resource_id": args.resource_id,
        "location": args.location,
        "date_range": args.date_range,
        "tenant_id": args.tenant_id,
        "output_file": args.output,
        "verbose": args.verbose
    }
    
    # Validate required arguments
    if not config["resource_id"].startswith("/subscriptions/"):
        print("❌ Error: Invalid resource ID format")
        print("   Resource ID should start with /subscriptions/")
        print("   Example: /subscriptions/xxx/resourceGroups/my-rg/providers/Nginx.NginxPlus/nginxDeployments/my-nginx")
        return 1
    
    if not config["date_range"] or "/" not in config["date_range"]:
        print("❌ Error: Invalid date range format")
        print("   Use format: start/end (e.g., 2025-11-18T00:00:00Z/2025-11-19T23:59:59Z)")
        return 1
    
    try:
        print("🔧 Initializing NGINX for Azure Cost Analysis...")
        print(f"📍 Location: {config['location']}")
        print(f"📅 Date Range: {config['date_range']}")
        print(f"🔗 Resource: {config['resource_id'].split('/')[-1]}")
        print()
        
        # Authentication with Azure
        print("🔐 Authenticating with Azure...")
        
        # Use InteractiveBrowserCredential with required tenant_id
        credential = InteractiveBrowserCredential(
            tenant_id=config["tenant_id"]
        )
        print(f"🌐 Using InteractiveBrowserCredential with tenant: {config['tenant_id']}")

        # Run the cost calculation
        result = calculate_cost_breakdown(
            config["date_range"], 
            config["resource_id"], 
            config["location"],
            credential,
            config["subscription_id"]
        )

        # Display summary statistics
        total_hours = len(result)
        total_cost = sum(entry["total_cost"] for entry in result)
        avg_hourly_cost = total_cost / total_hours if total_hours > 0 else 0
        
        print("=" * 60)
        print("📈 COST ANALYSIS SUMMARY")
        print("=" * 60)
        print(f"Total Analysis Period: {total_hours} hours")
        print(f"Total Cost: ${total_cost:.2f}")
        print()
        
        # Display detailed breakdown for first few hours
        print("🕐 HOURLY COST BREAKDOWN (First 5 hours):")
        print("-" * 60)
        for i, entry in enumerate(result[:5]):
            print(f"Hour {i+1} - {entry['timestamp']}")
            print(f"  Fixed: ${entry['fixed_deployment_cost']:.3f} | WAF: ${entry['waf_cost']:.3f} | NCU: ${entry['base_ncu_cost']:.3f}")
            print(f"  Ports: ${entry['ports_cost']:.3f} | Data: ${entry['data_processing_cost']:.3f} | Total: ${entry['total_cost']:.3f}")
            print()
        
        if total_hours > 5:
            print(f"... and {total_hours - 5} more hours")
            print()
        
        # Export to CSV
        export_to_csv(result, config["output_file"])
        
        print("✅ Cost analysis completed successfully!")
        return 0

    except Exception as e:
        error_message = str(e)
        print(f"❌ Error during cost analysis: {error_message}")
        
        if "authorization" in error_message.lower() or "403" in error_message:
            print("\n🔐 PERMISSIONS ERROR")
            print("=" * 25)
            print("Your Azure account needs access to read metrics from this NGINX resource.")
            print("This typically requires 'Monitoring Reader' or 'Reader' role on the resource.")
        else:
            print(f"\n💡 Please check:")
            print("   • Your Azure permissions (Monitoring Reader role)")
            print("   • That the resource ID is correct")
            print("   • That the date range is within the last 30 days")
            print("   • Try running 'az login' first for DefaultAzureCredential")
        
        return 1

def export_to_csv(cost_breakdown, filename="nginx_cost_breakdown.csv"):
    """Export cost breakdown to CSV file."""
    import csv
    
    if not cost_breakdown:
        print("⚠️  No data to export")
        return
    
    try:
        with open(filename, 'w', newline='') as csvfile:
            fieldnames = cost_breakdown[0].keys()
            header_mapping = {
                "timestamp": "Timestamp",
                "fixed_deployment_cost": "Base Fixed Cost ($USD)",
                "waf_cost": "WAF Cost ($USD)",
                "base_ncu_cost": "Base NCU Cost ($USD)",
                "waf_ncu_cost": "WAF NCU Cost ($USD)",
                "ports_cost": "Ports Cost ($USD)",
                "data_processing_cost": "Data Processing Cost ($USD)",
                "total_cost": "Total Cost ($USD)"
            }
            
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            
            # Write custom headers
            writer.writerow(header_mapping)
            
            # Write hourly data
            for row in cost_breakdown:
                writer.writerow(row)
            
            # Calculate and write summary totals
            total_hours = len(cost_breakdown)
            total_fixed_deployment = sum(entry["fixed_deployment_cost"] for entry in cost_breakdown)
            total_waf = sum(entry["waf_cost"] for entry in cost_breakdown)
            total_base_ncu = sum(entry["base_ncu_cost"] for entry in cost_breakdown)
            total_waf_ncu = sum(entry["waf_ncu_cost"] for entry in cost_breakdown)
            total_ports = sum(entry["ports_cost"] for entry in cost_breakdown)
            total_data_processing = sum(entry["data_processing_cost"] for entry in cost_breakdown)
            total_cost = sum(entry["total_cost"] for entry in cost_breakdown)
            
            # Add separator row
            writer.writerow({field: "" for field in fieldnames})
            
            # Add totals row with dollar signs
            totals_row = {
                "timestamp": f"TOTALS ({total_hours} hours)",
                "fixed_deployment_cost": f"${round(total_fixed_deployment, 4):.4f}",
                "waf_cost": f"${round(total_waf, 4):.4f}",
                "base_ncu_cost": f"${round(total_base_ncu, 4):.4f}",
                "waf_ncu_cost": f"${round(total_waf_ncu, 4):.4f}",
                "ports_cost": f"${round(total_ports, 4):.4f}",
                "data_processing_cost": f"${round(total_data_processing, 4):.4f}",
                "total_cost": f"${round(total_cost, 2):.2f}"
            }
            writer.writerow(totals_row)
            
        print(f"✅ Cost breakdown exported to {filename}")
        print(f"   📊 Summary: {total_hours} hours, Total cost: ${total_cost:.2f}")
    except Exception as e:
        print(f"❌ Error exporting to CSV: {e}")

if __name__ == "__main__":
    sys.exit(main())