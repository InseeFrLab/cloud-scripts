variable "projectid" {
  type        = string
  default     = "changemeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
  description = "The project id to work in"
}

variable "domain_name" {
  type        = string
  default     = "example.com"
  description = "The base domain name"
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "The region to deploy everything in"
}

variable "location" {
  type        = string
  default     = "europe-west1-b"
  description = "The locationn to deploy everything in. Should be within the region"
}
