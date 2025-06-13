FROM alpine:3.22.0

WORKDIR /app

COPY . .

RUN apk add --no-cache bash curl jq

CMD ["bash", "user.sh"]
