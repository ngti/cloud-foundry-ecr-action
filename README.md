# GitHub Action for Cloud Foundry CLI

The GitHub Action for [Cloud Foundry CLI](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html)

## Usage

```
action "Deploy to PWS" {
  uses = "ngti/cloud-foundry-ecr-action@master"
  secrets = ["PASSWORD"]
  env = {
    CF_API_ENDPOINT = "<Cloud Foundry API endpoint>"
    ORG = "<Organisation>"
    SPACE = "<Space>"
    USERNAME = "<Username>"
    APP_NAME = "<Application name>"
    ARTIFACT_PATH = "<Artifact file path>" 
  }
}
```

Available parameters:
  - CF_API_ENDPOINT
  - CF_DOCKER_IMAGE
  - CF_ORG
  - CF_SPACE
  - APP_NAME
  - NUM_INSTANCES (default 1)
  - DISK (default 1G)
  - MEMORY (default 1G)
  - HEALTH_CHECK_TYPE (default port)
  - CF_USER
  - CF_PASSWORD
  - CF_DOCKER_USERNAME
  - CF_DOCKER_PASSWORD
  
For reference: https://cli.cloudfoundry.org/en-US/cf/push.html
