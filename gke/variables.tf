variable "projectid" {
  type        = string
  description = "The project id to work in"
}

variable "domain_name" {
  type        = string
  description = "The base domain name"
}

variable "region" {
  type        = string
  description = "The region to deploy everything in"
}

variable "location" {
  type        = string
  description = "The locationn to deploy everything in. Should be within the region"
}
