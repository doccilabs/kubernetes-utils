# before using the below commands, you should make the alb-controller-policy by using terraform code (alb-controller)

# you should alternate the cluster-name and policy-arn to what you using
# cluster-name: cluster name of eks
# policy-arn: alb-controller-policy arn you made by terraform code
eksctl create iamserviceaccount --name aws-alb-ingress-controller --namespace kube-system --cluster <cluster-name> --attach-policy-arn <your-alb-policy-arn> --approve --override-existing-serviceaccounts

# Helm Chart를 이용하여 alb-ingress-controller를 배포합니다
# cluster-name은 자신이 사용중인 cluster-name을 입력합니다
# 적용 전에 alb-controller의 버전과 eks 버전의 호환성을 확인하십시오 (eks 1.24 -> alb v2.4.4)
helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
     --set clusterName=<your-cluster-name> \
     --set serviceAccount.create=false \
     --set serviceAccount.name=aws-alb-ingress-controller \
     --set image.repository=amazon/aws-alb-ingress-controller \
     --set image.tag=v2.4.4 \
     --set extraArgs={--cloud-provider=aws} \
     -n kube-system