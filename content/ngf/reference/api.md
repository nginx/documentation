---
title: API reference
weight: 100
type: reference
product: NGF
nd-docs: DOCS-1855
---
## Overview
NGINX Gateway API Reference
<p>Packages:</p>
<ul>
<li>
<a href="#gateway.nginx.org%2fv1alpha1">gateway.nginx.org/v1alpha1</a>
</li>
<li>
<a href="#gateway.nginx.org%2fv1alpha2">gateway.nginx.org/v1alpha2</a>
</li>
</ul>
<h2 id="gateway.nginx.org/v1alpha1">gateway.nginx.org/v1alpha1</h2>
<p>
<p>Package v1alpha1 contains API Schema definitions for the
gateway.nginx.org API group.</p>
</p>
Resource Types:
<ul><li>
<a href="#gateway.nginx.org/v1alpha1.ClientSettingsPolicy">ClientSettingsPolicy</a>
</li><li>
<a href="#gateway.nginx.org/v1alpha1.NginxGateway">NginxGateway</a>
</li><li>
<a href="#gateway.nginx.org/v1alpha1.ObservabilityPolicy">ObservabilityPolicy</a>
</li><li>
<a href="#gateway.nginx.org/v1alpha1.SnippetsFilter">SnippetsFilter</a>
</li><li>
<a href="#gateway.nginx.org/v1alpha1.UpstreamSettingsPolicy">UpstreamSettingsPolicy</a>
</li></ul>
<h3 id="gateway.nginx.org/v1alpha1.ClientSettingsPolicy">ClientSettingsPolicy
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.ClientSettingsPolicy" title="Permanent link">¶</a>
</h3>
<p>
<p>ClientSettingsPolicy is an Inherited Attached Policy. It provides a way to configure the behavior of the connection
between the client and NGINX Gateway Fabric.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>apiVersion</code><br/>
string</td>
<td>
<code>
gateway.nginx.org/v1alpha1
</code>
</td>
</tr>
<tr>
<td>
<code>kind</code><br/>
string
</td>
<td><code>ClientSettingsPolicy</code></td>
</tr>
<tr>
<td>
<code>metadata</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#objectmeta-v1-meta">
Kubernetes meta/v1.ObjectMeta
</a>
</em>
</td>
<td>
Refer to the Kubernetes API documentation for the fields of the
<code>metadata</code> field.
</td>
</tr>
<tr>
<td>
<code>spec</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.ClientSettingsPolicySpec">
ClientSettingsPolicySpec
</a>
</em>
</td>
<td>
<p>Spec defines the desired state of the ClientSettingsPolicy.</p>
<br/>
<br/>
<table class="table table-bordered table-striped">
<tr>
<td>
<code>body</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.ClientBody">
ClientBody
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Body defines the client request body settings.</p>
</td>
</tr>
<tr>
<td>
<code>keepAlive</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.ClientKeepAlive">
ClientKeepAlive
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>KeepAlive defines the keep-alive settings.</p>
</td>
</tr>
<tr>
<td>
<code>targetRef</code><br/>
<em>
<a href="https://pkg.go.dev/sigs.k8s.io/gateway-api/apis/v1alpha2#LocalPolicyTargetReference">
sigs.k8s.io/gateway-api/apis/v1alpha2.LocalPolicyTargetReference
</a>
</em>
</td>
<td>
<p>TargetRef identifies an API object to apply the policy to.
Object must be in the same namespace as the policy.
Support: Gateway, HTTPRoute, GRPCRoute.</p>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td>
<code>status</code><br/>
<em>
<a href="https://pkg.go.dev/sigs.k8s.io/gateway-api/apis/v1alpha2#PolicyStatus">
sigs.k8s.io/gateway-api/apis/v1alpha2.PolicyStatus
</a>
</em>
</td>
<td>
<p>Status defines the state of the ClientSettingsPolicy.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.NginxGateway">NginxGateway
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.NginxGateway" title="Permanent link">¶</a>
</h3>
<p>
<p>NginxGateway represents the dynamic configuration for an NGINX Gateway Fabric control plane.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>apiVersion</code><br/>
string</td>
<td>
<code>
gateway.nginx.org/v1alpha1
</code>
</td>
</tr>
<tr>
<td>
<code>kind</code><br/>
string
</td>
<td><code>NginxGateway</code></td>
</tr>
<tr>
<td>
<code>metadata</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#objectmeta-v1-meta">
Kubernetes meta/v1.ObjectMeta
</a>
</em>
</td>
<td>
Refer to the Kubernetes API documentation for the fields of the
<code>metadata</code> field.
</td>
</tr>
<tr>
<td>
<code>spec</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.NginxGatewaySpec">
NginxGatewaySpec
</a>
</em>
</td>
<td>
<p>NginxGatewaySpec defines the desired state of the NginxGateway.</p>
<br/>
<br/>
<table class="table table-bordered table-striped">
<tr>
<td>
<code>logging</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Logging">
Logging
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Logging defines logging related settings for the control plane.</p>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td>
<code>status</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.NginxGatewayStatus">
NginxGatewayStatus
</a>
</em>
</td>
<td>
<p>NginxGatewayStatus defines the state of the NginxGateway.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.ObservabilityPolicy">ObservabilityPolicy
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.ObservabilityPolicy" title="Permanent link">¶</a>
</h3>
<p>
<p>ObservabilityPolicy is a Direct Attached Policy. It provides a way to configure observability settings for
the NGINX Gateway Fabric data plane. Used in conjunction with the NginxProxy CRD that is attached to the
GatewayClass parametersRef.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>apiVersion</code><br/>
string</td>
<td>
<code>
gateway.nginx.org/v1alpha1
</code>
</td>
</tr>
<tr>
<td>
<code>kind</code><br/>
string
</td>
<td><code>ObservabilityPolicy</code></td>
</tr>
<tr>
<td>
<code>metadata</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#objectmeta-v1-meta">
Kubernetes meta/v1.ObjectMeta
</a>
</em>
</td>
<td>
Refer to the Kubernetes API documentation for the fields of the
<code>metadata</code> field.
</td>
</tr>
<tr>
<td>
<code>spec</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.ObservabilityPolicySpec">
ObservabilityPolicySpec
</a>
</em>
</td>
<td>
<p>Spec defines the desired state of the ObservabilityPolicy.</p>
<br/>
<br/>
<table class="table table-bordered table-striped">
<tr>
<td>
<code>tracing</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Tracing">
Tracing
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Tracing allows for enabling and configuring tracing.</p>
</td>
</tr>
<tr>
<td>
<code>targetRefs</code><br/>
<em>
<a href="https://pkg.go.dev/sigs.k8s.io/gateway-api/apis/v1alpha2#LocalPolicyTargetReference">
[]sigs.k8s.io/gateway-api/apis/v1alpha2.LocalPolicyTargetReference
</a>
</em>
</td>
<td>
<p>TargetRefs identifies the API object(s) to apply the policy to.
Objects must be in the same namespace as the policy.
Support: HTTPRoute, GRPCRoute.</p>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td>
<code>status</code><br/>
<em>
<a href="https://pkg.go.dev/sigs.k8s.io/gateway-api/apis/v1alpha2#PolicyStatus">
sigs.k8s.io/gateway-api/apis/v1alpha2.PolicyStatus
</a>
</em>
</td>
<td>
<p>Status defines the state of the ObservabilityPolicy.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.SnippetsFilter">SnippetsFilter
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.SnippetsFilter" title="Permanent link">¶</a>
</h3>
<p>
<p>SnippetsFilter is a filter that allows inserting NGINX configuration into the
generated NGINX config for HTTPRoute and GRPCRoute resources.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>apiVersion</code><br/>
string</td>
<td>
<code>
gateway.nginx.org/v1alpha1
</code>
</td>
</tr>
<tr>
<td>
<code>kind</code><br/>
string
</td>
<td><code>SnippetsFilter</code></td>
</tr>
<tr>
<td>
<code>metadata</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#objectmeta-v1-meta">
Kubernetes meta/v1.ObjectMeta
</a>
</em>
</td>
<td>
Refer to the Kubernetes API documentation for the fields of the
<code>metadata</code> field.
</td>
</tr>
<tr>
<td>
<code>spec</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.SnippetsFilterSpec">
SnippetsFilterSpec
</a>
</em>
</td>
<td>
<p>Spec defines the desired state of the SnippetsFilter.</p>
<br/>
<br/>
<table class="table table-bordered table-striped">
<tr>
<td>
<code>snippets</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Snippet">
[]Snippet
</a>
</em>
</td>
<td>
<p>Snippets is a list of NGINX configuration snippets.
There can only be one snippet per context.
Allowed contexts: main, http, http.server, http.server.location.</p>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td>
<code>status</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.SnippetsFilterStatus">
SnippetsFilterStatus
</a>
</em>
</td>
<td>
<p>Status defines the state of the SnippetsFilter.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.UpstreamSettingsPolicy">UpstreamSettingsPolicy
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.UpstreamSettingsPolicy" title="Permanent link">¶</a>
</h3>
<p>
<p>UpstreamSettingsPolicy is a Direct Attached Policy. It provides a way to configure the behavior of
the connection between NGINX and the upstream applications.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>apiVersion</code><br/>
string</td>
<td>
<code>
gateway.nginx.org/v1alpha1
</code>
</td>
</tr>
<tr>
<td>
<code>kind</code><br/>
string
</td>
<td><code>UpstreamSettingsPolicy</code></td>
</tr>
<tr>
<td>
<code>metadata</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#objectmeta-v1-meta">
Kubernetes meta/v1.ObjectMeta
</a>
</em>
</td>
<td>
Refer to the Kubernetes API documentation for the fields of the
<code>metadata</code> field.
</td>
</tr>
<tr>
<td>
<code>spec</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.UpstreamSettingsPolicySpec">
UpstreamSettingsPolicySpec
</a>
</em>
</td>
<td>
<p>Spec defines the desired state of the UpstreamSettingsPolicy.</p>
<br/>
<br/>
<table class="table table-bordered table-striped">
<tr>
<td>
<code>zoneSize</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Size">
Size
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>ZoneSize is the size of the shared memory zone used by the upstream. This memory zone is used to share
the upstream configuration between nginx worker processes. The more servers that an upstream has,
the larger memory zone is required.
Default: OSS: 512k, Plus: 1m.
Directive: <a href="https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone">https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone</a></p>
</td>
</tr>
<tr>
<td>
<code>keepAlive</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.UpstreamKeepAlive">
UpstreamKeepAlive
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>KeepAlive defines the keep-alive settings.</p>
</td>
</tr>
<tr>
<td>
<code>targetRefs</code><br/>
<em>
<a href="https://pkg.go.dev/sigs.k8s.io/gateway-api/apis/v1alpha2#LocalPolicyTargetReference">
[]sigs.k8s.io/gateway-api/apis/v1alpha2.LocalPolicyTargetReference
</a>
</em>
</td>
<td>
<p>TargetRefs identifies API object(s) to apply the policy to.
Objects must be in the same namespace as the policy.
Support: Service</p>
<p>TargetRefs must be <em>distinct</em>. The <code>name</code> field must be unique for all targetRef entries in the UpstreamSettingsPolicy.</p>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td>
<code>status</code><br/>
<em>
<a href="https://pkg.go.dev/sigs.k8s.io/gateway-api/apis/v1alpha2#PolicyStatus">
sigs.k8s.io/gateway-api/apis/v1alpha2.PolicyStatus
</a>
</em>
</td>
<td>
<p>Status defines the state of the UpstreamSettingsPolicy.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.ClientBody">ClientBody
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.ClientBody" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.ClientSettingsPolicySpec">ClientSettingsPolicySpec</a>)
</p>
<p>
<p>ClientBody contains the settings for the client request body.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>maxSize</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Size">
Size
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>MaxSize sets the maximum allowed size of the client request body.
If the size in a request exceeds the configured value,
the 413 (Request Entity Too Large) error is returned to the client.
Setting size to 0 disables checking of client request body size.
Default: <a href="https://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size">https://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size</a>.</p>
</td>
</tr>
<tr>
<td>
<code>timeout</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Duration">
Duration
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Timeout defines a timeout for reading client request body. The timeout is set only for a period between
two successive read operations, not for the transmission of the whole request body.
If a client does not transmit anything within this time, the request is terminated with the
408 (Request Time-out) error.
Default: <a href="https://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_timeout">https://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_timeout</a>.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.ClientKeepAlive">ClientKeepAlive
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.ClientKeepAlive" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.ClientSettingsPolicySpec">ClientSettingsPolicySpec</a>)
</p>
<p>
<p>ClientKeepAlive defines the keep-alive settings for clients.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>requests</code><br/>
<em>
int32
</em>
</td>
<td>
<em>(Optional)</em>
<p>Requests sets the maximum number of requests that can be served through one keep-alive connection.
After the maximum number of requests are made, the connection is closed. Closing connections periodically
is necessary to free per-connection memory allocations. Therefore, using too high maximum number of requests
is not recommended as it can lead to excessive memory usage.
Default: <a href="https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_requests">https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_requests</a>.</p>
</td>
</tr>
<tr>
<td>
<code>time</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Duration">
Duration
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Time defines the maximum time during which requests can be processed through one keep-alive connection.
After this time is reached, the connection is closed following the subsequent request processing.
Default: <a href="https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_time">https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_time</a>.</p>
</td>
</tr>
<tr>
<td>
<code>timeout</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.ClientKeepAliveTimeout">
ClientKeepAliveTimeout
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Timeout defines the keep-alive timeouts for clients.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.ClientKeepAliveTimeout">ClientKeepAliveTimeout
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.ClientKeepAliveTimeout" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.ClientKeepAlive">ClientKeepAlive</a>)
</p>
<p>
<p>ClientKeepAliveTimeout defines the timeouts related to keep-alive client connections.
Default: <a href="https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_timeout">https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_timeout</a>.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>server</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Duration">
Duration
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Server sets the timeout during which a keep-alive client connection will stay open on the server side.
Setting this value to 0 disables keep-alive client connections.</p>
</td>
</tr>
<tr>
<td>
<code>header</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Duration">
Duration
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Header sets the timeout in the &ldquo;Keep-Alive: timeout=time&rdquo; response header field.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.ClientSettingsPolicySpec">ClientSettingsPolicySpec
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.ClientSettingsPolicySpec" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.ClientSettingsPolicy">ClientSettingsPolicy</a>)
</p>
<p>
<p>ClientSettingsPolicySpec defines the desired state of ClientSettingsPolicy.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>body</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.ClientBody">
ClientBody
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Body defines the client request body settings.</p>
</td>
</tr>
<tr>
<td>
<code>keepAlive</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.ClientKeepAlive">
ClientKeepAlive
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>KeepAlive defines the keep-alive settings.</p>
</td>
</tr>
<tr>
<td>
<code>targetRef</code><br/>
<em>
<a href="https://pkg.go.dev/sigs.k8s.io/gateway-api/apis/v1alpha2#LocalPolicyTargetReference">
sigs.k8s.io/gateway-api/apis/v1alpha2.LocalPolicyTargetReference
</a>
</em>
</td>
<td>
<p>TargetRef identifies an API object to apply the policy to.
Object must be in the same namespace as the policy.
Support: Gateway, HTTPRoute, GRPCRoute.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.ControllerLogLevel">ControllerLogLevel
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.ControllerLogLevel" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.Logging">Logging</a>)
</p>
<p>
<p>ControllerLogLevel type defines the logging level for the control plane.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;debug&#34;</p></td>
<td><p>ControllerLogLevelDebug is the debug level for control plane logging.</p>
</td>
</tr><tr><td><p>&#34;error&#34;</p></td>
<td><p>ControllerLogLevelError is the error level for control plane logging.</p>
</td>
</tr><tr><td><p>&#34;info&#34;</p></td>
<td><p>ControllerLogLevelInfo is the info level for control plane logging.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.ControllerStatus">ControllerStatus
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.ControllerStatus" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.SnippetsFilterStatus">SnippetsFilterStatus</a>)
</p>
<p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>controllerName</code><br/>
<em>
<a href="https://pkg.go.dev/sigs.k8s.io/gateway-api/apis/v1#GatewayController">
sigs.k8s.io/gateway-api/apis/v1.GatewayController
</a>
</em>
</td>
<td>
<p>ControllerName is a domain/path string that indicates the name of the
controller that wrote this status. This corresponds with the
controllerName field on GatewayClass.</p>
<p>Example: &ldquo;example.net/gateway-controller&rdquo;.</p>
<p>The format of this field is DOMAIN &ldquo;/&rdquo; PATH, where DOMAIN and PATH are
valid Kubernetes names
(<a href="https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names">https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names</a>).</p>
<p>Controllers MUST populate this field when writing status. Controllers should ensure that
entries to status populated with their ControllerName are cleaned up when they are no
longer necessary.</p>
</td>
</tr>
<tr>
<td>
<code>conditions</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#condition-v1-meta">
[]Kubernetes meta/v1.Condition
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Conditions describe the status of the SnippetsFilter.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.Duration">Duration
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.Duration" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.ClientBody">ClientBody</a>,
<a href="#gateway.nginx.org/v1alpha1.ClientKeepAlive">ClientKeepAlive</a>,
<a href="#gateway.nginx.org/v1alpha1.ClientKeepAliveTimeout">ClientKeepAliveTimeout</a>,
<a href="#gateway.nginx.org/v1alpha1.UpstreamKeepAlive">UpstreamKeepAlive</a>,
<a href="#gateway.nginx.org/v1alpha2.TelemetryExporter">TelemetryExporter</a>)
</p>
<p>
<p>Duration is a string value representing a duration in time.
Duration can be specified in milliseconds (ms), seconds (s), minutes (m), hours (h).
A value without a suffix is seconds.
Examples: 120s, 50ms, 5m, 1h.</p>
</p>
<h3 id="gateway.nginx.org/v1alpha1.Logging">Logging
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.Logging" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.NginxGatewaySpec">NginxGatewaySpec</a>)
</p>
<p>
<p>Logging defines logging related settings for the control plane.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>level</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.ControllerLogLevel">
ControllerLogLevel
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Level defines the logging level.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.NginxContext">NginxContext
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.NginxContext" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.Snippet">Snippet</a>)
</p>
<p>
<p>NginxContext represents the NGINX configuration context.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;http&#34;</p></td>
<td><p>NginxContextHTTP is the http context of the NGINX configuration.
<a href="https://nginx.org/en/docs/http/ngx_http_core_module.html#http">https://nginx.org/en/docs/http/ngx_http_core_module.html#http</a></p>
</td>
</tr><tr><td><p>&#34;http.server&#34;</p></td>
<td><p>NginxContextHTTPServer is the server context of the NGINX configuration.
<a href="https://nginx.org/en/docs/http/ngx_http_core_module.html#server">https://nginx.org/en/docs/http/ngx_http_core_module.html#server</a></p>
</td>
</tr><tr><td><p>&#34;http.server.location&#34;</p></td>
<td><p>NginxContextHTTPServerLocation is the location context of the NGINX configuration.
<a href="https://nginx.org/en/docs/http/ngx_http_core_module.html#location">https://nginx.org/en/docs/http/ngx_http_core_module.html#location</a></p>
</td>
</tr><tr><td><p>&#34;main&#34;</p></td>
<td><p>NginxContextMain is the main context of the NGINX configuration.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.NginxGatewayConditionReason">NginxGatewayConditionReason
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.NginxGatewayConditionReason" title="Permanent link">¶</a>
</h3>
<p>
<p>NginxGatewayConditionReason defines the set of reasons that explain why a
particular NginxGateway condition type has been raised.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;Invalid&#34;</p></td>
<td><p>NginxGatewayReasonInvalid is a reason that is used with the &ldquo;Valid&rdquo; condition when the condition is False.</p>
</td>
</tr><tr><td><p>&#34;Valid&#34;</p></td>
<td><p>NginxGatewayReasonValid is a reason that is used with the &ldquo;Valid&rdquo; condition when the condition is True.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.NginxGatewayConditionType">NginxGatewayConditionType
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.NginxGatewayConditionType" title="Permanent link">¶</a>
</h3>
<p>
<p>NginxGatewayConditionType is a type of condition associated with an
NginxGateway. This type should be used with the NginxGatewayStatus.Conditions field.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;Valid&#34;</p></td>
<td><p>NginxGatewayConditionValid is a condition that is true when the NginxGateway
configuration is syntactically and semantically valid.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.NginxGatewaySpec">NginxGatewaySpec
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.NginxGatewaySpec" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.NginxGateway">NginxGateway</a>)
</p>
<p>
<p>NginxGatewaySpec defines the desired state of the NginxGateway.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>logging</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Logging">
Logging
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Logging defines logging related settings for the control plane.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.NginxGatewayStatus">NginxGatewayStatus
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.NginxGatewayStatus" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.NginxGateway">NginxGateway</a>)
</p>
<p>
<p>NginxGatewayStatus defines the state of the NginxGateway.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>conditions</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#condition-v1-meta">
[]Kubernetes meta/v1.Condition
</a>
</em>
</td>
<td>
<em>(Optional)</em>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.ObservabilityPolicySpec">ObservabilityPolicySpec
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.ObservabilityPolicySpec" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.ObservabilityPolicy">ObservabilityPolicy</a>)
</p>
<p>
<p>ObservabilityPolicySpec defines the desired state of the ObservabilityPolicy.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>tracing</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Tracing">
Tracing
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Tracing allows for enabling and configuring tracing.</p>
</td>
</tr>
<tr>
<td>
<code>targetRefs</code><br/>
<em>
<a href="https://pkg.go.dev/sigs.k8s.io/gateway-api/apis/v1alpha2#LocalPolicyTargetReference">
[]sigs.k8s.io/gateway-api/apis/v1alpha2.LocalPolicyTargetReference
</a>
</em>
</td>
<td>
<p>TargetRefs identifies the API object(s) to apply the policy to.
Objects must be in the same namespace as the policy.
Support: HTTPRoute, GRPCRoute.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.Size">Size
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.Size" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.ClientBody">ClientBody</a>,
<a href="#gateway.nginx.org/v1alpha1.UpstreamSettingsPolicySpec">UpstreamSettingsPolicySpec</a>)
</p>
<p>
<p>Size is a string value representing a size. Size can be specified in bytes, kilobytes (k), megabytes (m),
or gigabytes (g).
Examples: 1024, 8k, 1m.</p>
</p>
<h3 id="gateway.nginx.org/v1alpha1.Snippet">Snippet
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.Snippet" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.SnippetsFilterSpec">SnippetsFilterSpec</a>)
</p>
<p>
<p>Snippet represents an NGINX configuration snippet.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>context</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.NginxContext">
NginxContext
</a>
</em>
</td>
<td>
<p>Context is the NGINX context to insert the snippet into.</p>
</td>
</tr>
<tr>
<td>
<code>value</code><br/>
<em>
string
</em>
</td>
<td>
<p>Value is the NGINX configuration snippet.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.SnippetsFilterConditionReason">SnippetsFilterConditionReason
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.SnippetsFilterConditionReason" title="Permanent link">¶</a>
</h3>
<p>
<p>SnippetsFilterConditionReason is a reason for a SnippetsFilter condition type.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;Accepted&#34;</p></td>
<td><p>SnippetsFilterConditionReasonAccepted is used with the Accepted condition type when
the condition is true.</p>
</td>
</tr><tr><td><p>&#34;Invalid&#34;</p></td>
<td><p>SnippetsFilterConditionReasonInvalid is used with the Accepted condition type when
SnippetsFilter is invalid.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.SnippetsFilterConditionType">SnippetsFilterConditionType
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.SnippetsFilterConditionType" title="Permanent link">¶</a>
</h3>
<p>
<p>SnippetsFilterConditionType is a type of condition associated with SnippetsFilter.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;Accepted&#34;</p></td>
<td><p>SnippetsFilterConditionTypeAccepted indicates that the SnippetsFilter is accepted.</p>
<p>Possible reasons for this condition to be True:</p>
<ul>
<li>Accepted</li>
</ul>
<p>Possible reasons for this condition to be False:</p>
<ul>
<li>Invalid.</li>
</ul>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.SnippetsFilterSpec">SnippetsFilterSpec
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.SnippetsFilterSpec" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.SnippetsFilter">SnippetsFilter</a>)
</p>
<p>
<p>SnippetsFilterSpec defines the desired state of the SnippetsFilter.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>snippets</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Snippet">
[]Snippet
</a>
</em>
</td>
<td>
<p>Snippets is a list of NGINX configuration snippets.
There can only be one snippet per context.
Allowed contexts: main, http, http.server, http.server.location.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.SnippetsFilterStatus">SnippetsFilterStatus
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.SnippetsFilterStatus" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.SnippetsFilter">SnippetsFilter</a>)
</p>
<p>
<p>SnippetsFilterStatus defines the state of SnippetsFilter.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>controllers</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.ControllerStatus">
[]ControllerStatus
</a>
</em>
</td>
<td>
<p>Controllers is a list of Gateway API controllers that processed the SnippetsFilter
and the status of the SnippetsFilter with respect to each controller.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.SpanAttribute">SpanAttribute
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.SpanAttribute" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.Tracing">Tracing</a>,
<a href="#gateway.nginx.org/v1alpha2.Telemetry">Telemetry</a>,
<a href="#gateway.nginx.org/v1alpha2.Tracing">Tracing</a>)
</p>
<p>
<p>SpanAttribute is a key value pair to be added to a tracing span.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>key</code><br/>
<em>
string
</em>
</td>
<td>
<p>Key is the key for a span attribute.
Format: must have all &lsquo;&ldquo;&rsquo; escaped and must not contain any &lsquo;$&rsquo; or end with an unescaped &lsquo;\&rsquo;</p>
</td>
</tr>
<tr>
<td>
<code>value</code><br/>
<em>
string
</em>
</td>
<td>
<p>Value is the value for a span attribute.
Format: must have all &lsquo;&ldquo;&rsquo; escaped and must not contain any &lsquo;$&rsquo; or end with an unescaped &lsquo;\&rsquo;</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.TraceContext">TraceContext
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.TraceContext" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.Tracing">Tracing</a>)
</p>
<p>
<p>TraceContext specifies how to propagate traceparent/tracestate headers.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;extract&#34;</p></td>
<td><p>TraceContextExtract uses an existing trace context from the request, so that the identifiers
of a trace and the parent span are inherited from the incoming request.</p>
</td>
</tr><tr><td><p>&#34;ignore&#34;</p></td>
<td><p>TraceContextIgnore skips context headers processing.</p>
</td>
</tr><tr><td><p>&#34;inject&#34;</p></td>
<td><p>TraceContextInject adds a new context to the request, overwriting existing headers, if any.</p>
</td>
</tr><tr><td><p>&#34;propagate&#34;</p></td>
<td><p>TraceContextPropagate updates the existing context (combines extract and inject).</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.TraceStrategy">TraceStrategy
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.TraceStrategy" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.Tracing">Tracing</a>)
</p>
<p>
<p>TraceStrategy defines the tracing strategy.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;parent&#34;</p></td>
<td><p>TraceStrategyParent enables tracing and only records spans if the parent span was sampled.</p>
</td>
</tr><tr><td><p>&#34;ratio&#34;</p></td>
<td><p>TraceStrategyRatio enables ratio-based tracing, defaulting to 100% sampling rate.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.Tracing">Tracing
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.Tracing" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.ObservabilityPolicySpec">ObservabilityPolicySpec</a>)
</p>
<p>
<p>Tracing allows for enabling and configuring OpenTelemetry tracing.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>strategy</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.TraceStrategy">
TraceStrategy
</a>
</em>
</td>
<td>
<p>Strategy defines if tracing is ratio-based or parent-based.</p>
</td>
</tr>
<tr>
<td>
<code>ratio</code><br/>
<em>
int32
</em>
</td>
<td>
<em>(Optional)</em>
<p>Ratio is the percentage of traffic that should be sampled. Integer from 0 to 100.
By default, 100% of http requests are traced. Not applicable for parent-based tracing.
If ratio is set to 0, tracing is disabled.</p>
</td>
</tr>
<tr>
<td>
<code>context</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.TraceContext">
TraceContext
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Context specifies how to propagate traceparent/tracestate headers.
Default: <a href="https://nginx.org/en/docs/ngx_otel_module.html#otel_trace_context">https://nginx.org/en/docs/ngx_otel_module.html#otel_trace_context</a></p>
</td>
</tr>
<tr>
<td>
<code>spanName</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>SpanName defines the name of the Otel span. By default is the name of the location for a request.
If specified, applies to all locations that are created for a route.
Format: must have all &lsquo;&ldquo;&rsquo; escaped and must not contain any &lsquo;$&rsquo; or end with an unescaped &lsquo;\&rsquo;
Examples of invalid names: some-$value, quoted-&ldquo;value&rdquo;-name, unescaped</p>
</td>
</tr>
<tr>
<td>
<code>spanAttributes</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.SpanAttribute">
[]SpanAttribute
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>SpanAttributes are custom key/value attributes that are added to each span.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.UpstreamKeepAlive">UpstreamKeepAlive
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.UpstreamKeepAlive" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.UpstreamSettingsPolicySpec">UpstreamSettingsPolicySpec</a>)
</p>
<p>
<p>UpstreamKeepAlive defines the keep-alive settings for upstreams.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>connections</code><br/>
<em>
int32
</em>
</td>
<td>
<em>(Optional)</em>
<p>Connections sets the maximum number of idle keep-alive connections to upstream servers that are preserved
in the cache of each nginx worker process. When this number is exceeded, the least recently used
connections are closed.
Directive: <a href="https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive">https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive</a></p>
</td>
</tr>
<tr>
<td>
<code>requests</code><br/>
<em>
int32
</em>
</td>
<td>
<em>(Optional)</em>
<p>Requests sets the maximum number of requests that can be served through one keep-alive connection.
After the maximum number of requests are made, the connection is closed.
Directive: <a href="https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_requests">https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_requests</a></p>
</td>
</tr>
<tr>
<td>
<code>time</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Duration">
Duration
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Time defines the maximum time during which requests can be processed through one keep-alive connection.
After this time is reached, the connection is closed following the subsequent request processing.
Directive: <a href="https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_time">https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_time</a></p>
</td>
</tr>
<tr>
<td>
<code>timeout</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Duration">
Duration
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Timeout defines the keep-alive timeout for upstreams.
Directive: <a href="https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_timeout">https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_timeout</a></p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha1.UpstreamSettingsPolicySpec">UpstreamSettingsPolicySpec
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha1.UpstreamSettingsPolicySpec" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha1.UpstreamSettingsPolicy">UpstreamSettingsPolicy</a>)
</p>
<p>
<p>UpstreamSettingsPolicySpec defines the desired state of the UpstreamSettingsPolicy.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>zoneSize</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Size">
Size
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>ZoneSize is the size of the shared memory zone used by the upstream. This memory zone is used to share
the upstream configuration between nginx worker processes. The more servers that an upstream has,
the larger memory zone is required.
Default: OSS: 512k, Plus: 1m.
Directive: <a href="https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone">https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone</a></p>
</td>
</tr>
<tr>
<td>
<code>keepAlive</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.UpstreamKeepAlive">
UpstreamKeepAlive
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>KeepAlive defines the keep-alive settings.</p>
</td>
</tr>
<tr>
<td>
<code>targetRefs</code><br/>
<em>
<a href="https://pkg.go.dev/sigs.k8s.io/gateway-api/apis/v1alpha2#LocalPolicyTargetReference">
[]sigs.k8s.io/gateway-api/apis/v1alpha2.LocalPolicyTargetReference
</a>
</em>
</td>
<td>
<p>TargetRefs identifies API object(s) to apply the policy to.
Objects must be in the same namespace as the policy.
Support: Service</p>
<p>TargetRefs must be <em>distinct</em>. The <code>name</code> field must be unique for all targetRef entries in the UpstreamSettingsPolicy.</p>
</td>
</tr>
</tbody>
</table>
<hr/>
<h2 id="gateway.nginx.org/v1alpha2">gateway.nginx.org/v1alpha2</h2>
<p>
<p>Package v1alpha2 contains API Schema definitions for the
gateway.nginx.org API group.</p>
</p>
Resource Types:
<ul><li>
<a href="#gateway.nginx.org/v1alpha2.NginxProxy">NginxProxy</a>
</li><li>
<a href="#gateway.nginx.org/v1alpha2.ObservabilityPolicy">ObservabilityPolicy</a>
</li></ul>
<h3 id="gateway.nginx.org/v1alpha2.NginxProxy">NginxProxy
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.NginxProxy" title="Permanent link">¶</a>
</h3>
<p>
<p>NginxProxy is a configuration object that can be referenced from a GatewayClass parametersRef
or a Gateway infrastructure.parametersRef. It provides a way to configure data plane settings.
If referenced from a GatewayClass, the settings apply to all Gateways attached to the GatewayClass.
If referenced from a Gateway, the settings apply to that Gateway alone. If both a Gateway and its GatewayClass
reference an NginxProxy, the settings are merged. Settings specified on the Gateway NginxProxy override those
set on the GatewayClass NginxProxy.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>apiVersion</code><br/>
string</td>
<td>
<code>
gateway.nginx.org/v1alpha2
</code>
</td>
</tr>
<tr>
<td>
<code>kind</code><br/>
string
</td>
<td><code>NginxProxy</code></td>
</tr>
<tr>
<td>
<code>metadata</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#objectmeta-v1-meta">
Kubernetes meta/v1.ObjectMeta
</a>
</em>
</td>
<td>
Refer to the Kubernetes API documentation for the fields of the
<code>metadata</code> field.
</td>
</tr>
<tr>
<td>
<code>spec</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.NginxProxySpec">
NginxProxySpec
</a>
</em>
</td>
<td>
<p>Spec defines the desired state of the NginxProxy.</p>
<br/>
<br/>
<table class="table table-bordered table-striped">
<tr>
<td>
<code>ipFamily</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.IPFamilyType">
IPFamilyType
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>IPFamily specifies the IP family to be used by the NGINX.
Default is &ldquo;dual&rdquo;, meaning the server will use both IPv4 and IPv6.</p>
</td>
</tr>
<tr>
<td>
<code>telemetry</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.Telemetry">
Telemetry
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Telemetry specifies the OpenTelemetry configuration.</p>
</td>
</tr>
<tr>
<td>
<code>metrics</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.Metrics">
Metrics
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Metrics defines the configuration for Prometheus scraping metrics. Changing this value results in a
re-roll of the NGINX deployment.</p>
</td>
</tr>
<tr>
<td>
<code>rewriteClientIP</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.RewriteClientIP">
RewriteClientIP
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>RewriteClientIP defines configuration for rewriting the client IP to the original client&rsquo;s IP.</p>
</td>
</tr>
<tr>
<td>
<code>logging</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.NginxLogging">
NginxLogging
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Logging defines logging related settings for NGINX.</p>
</td>
</tr>
<tr>
<td>
<code>nginxPlus</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.NginxPlus">
NginxPlus
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>NginxPlus specifies NGINX Plus additional settings.</p>
</td>
</tr>
<tr>
<td>
<code>disableHTTP2</code><br/>
<em>
bool
</em>
</td>
<td>
<em>(Optional)</em>
<p>DisableHTTP2 defines if http2 should be disabled for all servers.
If not specified, or set to false, http2 will be enabled for all servers.</p>
</td>
</tr>
<tr>
<td>
<code>kubernetes</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.KubernetesSpec">
KubernetesSpec
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Kubernetes contains the configuration for the NGINX Deployment and Service Kubernetes objects.</p>
</td>
</tr>
</table>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.ObservabilityPolicy">ObservabilityPolicy
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.ObservabilityPolicy" title="Permanent link">¶</a>
</h3>
<p>
<p>ObservabilityPolicy is a Direct Attached Policy. It provides a way to configure observability settings for
the NGINX Gateway Fabric data plane. Used in conjunction with the NginxProxy CRD that is attached to the
GatewayClass parametersRef.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>apiVersion</code><br/>
string</td>
<td>
<code>
gateway.nginx.org/v1alpha2
</code>
</td>
</tr>
<tr>
<td>
<code>kind</code><br/>
string
</td>
<td><code>ObservabilityPolicy</code></td>
</tr>
<tr>
<td>
<code>metadata</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#objectmeta-v1-meta">
Kubernetes meta/v1.ObjectMeta
</a>
</em>
</td>
<td>
Refer to the Kubernetes API documentation for the fields of the
<code>metadata</code> field.
</td>
</tr>
<tr>
<td>
<code>spec</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.ObservabilityPolicySpec">
ObservabilityPolicySpec
</a>
</em>
</td>
<td>
<p>Spec defines the desired state of the ObservabilityPolicy.</p>
<br/>
<br/>
<table class="table table-bordered table-striped">
<tr>
<td>
<code>tracing</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.Tracing">
Tracing
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Tracing allows for enabling and configuring tracing.</p>
</td>
</tr>
<tr>
<td>
<code>targetRefs</code><br/>
<em>
<a href="https://pkg.go.dev/sigs.k8s.io/gateway-api/apis/v1alpha2#LocalPolicyTargetReference">
[]sigs.k8s.io/gateway-api/apis/v1alpha2.LocalPolicyTargetReference
</a>
</em>
</td>
<td>
<p>TargetRefs identifies the API object(s) to apply the policy to.
Objects must be in the same namespace as the policy.
Support: HTTPRoute, GRPCRoute.</p>
<p>TargetRefs must be <em>distinct</em>. This means that the multi-part key defined by <code>kind</code> and <code>name</code> must
be unique across all targetRef entries in the ObservabilityPolicy.</p>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td>
<code>status</code><br/>
<em>
<a href="https://pkg.go.dev/sigs.k8s.io/gateway-api/apis/v1alpha2#PolicyStatus">
sigs.k8s.io/gateway-api/apis/v1alpha2.PolicyStatus
</a>
</em>
</td>
<td>
<p>Status defines the state of the ObservabilityPolicy.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.AgentLogLevel">AgentLogLevel
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.AgentLogLevel" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.NginxLogging">NginxLogging</a>)
</p>
<p>
<p>AgentLevel defines the log level of the NGINX agent process.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;debug&#34;</p></td>
<td><p>AgentLogLevelDebug is the debug level NGINX agent logs.</p>
</td>
</tr><tr><td><p>&#34;error&#34;</p></td>
<td><p>AgentLogLevelError is the error level NGINX agent logs.</p>
</td>
</tr><tr><td><p>&#34;fatal&#34;</p></td>
<td><p>AgentLogLevelFatal is the fatal level NGINX agent logs.</p>
</td>
</tr><tr><td><p>&#34;info&#34;</p></td>
<td><p>AgentLogLevelInfo is the info level NGINX agent logs.</p>
</td>
</tr><tr><td><p>&#34;panic&#34;</p></td>
<td><p>AgentLogLevelPanic is the panic level NGINX agent logs.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.ContainerSpec">ContainerSpec
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.ContainerSpec" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.DaemonSetSpec">DaemonSetSpec</a>,
<a href="#gateway.nginx.org/v1alpha2.DeploymentSpec">DeploymentSpec</a>)
</p>
<p>
<p>ContainerSpec defines container fields for the NGINX container.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>debug</code><br/>
<em>
bool
</em>
</td>
<td>
<em>(Optional)</em>
<p>Debug enables debugging for NGINX by using the nginx-debug binary.</p>
</td>
</tr>
<tr>
<td>
<code>image</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.Image">
Image
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Image is the NGINX image to use.</p>
</td>
</tr>
<tr>
<td>
<code>resources</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#resourcerequirements-v1-core">
Kubernetes core/v1.ResourceRequirements
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Resources describes the compute resource requirements.</p>
</td>
</tr>
<tr>
<td>
<code>lifecycle</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#lifecycle-v1-core">
Kubernetes core/v1.Lifecycle
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Lifecycle describes actions that the management system should take in response to container lifecycle
events. For the PostStart and PreStop lifecycle handlers, management of the container blocks
until the action is complete, unless the container process fails, in which case the handler is aborted.</p>
</td>
</tr>
<tr>
<td>
<code>volumeMounts</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#volumemount-v1-core">
[]Kubernetes core/v1.VolumeMount
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>VolumeMounts describe the mounting of Volumes within a container.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.DaemonSetSpec">DaemonSetSpec
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.DaemonSetSpec" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.KubernetesSpec">KubernetesSpec</a>)
</p>
<p>
<p>DaemonSet is the configuration for the NGINX DaemonSet.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>pod</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.PodSpec">
PodSpec
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Pod defines Pod-specific fields.</p>
</td>
</tr>
<tr>
<td>
<code>container</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.ContainerSpec">
ContainerSpec
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Container defines container fields for the NGINX container.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.DeploymentSpec">DeploymentSpec
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.DeploymentSpec" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.KubernetesSpec">KubernetesSpec</a>)
</p>
<p>
<p>Deployment is the configuration for the NGINX Deployment.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>replicas</code><br/>
<em>
int32
</em>
</td>
<td>
<em>(Optional)</em>
<p>Number of desired Pods.</p>
</td>
</tr>
<tr>
<td>
<code>pod</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.PodSpec">
PodSpec
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Pod defines Pod-specific fields.</p>
</td>
</tr>
<tr>
<td>
<code>container</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.ContainerSpec">
ContainerSpec
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Container defines container fields for the NGINX container.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.DisableTelemetryFeature">DisableTelemetryFeature
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.DisableTelemetryFeature" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.Telemetry">Telemetry</a>)
</p>
<p>
<p>DisableTelemetryFeature is a telemetry feature that can be disabled.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;DisableTracing&#34;</p></td>
<td><p>DisableTracing disables the OpenTelemetry tracing feature.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.ExternalTrafficPolicy">ExternalTrafficPolicy
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.ExternalTrafficPolicy" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.ServiceSpec">ServiceSpec</a>)
</p>
<p>
<p>ExternalTrafficPolicy describes how nodes distribute service traffic they
receive on one of the Service&rsquo;s &ldquo;externally-facing&rdquo; addresses (NodePorts, ExternalIPs,
and LoadBalancer IPs. Ignored for ClusterIP services.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;Cluster&#34;</p></td>
<td><p>ExternalTrafficPolicyCluster routes traffic to all endpoints.</p>
</td>
</tr><tr><td><p>&#34;Local&#34;</p></td>
<td><p>ExternalTrafficPolicyLocal preserves the source IP of the traffic by
routing only to endpoints on the same node as the traffic was received on
(dropping the traffic if there are no local endpoints).</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.IPFamilyType">IPFamilyType
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.IPFamilyType" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.NginxProxySpec">NginxProxySpec</a>)
</p>
<p>
<p>IPFamilyType specifies the IP family to be used by NGINX.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;dual&#34;</p></td>
<td><p>Dual specifies that NGINX will use both IPv4 and IPv6.</p>
</td>
</tr><tr><td><p>&#34;ipv4&#34;</p></td>
<td><p>IPv4 specifies that NGINX will use only IPv4.</p>
</td>
</tr><tr><td><p>&#34;ipv6&#34;</p></td>
<td><p>IPv6 specifies that NGINX will use only IPv6.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.Image">Image
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.Image" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.ContainerSpec">ContainerSpec</a>)
</p>
<p>
<p>Image is the NGINX image to use.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>repository</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>Repository is the image path.
Default is ghcr.io/nginx/nginx-gateway-fabric/nginx.</p>
</td>
</tr>
<tr>
<td>
<code>tag</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>Tag is the image tag to use. Default matches the tag of the control plane.</p>
</td>
</tr>
<tr>
<td>
<code>pullPolicy</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.PullPolicy">
PullPolicy
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>PullPolicy describes a policy for if/when to pull a container image.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.KubernetesSpec">KubernetesSpec
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.KubernetesSpec" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.NginxProxySpec">NginxProxySpec</a>)
</p>
<p>
<p>KubernetesSpec contains the configuration for the NGINX Deployment and Service Kubernetes objects.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>deployment</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.DeploymentSpec">
DeploymentSpec
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Deployment is the configuration for the NGINX Deployment.
This is the default deployment option.</p>
</td>
</tr>
<tr>
<td>
<code>daemonSet</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.DaemonSetSpec">
DaemonSetSpec
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>DaemonSet is the configuration for the NGINX DaemonSet.</p>
</td>
</tr>
<tr>
<td>
<code>service</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.ServiceSpec">
ServiceSpec
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Service is the configuration for the NGINX Service.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.Metrics">Metrics
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.Metrics" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.NginxProxySpec">NginxProxySpec</a>)
</p>
<p>
<p>Metrics defines the configuration for Prometheus scraping metrics.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>port</code><br/>
<em>
int32
</em>
</td>
<td>
<em>(Optional)</em>
<p>Port where the Prometheus metrics are exposed.</p>
</td>
</tr>
<tr>
<td>
<code>disable</code><br/>
<em>
bool
</em>
</td>
<td>
<em>(Optional)</em>
<p>Disable serving Prometheus metrics on the listen port.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.NginxErrorLogLevel">NginxErrorLogLevel
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.NginxErrorLogLevel" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.NginxLogging">NginxLogging</a>)
</p>
<p>
<p>NginxErrorLogLevel type defines the log level of error logs for NGINX.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;alert&#34;</p></td>
<td><p>NginxLogLevelAlert is the alert level for NGINX error logs.</p>
</td>
</tr><tr><td><p>&#34;crit&#34;</p></td>
<td><p>NginxLogLevelCrit is the crit level for NGINX error logs.</p>
</td>
</tr><tr><td><p>&#34;debug&#34;</p></td>
<td><p>NginxLogLevelDebug is the debug level for NGINX error logs.</p>
</td>
</tr><tr><td><p>&#34;emerg&#34;</p></td>
<td><p>NginxLogLevelEmerg is the emerg level for NGINX error logs.</p>
</td>
</tr><tr><td><p>&#34;error&#34;</p></td>
<td><p>NginxLogLevelError is the error level for NGINX error logs.</p>
</td>
</tr><tr><td><p>&#34;info&#34;</p></td>
<td><p>NginxLogLevelInfo is the info level for NGINX error logs.</p>
</td>
</tr><tr><td><p>&#34;notice&#34;</p></td>
<td><p>NginxLogLevelNotice is the notice level for NGINX error logs.</p>
</td>
</tr><tr><td><p>&#34;warn&#34;</p></td>
<td><p>NginxLogLevelWarn is the warn level for NGINX error logs.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.NginxLogging">NginxLogging
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.NginxLogging" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.NginxProxySpec">NginxProxySpec</a>)
</p>
<p>
<p>NginxLogging defines logging related settings for NGINX.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>errorLevel</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.NginxErrorLogLevel">
NginxErrorLogLevel
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>ErrorLevel defines the error log level. Possible log levels listed in order of increasing severity are
debug, info, notice, warn, error, crit, alert, and emerg. Setting a certain log level will cause all messages
of the specified and more severe log levels to be logged. For example, the log level &lsquo;error&rsquo; will cause error,
crit, alert, and emerg messages to be logged. <a href="https://nginx.org/en/docs/ngx_core_module.html#error_log">https://nginx.org/en/docs/ngx_core_module.html#error_log</a></p>
</td>
</tr>
<tr>
<td>
<code>agentLevel</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.AgentLogLevel">
AgentLogLevel
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>AgentLevel defines the log level of the NGINX agent process. Changing this value results in a
re-roll of the NGINX deployment.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.NginxPlus">NginxPlus
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.NginxPlus" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.NginxProxySpec">NginxProxySpec</a>)
</p>
<p>
<p>NginxPlus specifies NGINX Plus additional settings. These will only be applied if NGINX Plus is being used.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>allowedAddresses</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.NginxPlusAllowAddress">
[]NginxPlusAllowAddress
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>AllowedAddresses specifies IPAddresses or CIDR blocks to the allow list for accessing the NGINX Plus API.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.NginxPlusAllowAddress">NginxPlusAllowAddress
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.NginxPlusAllowAddress" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.NginxPlus">NginxPlus</a>)
</p>
<p>
<p>NginxPlusAllowAddress specifies the address type and value for an NginxPlus allow address.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>type</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.NginxPlusAllowAddressType">
NginxPlusAllowAddressType
</a>
</em>
</td>
<td>
<p>Type specifies the type of address.</p>
</td>
</tr>
<tr>
<td>
<code>value</code><br/>
<em>
string
</em>
</td>
<td>
<p>Value specifies the address value.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.NginxPlusAllowAddressType">NginxPlusAllowAddressType
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.NginxPlusAllowAddressType" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.NginxPlusAllowAddress">NginxPlusAllowAddress</a>)
</p>
<p>
<p>NginxPlusAllowAddressType specifies the type of address.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;CIDR&#34;</p></td>
<td><p>NginxPlusAllowCIDRAddressType specifies that the address is a CIDR block.</p>
</td>
</tr><tr><td><p>&#34;IPAddress&#34;</p></td>
<td><p>NginxPlusAllowIPAddressType specifies that the address is an IP address.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.NginxProxySpec">NginxProxySpec
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.NginxProxySpec" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.NginxProxy">NginxProxy</a>)
</p>
<p>
<p>NginxProxySpec defines the desired state of the NginxProxy.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>ipFamily</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.IPFamilyType">
IPFamilyType
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>IPFamily specifies the IP family to be used by the NGINX.
Default is &ldquo;dual&rdquo;, meaning the server will use both IPv4 and IPv6.</p>
</td>
</tr>
<tr>
<td>
<code>telemetry</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.Telemetry">
Telemetry
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Telemetry specifies the OpenTelemetry configuration.</p>
</td>
</tr>
<tr>
<td>
<code>metrics</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.Metrics">
Metrics
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Metrics defines the configuration for Prometheus scraping metrics. Changing this value results in a
re-roll of the NGINX deployment.</p>
</td>
</tr>
<tr>
<td>
<code>rewriteClientIP</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.RewriteClientIP">
RewriteClientIP
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>RewriteClientIP defines configuration for rewriting the client IP to the original client&rsquo;s IP.</p>
</td>
</tr>
<tr>
<td>
<code>logging</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.NginxLogging">
NginxLogging
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Logging defines logging related settings for NGINX.</p>
</td>
</tr>
<tr>
<td>
<code>nginxPlus</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.NginxPlus">
NginxPlus
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>NginxPlus specifies NGINX Plus additional settings.</p>
</td>
</tr>
<tr>
<td>
<code>disableHTTP2</code><br/>
<em>
bool
</em>
</td>
<td>
<em>(Optional)</em>
<p>DisableHTTP2 defines if http2 should be disabled for all servers.
If not specified, or set to false, http2 will be enabled for all servers.</p>
</td>
</tr>
<tr>
<td>
<code>kubernetes</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.KubernetesSpec">
KubernetesSpec
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Kubernetes contains the configuration for the NGINX Deployment and Service Kubernetes objects.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.NodePort">NodePort
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.NodePort" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.ServiceSpec">ServiceSpec</a>)
</p>
<p>
<p>NodePort creates a port on each node on which the NGINX data plane service is exposed. The NodePort MUST
map to a Gateway listener port, otherwise it will be ignored. If not specified, Kubernetes allocates a NodePort
automatically if required. The default NodePort range enforced by Kubernetes is 30000-32767.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>port</code><br/>
<em>
int32
</em>
</td>
<td>
<p>Port is the NodePort to expose.
kubebuilder:validation:Minimum=1
kubebuilder:validation:Maximum=65535</p>
</td>
</tr>
<tr>
<td>
<code>listenerPort</code><br/>
<em>
int32
</em>
</td>
<td>
<p>ListenerPort is the Gateway listener port that this NodePort maps to.
kubebuilder:validation:Minimum=1
kubebuilder:validation:Maximum=65535</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.ObservabilityPolicySpec">ObservabilityPolicySpec
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.ObservabilityPolicySpec" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.ObservabilityPolicy">ObservabilityPolicy</a>)
</p>
<p>
<p>ObservabilityPolicySpec defines the desired state of the ObservabilityPolicy.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>tracing</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.Tracing">
Tracing
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Tracing allows for enabling and configuring tracing.</p>
</td>
</tr>
<tr>
<td>
<code>targetRefs</code><br/>
<em>
<a href="https://pkg.go.dev/sigs.k8s.io/gateway-api/apis/v1alpha2#LocalPolicyTargetReference">
[]sigs.k8s.io/gateway-api/apis/v1alpha2.LocalPolicyTargetReference
</a>
</em>
</td>
<td>
<p>TargetRefs identifies the API object(s) to apply the policy to.
Objects must be in the same namespace as the policy.
Support: HTTPRoute, GRPCRoute.</p>
<p>TargetRefs must be <em>distinct</em>. This means that the multi-part key defined by <code>kind</code> and <code>name</code> must
be unique across all targetRef entries in the ObservabilityPolicy.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.PodSpec">PodSpec
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.PodSpec" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.DaemonSetSpec">DaemonSetSpec</a>,
<a href="#gateway.nginx.org/v1alpha2.DeploymentSpec">DeploymentSpec</a>)
</p>
<p>
<p>PodSpec defines Pod-specific fields.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>terminationGracePeriodSeconds</code><br/>
<em>
int64
</em>
</td>
<td>
<em>(Optional)</em>
<p>TerminationGracePeriodSeconds is the optional duration in seconds the pod needs to terminate gracefully.
Value must be non-negative integer. The value zero indicates stop immediately via
the kill signal (no opportunity to shut down).
If this value is nil, the default grace period will be used instead.
The grace period is the duration in seconds after the processes running in the pod are sent
a termination signal and the time when the processes are forcibly halted with a kill signal.
Set this value longer than the expected cleanup time for your process.
Defaults to 30 seconds.</p>
</td>
</tr>
<tr>
<td>
<code>affinity</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#affinity-v1-core">
Kubernetes core/v1.Affinity
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Affinity is the pod&rsquo;s scheduling constraints.</p>
</td>
</tr>
<tr>
<td>
<code>nodeSelector</code><br/>
<em>
map[string]string
</em>
</td>
<td>
<em>(Optional)</em>
<p>NodeSelector is a selector which must be true for the pod to fit on a node.
Selector which must match a node&rsquo;s labels for the pod to be scheduled on that node.</p>
</td>
</tr>
<tr>
<td>
<code>tolerations</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#toleration-v1-core">
[]Kubernetes core/v1.Toleration
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Tolerations allow the scheduler to schedule Pods with matching taints.</p>
</td>
</tr>
<tr>
<td>
<code>volumes</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#volume-v1-core">
[]Kubernetes core/v1.Volume
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Volumes represents named volumes in a pod that may be accessed by any container in the pod.</p>
</td>
</tr>
<tr>
<td>
<code>topologySpreadConstraints</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#topologyspreadconstraint-v1-core">
[]Kubernetes core/v1.TopologySpreadConstraint
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>TopologySpreadConstraints describes how a group of Pods ought to spread across topology
domains. Scheduler will schedule Pods in a way which abides by the constraints.
All topologySpreadConstraints are ANDed.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.PullPolicy">PullPolicy
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.PullPolicy" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.Image">Image</a>)
</p>
<p>
<p>PullPolicy describes a policy for if/when to pull a container image.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;Always&#34;</p></td>
<td><p>PullAlways means that kubelet always attempts to pull the latest image. Container will fail if the pull fails.</p>
</td>
</tr><tr><td><p>&#34;IfNotPresent&#34;</p></td>
<td><p>PullIfNotPresent means that kubelet pulls if the image isn&rsquo;t present on disk. Container will fail if the image
isn&rsquo;t present and the pull fails.</p>
</td>
</tr><tr><td><p>&#34;Never&#34;</p></td>
<td><p>PullNever means that kubelet never pulls an image, but only uses a local image. Container will fail if the
image isn&rsquo;t present.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.RewriteClientIP">RewriteClientIP
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.RewriteClientIP" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.NginxProxySpec">NginxProxySpec</a>)
</p>
<p>
<p>RewriteClientIP specifies the configuration for rewriting the client&rsquo;s IP address.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>mode</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.RewriteClientIPModeType">
RewriteClientIPModeType
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Mode defines how NGINX will rewrite the client&rsquo;s IP address.
There are two possible modes:
- ProxyProtocol: NGINX will rewrite the client&rsquo;s IP using the PROXY protocol header.
- XForwardedFor: NGINX will rewrite the client&rsquo;s IP using the X-Forwarded-For header.
Sets NGINX directive real_ip_header: <a href="https://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_header">https://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_header</a></p>
</td>
</tr>
<tr>
<td>
<code>setIPRecursively</code><br/>
<em>
bool
</em>
</td>
<td>
<em>(Optional)</em>
<p>SetIPRecursively configures whether recursive search is used when selecting the client&rsquo;s address from
the X-Forwarded-For header. It is used in conjunction with TrustedAddresses.
If enabled, NGINX will recurse on the values in X-Forwarded-Header from the end of array
to start of array and select the first untrusted IP.
For example, if X-Forwarded-For is [11.11.11.11, 22.22.22.22, 55.55.55.1],
and TrustedAddresses is set to 55.55.55.<sup>1</sup>&frasl;<sub>32</sub>, NGINX will rewrite the client IP to 22.22.22.22.
If disabled, NGINX will select the IP at the end of the array.
In the previous example, 55.55.55.1 would be selected.
Sets NGINX directive real_ip_recursive: <a href="https://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_recursive">https://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_recursive</a></p>
</td>
</tr>
<tr>
<td>
<code>trustedAddresses</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.RewriteClientIPAddress">
[]RewriteClientIPAddress
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>TrustedAddresses specifies the addresses that are trusted to send correct client IP information.
If a request comes from a trusted address, NGINX will rewrite the client IP information,
and forward it to the backend in the X-Forwarded-For* and X-Real-IP headers.
If the request does not come from a trusted address, NGINX will not rewrite the client IP information.
To trust all addresses (not recommended for production), set to 0.0.0.0/0.
If no addresses are provided, NGINX will not rewrite the client IP information.
Sets NGINX directive set_real_ip_from: <a href="https://nginx.org/en/docs/http/ngx_http_realip_module.html#set_real_ip_from">https://nginx.org/en/docs/http/ngx_http_realip_module.html#set_real_ip_from</a>
This field is required if mode is set.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.RewriteClientIPAddress">RewriteClientIPAddress
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.RewriteClientIPAddress" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.RewriteClientIP">RewriteClientIP</a>)
</p>
<p>
<p>RewriteClientIPAddress specifies the address type and value for a RewriteClientIP address.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>type</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.RewriteClientIPAddressType">
RewriteClientIPAddressType
</a>
</em>
</td>
<td>
<p>Type specifies the type of address.</p>
</td>
</tr>
<tr>
<td>
<code>value</code><br/>
<em>
string
</em>
</td>
<td>
<p>Value specifies the address value.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.RewriteClientIPAddressType">RewriteClientIPAddressType
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.RewriteClientIPAddressType" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.RewriteClientIPAddress">RewriteClientIPAddress</a>)
</p>
<p>
<p>RewriteClientIPAddressType specifies the type of address.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;CIDR&#34;</p></td>
<td><p>RewriteClientIPCIDRAddressType specifies that the address is a CIDR block.</p>
</td>
</tr><tr><td><p>&#34;Hostname&#34;</p></td>
<td><p>RewriteClientIPHostnameAddressType specifies that the address is a Hostname.</p>
</td>
</tr><tr><td><p>&#34;IPAddress&#34;</p></td>
<td><p>RewriteClientIPIPAddressType specifies that the address is an IP address.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.RewriteClientIPModeType">RewriteClientIPModeType
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.RewriteClientIPModeType" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.RewriteClientIP">RewriteClientIP</a>)
</p>
<p>
<p>RewriteClientIPModeType defines how NGINX Gateway Fabric will determine the client&rsquo;s original IP address.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;ProxyProtocol&#34;</p></td>
<td><p>RewriteClientIPModeProxyProtocol configures NGINX to accept PROXY protocol and
set the client&rsquo;s IP address to the IP address in the PROXY protocol header.
Sets the proxy_protocol parameter on the listen directive of all servers and sets real_ip_header
to proxy_protocol: <a href="https://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_header">https://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_header</a>.</p>
</td>
</tr><tr><td><p>&#34;XForwardedFor&#34;</p></td>
<td><p>RewriteClientIPModeXForwardedFor configures NGINX to set the client&rsquo;s IP address to the
IP address in the X-Forwarded-For HTTP header.
<a href="https://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_header">https://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_header</a>.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.ServiceSpec">ServiceSpec
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.ServiceSpec" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.KubernetesSpec">KubernetesSpec</a>)
</p>
<p>
<p>ServiceSpec is the configuration for the NGINX Service.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>type</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.ServiceType">
ServiceType
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>ServiceType describes ingress method for the Service.</p>
</td>
</tr>
<tr>
<td>
<code>externalTrafficPolicy</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.ExternalTrafficPolicy">
ExternalTrafficPolicy
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>ExternalTrafficPolicy describes how nodes distribute service traffic they
receive on one of the Service&rsquo;s &ldquo;externally-facing&rdquo; addresses (NodePorts, ExternalIPs,
and LoadBalancer IPs.</p>
</td>
</tr>
<tr>
<td>
<code>loadBalancerIP</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>LoadBalancerIP is a static IP address for the load balancer. Requires service type to be LoadBalancer.</p>
</td>
</tr>
<tr>
<td>
<code>loadBalancerClass</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>LoadBalancerClass is the class of the load balancer implementation this Service belongs to.
Requires service type to be LoadBalancer.</p>
</td>
</tr>
<tr>
<td>
<code>loadBalancerSourceRanges</code><br/>
<em>
[]string
</em>
</td>
<td>
<em>(Optional)</em>
<p>LoadBalancerSourceRanges are the IP ranges (CIDR) that are allowed to access the load balancer.
Requires service type to be LoadBalancer.</p>
</td>
</tr>
<tr>
<td>
<code>nodePorts</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.NodePort">
[]NodePort
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>NodePorts are the list of NodePorts to expose on the NGINX data plane service.
Each NodePort MUST map to a Gateway listener port, otherwise it will be ignored.
The default NodePort range enforced by Kubernetes is 30000-32767.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.ServiceType">ServiceType
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.ServiceType" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.ServiceSpec">ServiceSpec</a>)
</p>
<p>
<p>ServiceType describes ingress method for the Service.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;ClusterIP&#34;</p></td>
<td><p>ServiceTypeClusterIP means a Service will only be accessible inside the
cluster, via the cluster IP.</p>
</td>
</tr><tr><td><p>&#34;LoadBalancer&#34;</p></td>
<td><p>ServiceTypeLoadBalancer means a Service will be exposed via an
external load balancer (if the cloud provider supports it), in addition
to &lsquo;NodePort&rsquo; type.</p>
</td>
</tr><tr><td><p>&#34;NodePort&#34;</p></td>
<td><p>ServiceTypeNodePort means a Service will be exposed on one port of
every node, in addition to &lsquo;ClusterIP&rsquo; type.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.Telemetry">Telemetry
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.Telemetry" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.NginxProxySpec">NginxProxySpec</a>)
</p>
<p>
<p>Telemetry specifies the OpenTelemetry configuration.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>disabledFeatures</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.DisableTelemetryFeature">
[]DisableTelemetryFeature
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>DisabledFeatures specifies OpenTelemetry features to be disabled.</p>
</td>
</tr>
<tr>
<td>
<code>exporter</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.TelemetryExporter">
TelemetryExporter
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Exporter specifies OpenTelemetry export parameters.</p>
</td>
</tr>
<tr>
<td>
<code>serviceName</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>ServiceName is the &ldquo;service.name&rdquo; attribute of the OpenTelemetry resource.
Default is &lsquo;ngf:<gateway-namespace>:<gateway-name>&rsquo;. If a value is provided by the user,
then the default becomes a prefix to that value.</p>
</td>
</tr>
<tr>
<td>
<code>spanAttributes</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.SpanAttribute">
[]SpanAttribute
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>SpanAttributes are custom key/value attributes that are added to each span.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.TelemetryExporter">TelemetryExporter
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.TelemetryExporter" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.Telemetry">Telemetry</a>)
</p>
<p>
<p>TelemetryExporter specifies OpenTelemetry export parameters.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>interval</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.Duration">
Duration
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Interval is the maximum interval between two exports.
Default: <a href="https://nginx.org/en/docs/ngx_otel_module.html#otel_exporter">https://nginx.org/en/docs/ngx_otel_module.html#otel_exporter</a></p>
</td>
</tr>
<tr>
<td>
<code>batchSize</code><br/>
<em>
int32
</em>
</td>
<td>
<em>(Optional)</em>
<p>BatchSize is the maximum number of spans to be sent in one batch per worker.
Default: <a href="https://nginx.org/en/docs/ngx_otel_module.html#otel_exporter">https://nginx.org/en/docs/ngx_otel_module.html#otel_exporter</a></p>
</td>
</tr>
<tr>
<td>
<code>batchCount</code><br/>
<em>
int32
</em>
</td>
<td>
<em>(Optional)</em>
<p>BatchCount is the number of pending batches per worker, spans exceeding the limit are dropped.
Default: <a href="https://nginx.org/en/docs/ngx_otel_module.html#otel_exporter">https://nginx.org/en/docs/ngx_otel_module.html#otel_exporter</a></p>
</td>
</tr>
<tr>
<td>
<code>endpoint</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>Endpoint is the address of OTLP/gRPC endpoint that will accept telemetry data.
Format: alphanumeric hostname with optional http scheme and optional port.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.TraceContext">TraceContext
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.TraceContext" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.Tracing">Tracing</a>)
</p>
<p>
<p>TraceContext specifies how to propagate traceparent/tracestate headers.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;extract&#34;</p></td>
<td><p>TraceContextExtract uses an existing trace context from the request, so that the identifiers
of a trace and the parent span are inherited from the incoming request.</p>
</td>
</tr><tr><td><p>&#34;ignore&#34;</p></td>
<td><p>TraceContextIgnore skips context headers processing.</p>
</td>
</tr><tr><td><p>&#34;inject&#34;</p></td>
<td><p>TraceContextInject adds a new context to the request, overwriting existing headers, if any.</p>
</td>
</tr><tr><td><p>&#34;propagate&#34;</p></td>
<td><p>TraceContextPropagate updates the existing context (combines extract and inject).</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.TraceStrategy">TraceStrategy
(<code>string</code> alias)</p><a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.TraceStrategy" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.Tracing">Tracing</a>)
</p>
<p>
<p>TraceStrategy defines the tracing strategy.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;parent&#34;</p></td>
<td><p>TraceStrategyParent enables tracing and only records spans if the parent span was sampled.</p>
</td>
</tr><tr><td><p>&#34;ratio&#34;</p></td>
<td><p>TraceStrategyRatio enables ratio-based tracing, defaulting to 100% sampling rate.</p>
</td>
</tr></tbody>
</table>
<h3 id="gateway.nginx.org/v1alpha2.Tracing">Tracing
<a class="headerlink" href="#gateway.nginx.org%2fv1alpha2.Tracing" title="Permanent link">¶</a>
</h3>
<p>
(<em>Appears on: </em>
<a href="#gateway.nginx.org/v1alpha2.ObservabilityPolicySpec">ObservabilityPolicySpec</a>)
</p>
<p>
<p>Tracing allows for enabling and configuring OpenTelemetry tracing.</p>
</p>
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>strategy</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.TraceStrategy">
TraceStrategy
</a>
</em>
</td>
<td>
<p>Strategy defines if tracing is ratio-based or parent-based.</p>
</td>
</tr>
<tr>
<td>
<code>ratio</code><br/>
<em>
int32
</em>
</td>
<td>
<em>(Optional)</em>
<p>Ratio is the percentage of traffic that should be sampled. Integer from 0 to 100.
By default, 100% of http requests are traced. Not applicable for parent-based tracing.
If ratio is set to 0, tracing is disabled.</p>
</td>
</tr>
<tr>
<td>
<code>context</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha2.TraceContext">
TraceContext
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Context specifies how to propagate traceparent/tracestate headers.
Default: <a href="https://nginx.org/en/docs/ngx_otel_module.html#otel_trace_context">https://nginx.org/en/docs/ngx_otel_module.html#otel_trace_context</a></p>
</td>
</tr>
<tr>
<td>
<code>spanName</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>SpanName defines the name of the Otel span. By default is the name of the location for a request.
If specified, applies to all locations that are created for a route.
Format: must have all &lsquo;&ldquo;&rsquo; escaped and must not contain any &lsquo;$&rsquo; or end with an unescaped &lsquo;\&rsquo;
Examples of invalid names: some-$value, quoted-&ldquo;value&rdquo;-name, unescaped</p>
</td>
</tr>
<tr>
<td>
<code>spanAttributes</code><br/>
<em>
<a href="#gateway.nginx.org/v1alpha1.SpanAttribute">
[]SpanAttribute
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>SpanAttributes are custom key/value attributes that are added to each span.</p>
</td>
</tr>
</tbody>
</table>
<hr/>
<p><em>
Generated with <code>gen-crd-api-reference-docs</code>
</em></p>
