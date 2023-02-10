# github-arc-operator
helm based operator for https://github.com/actions-runner-controller/actions-runner-controller
- built with operator-sdk
  - https://sdk.operatorframework.io/docs/building-operators/helm/tutorial/

# Usage
## Install
1. Install prereqs
    - [cert-manager](https://cert-manager.io/docs/installation/helm/)
      - on openshift, use the cert-manager operator provided by redhat (not the community one)
    - [olm](https://sdk.operatorframework.io/docs/olm-integration/tutorial-bundle/#enabling-olm)
      - openshift clusters will have this installed out of the box by default

1. Install the operator 
    - [operatorhub.io](https://operatorhub.io/operator/github-arc-operator)
    - if your openshift cluster ingests the operatorhub catalog, you can install from the openshift console  
    - if you are installing on another flavor of kubernetes, you can install from the cli using openshift-sdk
      ```sh
      operator-sdk run bundle ghcr.io/boxboat-github-practice/github-arc-operator-bundle:1.0.1
      ```    

1. Create ActionsRunnerController instance
    ```yaml
    kind: ActionsRunnerController
    apiVersion: github-practice.boxboat.com/v1alpha1
    metadata:
      name: arc-sample
    spec:
      openshift: true
      authSecret:
        name: ghauth
      createRunnerNamespaces: true
      runnerNamespaces:
        - test1
        - test2
    ```
    - the spec attribute here supports all the values defined in the official actions runner controller [helm chart](https://github.com/actions/actions-runner-controller/tree/master/charts/actions-runner-controller)
    - values added for additional operator support:

    |value|type|default|description|
    |---|---|---|---|
    |openshift|boolean|false|set to true for openshift deployments to create needed security context constraint changes|
    |runnerNamespaces|list|["ghrunners"]|namespaces to watch for runner deployments|
    |createRunnerNamespaces|boolean|false|set to true to create namespaces on controller instantiation|
    |runnerServiceAccount.name|string|"ghr-sa"|service account name to use for runners to use will be created in all watched namespaces|



# Development
## Initialize
```sh
operator-sdk init --plugins helm --domain example.com --helm-chart actions-runner-controller --helm-chart-repo https://actions-runner-controller.github.io/actions-runner-controller
```
## Deploy 
  - run the operator bundle with operator-sdk 
    ```sh
    operator-sdk run bundle ghcr.io/boxboat-github-practice/github-arc-operator-bundle:experimental
    ```
  - create gh api token
    - add token to [sample controller manifest](./samples/simple-sample.yaml)
    - or create secret and reference by name in sample manifest
      ```sh
      kubectl create secret generic ghauth --from-literal=github_token=<your-token>
      ```
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

## Cleanup
- uninstall operator
  ```sh
  operator-sdk cleanup github-arc-operator
  ```

- CRDs created by arc instances are not deleted by the operator-sdk
```sh
for i in $(k get customresourcedefinitions.apiextensions.k8s.io | grep ".*actions\.summerwind\.dev" | awk '{print $1}'); do kubectl delete customresourcedefinition $i; done
```
- if you're testing, and not changing the version between builds, make sure to clear the cache folder or you won't pull new changes on a redeploy
  ```sh
  rm -rf cache/
  ```
