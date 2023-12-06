import axios from "axios"
// import { getSecrets, NetlifySecrets } from "@netlify/functions";

export default async (req) => {
    const { next_run } = await req.json()
    console.log("Received event! Next invocation at:", next_run)
    
    // Netlify details
    const netlify_account_id = '5aef7fb2b3127447cfdc7578' // Nginx account id
    const site_ids = {
        'docs-dev': '8f101906-ee43-4fc6-9754-ff460265ad8e',
        'docs-staging': 'e5dd2562-92a6-4cad-894a-4629256414fe',
        'docs': 'a95b7860-e908-4df4-9677-610d55e50cc7',
        // 'kubernetes-ingress': "9467201e-2dd4-40f5-a9d9-546c0a10b4f7",
        // 'agent': "4edaaed0-4bcd-4699-b112-174410e18fa4",
        // "service-mesh": "2d8f8acf-36b9-4b62-83cb-54d381f8bcfb",
        // "N4A": "81ebffe4-d7f0-439c-9840-282905978ce9"
    }

    // Coveo details
    const coveo_var_name = 'COVEO_SEARCH_TOKEN' // name of env variable to update in each site
    const coveo_org_id = "f5networkx1h1607h"
    const coveo_search_hub = "HUB_ES_Nginx_Docs_And_Org"
    let coveoKey
    for (const [key, value] of Object.entries(site_ids)) {
        const _request_new_search_token = { // request header for Coveo token generation
            method: "POST",
            uri: "https://"+coveo_org_id+".org.coveo.com/rest/search/v2/token?organizationid="+coveo_org_id,
            headers: {
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": `Bearer ${Netlify.env.get("COVEO_API_TOKEN")}`
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

        try { // Generate new Coveo Search API token
            const response = await axios.post(
                _request_new_search_token.uri,
                _request_new_search_token.json,
                { 
                    headers: _request_new_search_token.headers
                }
            )
            if (response.status != 200) {
                console.debug(JSON.stringify(response.body, null, 2));
            }
            coveoKey = response.data.token
        } catch (error) {
            console.error(`An error occurred: ${error}`);
        }

        console.log('Updating environment variable '+coveo_var_name+' for site '+key+'.nginx.com')

        const _request_update_env_var = { // request header for Coveo token generation
            method: "PUT",
            uri: 'https://api.netlify.com/api/v1/accounts/'+netlify_account_id+'/env/'+coveo_var_name+'?site_id='+value,
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
                "values": [
                    {
                        "id": coveo_var_name,
                        "value": coveoKey,
                        "context": "all",
                        "context_parameter": ""
                    }
                ]
            }
        }

        try {
            response = await axios.put(
                _request_update_env_var.uri,
                _request_update_env_var.json,
                {
                    headers: _request_update_env_var.headers
                }
            )

            if (response.status != 200){
                console.error(response)
            }
        } catch (error) {
            console.error(error.config.data)
        }
    }

    // TODO: Trigger a rebuild for all sites via Netlify API
    //  https://open-api.netlify.com/#tag/build
}