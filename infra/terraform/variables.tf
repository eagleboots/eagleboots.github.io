variable "aws_region" {
  description = "Region de AWS donde se despliega el bucket S3"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nombre del bucket S3 para el sitio estatico. Debe ser unico a nivel global."
  type        = string
  default     = "eagleboots-frontend-site"
}

variable "enable_waf" {
  description = "Activa y adjunta un AWS WAF a CloudFront (costo aproximado +$6/mes mas $1 por millon de solicitudes)."
  type        = bool
  default     = false
}
