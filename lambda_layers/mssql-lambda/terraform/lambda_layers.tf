
resource "aws_lambda_layer_version" "layer_pyodbc" {
  layer_name       = "layer-pyodbc"
  filename         = data.archive_file.layer_pyodbc_zip.output_path
  source_code_hash = data.archive_file.layer_pyodbc_zip.output_base64sha256

  compatible_runtimes = ["python3.8"]
}

data "archive_file" "layer_pyodbc_zip" {
  type        = "zip"
  source_dir  = "../layer-pyodbc/"
  output_path = "layer-pyodbc.zip"
}
