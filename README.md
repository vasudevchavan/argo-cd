📦 Argo CD GitOps Repository
This repository contains Kubernetes manifests, Kustomize overlays, and configuration to manage applications via Argo CD in a GitOps workflow. Ideal for deploying modern apps with declarative infrastructure.

🚀 Quickstart
Install Argo CD into your cluster (if not already installed):


```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```


Bootstrap this repo for GitOps deployment:
```
kubectl apply -f applications/your-app.yaml -n argocd
```

Login to Argo CD UI:

Port‑forward:
```
kubectl port-forward svc/argocd-server -n argocd 8080:443
Visit: https://localhost:8080
```

CLI login:

```
argocd login localhost:8080
```

App-of-Apps pattern supported via Kustomize overlays under applications/.

🗂️ Structure
```
├─ applications/             # Argo CD Application definitions (App-of‑Apps)
│  ├─ base/                 # Base resources (Kustomize)
│  ├─ overlays/
│     ├─ dev/
│     └─ prod/
├─ env/                     # Environment-specific overlays or Helm values
└─ README.md
```

applications/base: Defines a “root” ArgoCD Application to deploy all child apps.

applications/overlays/{dev,prod}: Target-specific Application definitions pointing to respective manifests/values.

Optionally, common resources or secrets via env/.

🧩 Deployment Flow
Define base Application (App-of-Apps) in applications/base.

Create environment overlays to customize path, target cluster/namespace, syncPolicies.

Push changes, and Argo CD will:

Detect new commits

Render manifests via Kustomize/Helm

Sync resources into your cluster(s)

⚙️ Features
🔄 Kustomize overlays for multi‑env customization.

📌 Support for ArgoCD sync policies (Auto or Manual).

🔒 Optional imagePullSecrets/Helm values injection.

🛠️ CI/CD integration ready (GitHub Actions workflow recommended).

🌐 App-of-Apps pattern for modular pipeline and multi-cluster deployments.

🧑‍💻 Usage Tips
Use namePrefix or nameSuffix for environment isolation via overlays.

Apply patchesStrategicMerge (Kustomize) to add imagePullSecrets, imagePullPolicy.

Ensure Kustomize build runs before kubectl apply when using Helm charts.

Consider argocd app diff to preview changes before syncing live.

✔️ Common Patterns
Add imagePullPolicy:
```
# overlays/dev/deployment-patch.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  template:
    spec:
      containers:
        - name: my-app
          imagePullPolicy: Always
```

Then reference from kustomization.yaml:

```patchesStrategicMerge:
  - deployment-patch.yaml

```

Add imagePullSecret:
Generate secret via secretGenerator, then patch Deployment:

```
spec:
  template:
    spec:
      imagePullSecrets:
        - name: regcred
```
🧭 Where to Go Next
Check Argo CD documentation for detailed guides.

Learn about App-of-Apps, multi-cluster GitOps, and sync policies.

Enhance your pipeline with GitHub Actions + Kustomize + ArgoCD.

📄 License
This project is licensed under the MIT license. See the LICENSE file for details.