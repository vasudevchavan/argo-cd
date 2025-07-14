#!/bin/bash

# This script installs Helm, Terraform, Podman (or Docker), ArgoCD CLI, Kustomize, and ArgoCD using Terraform.
# It checks for existing installations and installs only if necessary.
# It also verifies the installation of each component.

set -e

function error_exit {
    echo "Error: $1"
    exit 1
}

function install_helm {
    local temp_dir="/tmp/helm_install_$$"

    mkdir -p "$temp_dir" || error_exit "Failed to create temporary directory"
    cd "$temp_dir" || error_exit "Failed to change to temporary directory"

    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 || error_exit "Failed to download Helm installer"
    chmod 700 get_helm.sh
    ./get_helm.sh || error_exit "Helm installation failed"

    cd /
    rm -rf "$temp_dir"

    echo "Helm installation completed successfully."
    helm version || error_exit "Helm installation verification failed"
}

function install_argocd {
    # Check if kubectl is available
    if ! command -v kubectl &>/dev/null; then
        error_exit "kubectl is required but not installed. Please install kubectl first."
    fi
    
    # Check if terraform directory exists
    if [ ! -d "terraform" ]; then
        error_exit "terraform directory not found. Please ensure terraform configuration exists."
    fi
    
    echo "Installing ArgoCD using Terraform..."
    local original_dir=$(pwd)
    cd terraform || error_exit "Failed to change to terraform directory"
    
    terraform init || error_exit "Terraform initialization failed"
    terraform apply -auto-approve || error_exit "Terraform apply failed"
    
    cd "$original_dir" || error_exit "Failed to return to original directory"
    
    echo "ArgoCD installation completed successfully using Terraform."
    # Verify ArgoCD installation
    if ! kubectl get pods -n argocd &>/dev/null; then
        error_exit "ArgoCD pods are not running. Please check the installation."
    else
        echo "ArgoCD is successfully installed and running."
    fi
}

# Main script execution starts here

INSTALL_ARGOCD=true

if ! command -v helm &>/dev/null; then
    echo "Helm is not installed. Proceeding with installation..."
    install_helm
elif ! helm version &>/dev/null; then
    echo "Helm command exists but not working properly. Reinstalling..."
    install_helm
else
    echo "Helm is already installed and working."
fi

# Install terraform
if ! command -v terraform &>/dev/null; then
    echo "Terraform is not installed. Installing Terraform..."
    brew install terraform || error_exit "Failed to install Terraform"
else
    echo "Terraform is already installed."
fi

# Install Podman or Docker
if ! command -v podman &>/dev/null && ! command -v docker &>/dev/null; then
    echo "Neither Podman nor Docker is installed. Installing Podman..."
    brew install podman || error_exit "Failed to install Podman"
else
    echo "Container runtime (Podman/Docker) is already available."
fi

# Install ArgoCD CLI
if ! command -v argocd &>/dev/null; then
    echo "ArgoCD CLI is not installed. Installing ArgoCD CLI..."
    brew install argocd || error_exit "Failed to install ArgoCD CLI"
else
    echo "ArgoCD CLI is already installed."
fi

# Install kustomize
if ! command -v kustomize &>/dev/null; then
    echo "Kustomize is not installed. Installing Kustomize..."
    brew install kustomize || error_exit "Failed to install Kustomize"
else
    echo "Kustomize is already installed."
fi

# Install ArgoCD using Terraform
if [ "$INSTALL_ARGOCD" = true ]; then
    install_argocd
else
    echo "Skipping ArgoCD installation."
fi
