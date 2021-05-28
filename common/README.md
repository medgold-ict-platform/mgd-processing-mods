# MedGold Processing Terraform module

Terraform module which creates different resources: 

- Amazon Athena Database (one for each dataset in variable datasets)
- EC2
- Amazon Athena Table (one for each variable and for each dataset)
- S3 Bucket that contains original files
- S3 Bucket that contains query results
- All required policies

## Usage

```hcl
module "big-data-resources" {
    region               = "region"
    profile              = "profile"
    project              = "project"
    role                 = "role"
    environment          = "environment"
    datasets             = ["list of datasets"]
    EOBS-vars            = ["list of EOBS variables"]
    ECMWF-vars           = ["list of ECMWF variables"]
    ERA5-vars            = ["list of ERA5 variables"]
}
```

## Examples

## Known Issues/Limitations

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project | Project Name | string | `Unknown` | no |
| profile | aws profile | string | ``| yes |
| region | aws region | string | `eu-west-1`| no |
| role | project role | string | ``| yes |
| environment | Environemnt  | string | - | yes |
| instance_trust_policy | path of trust policy  | string | `../template/instance-trust-policy.json` | no |
| instance_policy | path of trust policy  | string | `../template/../template/instance-policy.json` | no | datasets | List of datasets | list | `[]` | no |
| EOBS-vars | list of EOBS variables | list | `[]` | yes |
| ECMWF-vars | list of ECMWF variables | list | `[]` | yes |
| ERA5-vars | list of ERA5 variables | list | `[]` | yes |


## Requirements

- Terraform 11.14
