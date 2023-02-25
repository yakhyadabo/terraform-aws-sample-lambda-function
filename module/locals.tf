locals {
  function_name = "app"
  src_path      = "${path.module}/go/cmd/main.go"
  binary_path  = "${path.module}/go/bin/${local.function_name}"
  archive_path = "${path.module}/go/bin/${local.function_name}.zip"
}