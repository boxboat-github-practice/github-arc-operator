filepath="github-arc-operator/helm-charts/actions-runner-controller/templates/manager_role.yaml"
headStart=$(grep -n "rules:"  $filepath | awk -F':' '{print $1}')
tailStart=$(($headStart + 1))
head -n${headStart} $filepath > head
tail -n+${tailStart} $filepath > tail
cat head overlays/patch.yaml tail > $filepath