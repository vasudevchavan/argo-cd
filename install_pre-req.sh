#!/bin/bash


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



# Main script execution starts here
if ! command -v helm &> /dev/null; then
    echo "Helm is not installed. Proceeding with installation..."
    install_helm
elif ! helm version &> /dev/null; then
    echo "Helm command exists but not working properly. Reinstalling..."
    install_helm
else
    echo "Helm is already installed and working."
fi


