resource "random_id" "unique_suffix" {
  byte_length = 2
}

locals {
  app_id = "${lower(var.project.name)}-${lower(var.project.environment)}-${random_id.unique_suffix.hex}"
}

module "lambda" {
  source               = "../module"
  app_id               = local.app_id
  project_name         = var.project.name
  environment          = var.project.environment
  root_domain          = var.root_domain
}