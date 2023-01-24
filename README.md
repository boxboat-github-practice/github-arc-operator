# simple-arc-operator
helm based operator for https://github.com/actions-runner-controller/actions-runner-controller
- built with operator-sdk
  - https://sdk.operatorframework.io/docs/building-operators/helm/tutorial/

# prereqs
  - [cert-manager](https://cert-manager.io/docs/installation/helm/)
    - on openshift, use the cert-manager operator provided by redhat (not the community one)
  - [olm](https://sdk.operatorframework.io/docs/olm-integration/tutorial-bundle/#enabling-olm)
    - openshift clusters will have this installed out of the box by default

# initialize
```sh
operator-sdk init --plugins helm --domain example.com --helm-chart actions-runner-controller --helm-chart-repo https://actions-runner-controller.github.io/actions-runner-controller
```
# deploy 
  - run the operator bundle with operator-sdk
    ```sh
    operator-sdk run bundle ghcr.io/boxboat-github-practice/simple-arc-operator-bundle:experimental
    ```
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

# cleanup
```sh
operator-sdk cleanup simple-arc-operator
```