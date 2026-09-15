# Imagen para ejecutar infra/deploy.sh: aws s3 sync + invalidacion de
# CloudFront, sin necesitar el AWS CLI instalado en el host (Windows).
#
# No copia codigo: el repo completo se monta como volumen desde
# docker-compose.yml, asi no hay que reconstruir la imagen cada vez que
# cambia el sitio.
FROM alpine:3.18

RUN apk add --no-cache aws-cli bash

WORKDIR /app

ENTRYPOINT ["bash"]
CMD ["infra/deploy.sh"]
