import axios from "axios"

console.log("Log for force redeploy");

export default async (req) => {
    const { next_run } = await req.json()
    console.log("Running daily refresh of Coveo search tokens... Next invocation at:", next_run)
    
    // Netlify details
    const nginx_account_id = '5aef7fb2b3127447cfdc7578'
    const site_ids = {
        'docs-dev.nginx.com': '8f101906-ee43-4fc6-9754-ff460265ad8e',
        'docs-staging.nginx.com': 'e5dd2562-92a6-4cad-894a-4629256414fe',
        'docs.nginx.com': 'a95b7860-e908-4df4-9677-610d55e50cc7',
        'kubernetes-ingress': "9467201e-2dd4-40f5-a9d9-546c0a10b4f7",
        'gateway-fabric': "8e1ced5e-d146-4481-95e6-2ac4552d18ac",
        'agent': "4edaaed0-4bcd-4699-b112-174410e18fa4",
        "service-mesh": "2d8f8acf-36b9-4b62-83cb-54d381f8bcfb",
        "N4A": "81ebffe4-d7f0-439c-9840-282905978ce9"
    }

    // Maps site names to their corresponding Coveo api key name
    const sites_keys_context = {
        'docs-dev.nginx.com': "COVEO_API_DEV",
        'docs-staging.nginx.com': "COVEO_API_STAGING",
        'docs.nginx.com': "COVEO_API_PROD",
        'kubernetes-ingress': "COVEO_API_PROD",
        'gateway-fabric': "COVEO_API_PROD",
        'agent': "COVEO_API_PROD",
        'service-mesh': "COVEO_API_PROD",
        'N4A': "COVEO_API_PROD"
    }

    // Coveo details
    const coveo_var_name = 'COVEO_SEARCH_TOKEN' // name of env variable to update in each site
    const coveo_org_id = "f5networksproduction5vkhn00h"
    const coveo_search_hub = "HUB_ES_Nginx_Docs_And_Org"
    let coveoKey
    for (const [site_name, site_id] of Object.entries(site_ids)) {
        const _request_new_search_token = { // request header for Coveo token generation
            method: "POST",
            uri: "https://"+coveo_org_id+".org.coveo.com/rest/search/v2/token?organizationid="+coveo_org_id,
            headers: {
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": `Bearer ${Netlify.env.get(sites_keys_context[site_name])}`
            },
            json: {
                "searchHub": `${coveo_search_hub}`,
                "organization": `${coveo_org_id}`,
                "userIds": [
                    {
                        "type": "User",
                        "name": "anonymous",
                        "provider": "Email Security Provider"
                    }
                ] 
            }
        }

        try { // Generate new Coveo Search token
            const response = await axios.post(
                _request_new_search_token.uri,
                _request_new_search_token.json,
                { 
                    headers: _request_new_search_token.headers
                }
            )
            if (response.status != 200) {
                console.debug(JSON.stringify(response.body, null, 2));
                throw new Error("Failed to create search token.")
            }
            coveoKey = response.data.token
        } catch (error) {
            console.error(`An error occurred: ${error}`);
            continue;
        }

        console.log('Updating environment variable '+coveo_var_name+' for site '+site_name)

        const _request_update_env_var = { // request header for netlify api request
            method: "PUT",
            uri: 'https://api.netlify.com/api/v1/accounts/'+nginx_account_id+'/env/'+coveo_var_name+'?site_id='+site_id,
            headers: {
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": `Bearer ${Netlify.env.get("NETLIFY_BOT_TOKEN")}`
            },
            json: {
                "key": coveo_var_name,
                "scopes": [
                    "builds",
                    "functions",
                    "runtime"
                ],
                // when updating secrets via the api, be sure not to use the 'all' value for context
                // as it may return 200 without actually updating the value in Netlify
                "values": [
                    {
                        "context": "production",
                        "value": coveoKey
                    },
                    {
                        "context": "deploy-preview",
                        "value": coveoKey
                    },
                    {
                        "context": "branch-deploy",
                        "value": coveoKey
                    }
                ]
            }
        }

        console.log("Updating the Coveo search token")
        try { // Update site's search token env var
            const response = await axios.put(
                _request_update_env_var.uri,
                _request_update_env_var.json,
                {
                    headers: _request_update_env_var.headers
                }
            )

            if (response.hasOwnProperty('status') == false) {
                console.error("Could not update environment variable for "+site_name+": error code "+response.code+" "+response.message)
            } else {
                switch (response.status) {
                    case 200:
                        console.log("OK")
                        break;
                    case 401:
                        console.error("Unauthorized")
                        break;
                    case 419:
                        console.error("Session expired")
                        break;
                    default:
                        break;
                }
            }
        } catch (error) {
            console.error(error.config.data)
            continue;
        }
    }
}