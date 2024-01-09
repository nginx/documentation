export default async (req) => {
    // return the search token from environment variable
    return Response.json({
        token: Netlify.env.get("COVEO_SEARCH_TOKEN")
    })
}