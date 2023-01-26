variable "region" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "tenancy_ocid" {}
variable "compartment_id" {}
variable "private_key_path" {}

variable "app_name" {
  default     = "DevOps"
  description = "Nome da Aplicação. Será usado como prefixo para identificar recursos, como OKE, VCN, DevOps e outros"
  #"Application name. Will be used as prefix to identify resources, such as OKE, VCN, DevOps, and others"
}

# Network Details
## CIDRs
variable "network_cidrs" {
  type = map(string)

  default = {
    VCN-CIDR                      = "172.16.0.0/20"
    SUBNET-PUBLIC-CIDR            = "172.16.15.0/24"
    SUBNET-PRIVATE-CIDR           = "172.16.14.0/24"
    ENDPOINT-SUBNET-REGIONAL-CIDR = "172.16.0.0/28"
    ALL-CIDR                      = "0.0.0.0/0"
    PODS-CIDR                     = "10.244.0.0/16"
    KUBERNETES-SERVICE-CIDR       = "10.96.0.0/16"
  }
}
