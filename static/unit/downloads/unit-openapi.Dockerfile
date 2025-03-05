FROM unit:node

RUN mkdir -p /www/html && echo '<html>                                      \
    <head>                                                                  \
        <meta charset="utf-8">                                              \
        <script type="module" src="https://unpkg.com/rapidoc/dist/rapidoc-min.js"></script> \
    </head>                                                                 \
    <body>                                                                  \
        <rapi-doc                                                           \
                spec-url="https://raw.githubusercontent.com/nginx/unit/master/docs/unit-openapi.yaml" \
                bg-color="white"                                            \
                font-size="large"                                           \
                mono-font="monospace"                                       \
                primary-color = "#00974d"                                   \
                regular-font="'Open Sans', Arial, sans-serif"               \
                render-style = "read"                                       \
                show-header="false"                                         \
                text-color = "#333"                                         \
                theme="light"                                               \
                > </rapi-doc>                                               \
    </body>                                                                 \
</html>' > /www/html/index.html

RUN echo '{                                                                 \
    "listeners": {                                                          \
        "*:8765": {                                                         \
            "pass": "routes/share"                                          \
        },                                                                  \
        "*:8080": {                                                         \
          "pass": "applications/node-proxy"                                 \
       }                                                                    \
    },                                                                      \
    "routes": {                                                             \
        "share": [                                                          \
            {                                                               \
                "action": {                                                 \
                    "share": "/www/html/$uri"                               \
                }                                                           \
            }                                                               \
        ]                                                                   \
    },                                                                      \
    "applications": {                                                       \
        "node-proxy": {                                                     \
            "type": "external",                                             \
            "working_directory": "/www/",                                   \
            "executable": "/usr/bin/env",                                   \
            "arguments": [                                                  \
                "node",                                                     \
                "--loader",                                                 \
                "unit-http/loader.mjs",                                     \
                "--require",                                                \
                "unit-http/loader",                                         \
                "server.js"                                                 \
            ]                                                               \
        }                                                                   \
    }                                                                       \
}' > /docker-entrypoint.d/config.json

RUN echo 'var http = require("http"); \
var httpProxy = require("http-proxy"); \
 \
var proxy = httpProxy.createProxyServer({}); \
var sendError = function(res, err) { \
	return res.status(500).send({ \
		 error: err, \
		 message: "An error occured in the proxy" \
	}); \
}; \
 \
proxy.on("error", function (err, req, res) { \
	sendError(res, err); \
}); \
 \
var enableCors = function(req, res) { \
	if (req.headers["access-control-request-method"]) { \
		res.setHeader("access-control-allow-methods", req.headers["access-control-request-method"]); \
	} \
 \
	if (req.headers["access-control-request-headers"]) { \
		res.setHeader("access-control-allow-headers", req.headers["access-control-request-headers"]); \
	} \
 \
	if (req.headers.origin) { \
		res.setHeader("access-control-allow-origin", req.headers.origin); \
		res.setHeader("access-control-allow-credentials", "true"); \
	} \
}; \
 \
proxy.on("proxyRes", function(proxyRes, req, res) { \
	enableCors(req, res); \
}); \
 \
proxy.on("error", function (err, req, res) { \
	sendError(res, err); \
}); \
 \
var enableCors = function(req, res) { \
	if (req.headers["access-control-request-method"]) { \
		res.setHeader("access-control-allow-methods", req.headers["access-control-request-method"]); \
	} \
 \
	if (req.headers["access-control-request-headers"]) { \
		res.setHeader("access-control-allow-headers", req.headers["access-control-request-headers"]); \
	} \
 \
	if (req.headers.origin) { \
		res.setHeader("access-control-allow-origin", req.headers.origin); \
		res.setHeader("access-control-allow-credentials", "true"); \
	} \
}; \
 \
proxy.on("proxyRes", function(proxyRes, req, res) { \
	enableCors(req, res); \
}); \
 \
var server = http.createServer(function(req, res) { \
	if (req.method === "OPTIONS") { \
		enableCors(req, res); \
		res.writeHead(200); \
		res.end(); \
		return; \
	} \
 \
	proxy.web(req, res, { \
		target: "http://127.0.0.1:9999", \
		secure: true, \
		changeOrigin: true \
	}, function(err) { \
		sendError(res, err); \
	}); \
}); \
 \
server.listen(8080);' > /www/server.js

RUN echo '{ \
  "name": "oas", \
  "version": "1.0.0", \
  "description": "", \
  "main": "server.js", \
  "scripts": { \
    "test": "echo \"Error: no test specified\" && exit 1" \
  }, \
  "author": "", \
  "license": "ISC", \
  "dependencies": { \
    "http-proxy": "^1.18.1", \
    "unit-http": "^1.30.0" \
  } \
}' > /www/package.json

WORKDIR /www/
RUN npm install

EXPOSE 8080
EXPOSE 8765

CMD ["unitd","--no-daemon","--control","127.0.0.1:9999"]
