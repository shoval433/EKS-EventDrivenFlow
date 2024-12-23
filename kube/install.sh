aws eks update-kubeconfig --region eu-central-1 --name shoval-eks-cluster-prjcloud
helm repo add kedacore https://kedacore.github.io/charts
helm repo update


helm install keda kedacore/keda --namespace keda --create-namespace

kubectl apply -f app-credentials.yaml
kubectl apply -f sqs-credentials.yaml
kubectl apply -f scaledjob.yaml

kubectl get ScaledJob
kubectl get pod

kubectl get pods --field-selector=status.phase=Succeeded -o jsonpath="{.items[*].metadata.name}" | ForEach-Object { $_.Split(' ') | ForEach-Object { kubectl delete pod $_ } }

# kubectl delete -f app-credentials.yaml
# kubectl delete -f sqs-credentials.yaml
# kubectl delete -f scaledjob.yaml
