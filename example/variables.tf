variable "region" {
  default = "us-east-1"
}

variable "project" {
  type = object({
    name = string
    team      = string
    contact_email  = string
    environment = string
  })

  description = "Project details"
}

variable "subdomain" {
  type = string
}

variable "root_domain" {
  type = string
  default = "yakhyadabo.org"
}