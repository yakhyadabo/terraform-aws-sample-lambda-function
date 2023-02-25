variable "app_id" {
  type = string
  description = "Name of the Application"
}

variable "project_name" {
  type = string
  description = "Name of the project"
}

variable "environment" {
  type = string
  description = <<EOT
  The environment short name to use for the deployed resources.

  Options:
  - dev
  - uat
  - prd

  Default: dev
  EOT
  default     = "dev"
}