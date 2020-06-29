## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0, < 0.13.0 |
| gitlab | >= 2.10 |
| kubernetes | >= 1.11 |

## Providers

| Name | Version |
|------|---------|
| gitlab | >= 2.10 |
| kubernetes | >= 1.11 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | n/a | `string` | n/a | yes |
| dns\_zone | (Required) specifies the DNS suffix for the externally-visible websites and services deployed in the cluster | `string` | n/a | yes |
| enabled | n/a | `bool` | `true` | no |
| group\_gitlab\_runner\_enabled | (Optional) Setup a gitlab group runner (will be used a group runner token to set GITLAB\_RUNNER\_TOKEN env variable) | `bool` | `false` | no |
| kubernetes\_ca\_cert | (Required) PEM-encoded root certificates bundle for TLS authentication | `string` | n/a | yes |
| kubernetes\_endpoint | (Required) The hostname (in form of URI) of Kubernetes master. | `string` | n/a | yes |
| kubernetes\_token | (Required) Token of your service account, must have admin permission to create another service accounts | `string` | n/a | yes |
| root\_gitlab\_group | (Semi-optional) A gitlab group id attach Kubernetes cluster to | `string` | `""` | no |
| root\_gitlab\_project | (Semi-optional) A gitlab project id attach Kubernetes cluster to | `string` | `""` | no |
| stage | (Required) Stage, e.g. 'prod', 'staging', 'dev' or 'testing' | `string` | n/a | yes |

## Outputs

No output.

