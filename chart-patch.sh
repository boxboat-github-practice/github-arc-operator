headStart=$(grep -n "rules:"  helm-charts/actions-runner-controller/templates/manager_role.yaml | awk -F':' '{print $1}')
tailStart=$(($headStart + 1))
head -n${headStart} helm-charts/actions-runner-controller/templates/manager_role.yaml > head
tail -n+${tailStart} helm-charts/actions-runner-controller/templates/manager_role.yaml > tail
cat head overlays/patch.yaml tail 