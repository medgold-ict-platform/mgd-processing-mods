variable "region" {
  default = "eu-west-1"
}

variable "profile" {
  default = ""
}

variable "datasets" {
  default = []
}


variable "environment" {
  default = ""
}

variable "project" {
  default = ""
}

variable "role" {
  default = ""
}

variable "instance_trust_policy" {
    default = "../template/instance-trust-policy.json"
}

variable "instance_policy" {
    default = "../template/instance-policy.json"
}

variable "ERA5-vars" {
  default = []
}

variable "ECMWF-vars" {
  default = []
}

variable "EOBS-vars" {
  default = []
}


variable "t2m" {
  default = "t2m"
}


# variable "loc" {
#   value = "s3://data.med-gold.eu/era5/p/parquet/tp/"
# }
