📦 Argo CD GitOps Repository
This repository contains Kubernetes manifests, Kustomize overlays, and configuration to manage applications via Argo CD in a GitOps workflow. Ideal for deploying modern apps with declarative infrastructure.

🚀 Quickstart
Regular way to install Argo CD into your cluster (if not already installed):

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

This Bash script automates the installation and setup of essential DevOps tools: Helm, Terraform, Podman (or Docker), ArgoCD CLI, Kustomize, and ArgoCD itself (using Terraform). It checks for existing installations and installs only what’s missing or malfunctioning.

📦 What It Does:

  Installs Helm (with verification).
  Installs Terraform using brew.
  Installs Podman (or uses Docker if already present).
  Installs ArgoCD CLI.
  Installs Kustomize.
  Deploys ArgoCD using Terraform configurations found in a local terraform/ directory.
  Verifies successful installations and deployments.

🧰 Requirements Before running the script, ensure:

  macOS with Homebrew (brew) installed.
  kubectl installed and configured (required for ArgoCD verification).
  A valid terraform/ directory containing ArgoCD infrastructure configuration.

🚀 How to Use
  Clone your infrastructure repo or place a terraform/ directory containing ArgoCD configs in the same folder as this script.

Run the script:

```
chmod +x setup.sh
./setup.sh
```
The script is idempotent — it only installs missing components and safely skips those already present and functional.

🛑 Error Handling
If any installation step fails, the script will print an error and exit immediately. Examples:
Missing kubectl results in a hard exit.
A missing terraform/ directory will abort the ArgoCD deployment.


📁 Directory Structure

```
your-project/
├── setup.sh         # <-- This script
└── terraform/       # <-- Your Terraform configs for ArgoCD
```

✅ Verifications Performed
  Validates Helm installation by checking version output.
  Confirms Podman or Docker availability.
  Verifies ArgoCD pods are running via kubectl.

🔄 Reusability
  To skip ArgoCD deployment, modify this line in the script:

```
INSTALL_ARGOCD=false
```


Login to Argo CD UI:
Port‑forward:
```
kubectl port-forward svc/argocd-server -n argocd 8081:443
Visit: https://localhost:8081
```

CLI login:
```
argocd login localhost:8081
```

App-of-Apps pattern supported via Kustomize overlays under applications/.

🗂️ Structure
```
├─ applications/            # Argo CD Application definitions (App-of‑Apps)
│  ├─ baseapplication/      # Base resources (Kustomize)
│  ├─ overlays/
│     ├─ autosync/          # Application with AutoSync
│     └─ manualsync/        # Application with ManualSync
│  ├─ terraform             # Argo CD install using terraform
│  ├─ helmchart             # Argo CD application to install Metrics server.
└─ README.md
```


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

🧭 Where to Go Next
Check Argo CD documentation for detailed guides.
Learn about App-of-Apps, multi-cluster GitOps, and sync policies.
Enhance your pipeline with GitHub Actions + Kustomize + ArgoCD.

📄 License
This project is licensed under the MIT license. See the LICENSE file for details.