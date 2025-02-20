variable "environment" {
  type        = string
  description = "The environment name to be used when provisioning AWS resources."
}

variable "region" {
  type        = string
  description = "The AWS region in which resources will be created."
}

variable "tuxedo_service_subtypes" {
  type        = list(string)
  description = "The service subtype name to be used when creating AWS resources."
  default = [
    "frontend",
    "ois",
    "fil",
    "ais"
  ]
}
