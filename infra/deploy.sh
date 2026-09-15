#!/usr/bin/env bash
# Sincroniza el sitio estatico (raiz del repo) hacia el bucket S3 creado por
# Terraform y luego invalida la cache de CloudFront.
#
# Requiere AWS CLI configurado (ver infra/aws/config.example y
# infra/aws/credentials.example) y las salidas de `terraform apply`.
#
# Las variables se leen de infra/.env (copia infra/.env.example y rellena los
# valores reales de `terraform output`). Tambien puedes sobreescribirlas
# pasandolas inline:
#   EAGLEBOOTS_S3_BUCKET=otro-bucket ./infra/deploy.sh
#
# Uso:
#   cp infra/.env.example infra/.env   # una sola vez, y rellena los valores
#   ./infra/deploy.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ -f "$SCRIPT_DIR/.env" ]; then
  echo "==> Cargando variables desde infra/.env ..."
  set -a
  # shellcheck disable=SC1091
  source "$SCRIPT_DIR/.env"
  set +a
fi

BUCKET="${EAGLEBOOTS_S3_BUCKET:?Define EAGLEBOOTS_S3_BUCKET en infra/.env (nombre del bucket, salida s3_bucket_name de terraform)}"
DISTRIBUTION_ID="${EAGLEBOOTS_CF_DISTRIBUTION_ID:?Define EAGLEBOOTS_CF_DISTRIBUTION_ID en infra/.env (salida cloudfront_distribution_id de terraform)}"
PROFILE="${AWS_PROFILE:-eagleboots}"
REGION="${AWS_REGION:-${AWS_DEFAULT_REGION:-us-east-1}}"

echo "==> Sincronizando sitio estatico hacia s3://$BUCKET ..."
aws s3 sync "$ROOT_DIR" "s3://$BUCKET" \
  --delete \
  --exclude ".git/*" \
  --exclude "infra/*" \
  --exclude "*.dockerignore" \
  --exclude "Dockerfile" \
  --exclude "docker-compose.yml" \
  --exclude "index.html" \
  --cache-control "public,max-age=86400" \
  --profile "$PROFILE" --region "$REGION"

echo "==> Subiendo index.html sin cache (para que siempre sirva la ultima version)..."
aws s3 cp "$ROOT_DIR/index.html" "s3://$BUCKET/index.html" \
  --cache-control "no-cache, no-store, must-revalidate" \
  --content-type "text/html" \
  --profile "$PROFILE" --region "$REGION"

echo "==> Invalidando cache de CloudFront ($DISTRIBUTION_ID)..."
aws cloudfront create-invalidation \
  --distribution-id "$DISTRIBUTION_ID" \
  --paths "/index.html" "/" \
  --profile "$PROFILE"

echo ""
echo "==> Despliegue completado. La invalidacion tarda unos minutos en propagarse."
