# simple-arc-operator
helm based operator for https://github.com/actions-runner-controller/actions-runner-controller
- built with operator-sdk
  - https://sdk.operatorframework.io/docs/building-operators/helm/tutorial/

# prereqs
  - [cert-manager](https://cert-manager.io/docs/installation/helm/)
  - [olm](https://sdk.operatorframework.io/docs/olm-integration/tutorial-bundle/#enabling-olm)

# initialize
```sh
operator-sdk init --plugins helm --domain example.com --helm-chart actions-runner-controller --helm-chart-repo https://actions-runner-controller.github.io/actions-runner-controller
```
# deploy 
  - create gh api token
  - add token to [sample controller manifest](./config/samples/simple-sample.yaml)
  - deploy manifests
    ```sh
    make deploy
    kubectl apply -f config/samples/simple-sample.yaml
    kubectl apply -f config/samples/runner-deployment.yaml
    ```
  
  - undeploy when finished
    ```sh
    make undeploy
    kubectl destroy -f config/samples/simple-sample.yaml
    kubectl destroy -f config/samples/runner-deployment.yaml
    ```
