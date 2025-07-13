resource "helm_release" "argocd" {
    name = "argocd"
    repository = "https://argoproj.github.io/argo-helm"
    chart = "argo-cd"
    version = "3.35.4"
    namespace = "argocd"
    create_namespace = true
    values = [
        file("values/argocd.yaml")
    ]


}

resource "null_resource" "get_argocd_password" {
    depends_on = [helm_release.argocd]
    
    provisioner "local-exec" {
        command = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
    }
}