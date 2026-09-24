---
f5-product: F5 WAF for NGINX
f5-files:
- content/ngf/waf-integration/get-started-plm.md
---

<!-- Maintainer note: This include is product-agnostic. It deploys two sample applications used for WAF policy testing in the PLM tutorial. The customers app returns fake sensitive data (credit card and SSN) used to demonstrate data guard masking. Do not add product-specific resources here. -->

Deploy the `customers` and `orders` sample applications. The `customers` app returns a response containing fake sensitive data (credit card number and SSN), which you'll use later to demonstrate data guard masking:

```yaml
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: customers
spec:
  replicas: 1
  selector:
    matchLabels:
      app: customers
  template:
    metadata:
      labels:
        app: customers
    spec:
      containers:
      - name: customers
        image: hashicorp/http-echo:latest
        args:
        - "-listen=:8080"
        - "-text=Customer List:\n\nName: John Doe\nCredit Card: 4111-1111-1111-1111\nSSN: 123-45-6789\n"
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: customers
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: customers
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: orders
spec:
  replicas: 1
  selector:
    matchLabels:
      app: orders
  template:
    metadata:
      labels:
        app: orders
    spec:
      containers:
      - name: orders
        image: nginxdemos/nginx-hello:plain-text
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: orders
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: orders
EOF
```
