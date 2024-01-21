## Part: A - Develop & Deploy a REST API
1. I created a symple REST API with the `FastAPI` framework of Python. The `API Key` of the third party API can be found in [secrets.yaml](./k8s/secrets.yaml) as `base64` encoded format.

2. Created the CI/CD pipeline with `Github Action` which triggers on a new release and build the REST API image and Push to [Docker Hub](https://hub.docker.com/r/shazolkh/bs-test) public repository.

3. The **Terraform** code creates a Kubernetes Cluster in `AKS` on `Azure`. Also the `remote Backend` is configured to store the data on Azure Blob storage.

4. And finally, CI/CD pipeline is updated to run the manifest files of `k8s` folder and set the tag of docker image with the `latest release version`.

## Part: B – System Architecture
