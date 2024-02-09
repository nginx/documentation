import axios from "axios"

console.log("Log for force redeploy");

async function getSearchToken(r, ctx) {
    const response = await axios({
        url: r.uri,
        method: r.method,
        headers: r.headers
    })

    return (
        response?.data?.values?.find(({ context }) => context === ctx)?.value || {
          statusCode: 500,
          body: JSON.stringify("no matching context"),
        }
    );
}

export const handler = async (event, context) => {

    if (
       !(
        event?.headers?.referer?.includes("nginx.com") ||
        event?.headers?.referer?.includes("netlify.app")
       )
    ) {
        return {
          statusCode: 403
        };
    }

    const netlify_org_id = "5aef7fb2b3127447cfdc7578"
    const netlify_token = process.env.NETLIFY_BOT_TOKEN
    const site_id = process.env.SITE_ID
    const site_context = "production"

    const request = {
        method: "GET",
        uri: "https://api.netlify.com/api/v1/accounts/"+netlify_org_id+"/env/COVEO_SEARCH_TOKEN?site_id="+site_id,
        headers: {
            "Authorization": "Bearer "+netlify_token,
            "Accept": "application/json",
            "Content-Type": "application/json",
        }
    }

    const tval = await getSearchToken(request, site_context)
    
    return {
        statusCode: 200,
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({token: tval})
    }
}