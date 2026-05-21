FROM node:22-alpine

ENV PORT=8080
ENV NODE_OPTIONS="--max-old-space-size=128 --optimize-for-size"

RUN npm install -g supergateway@3.4.3 @karakeep/mcp

EXPOSE 8080

CMD supergateway \
  --stdio "karakeep-mcp" \
  --outputTransport streamableHttp \
  --port ${PORT} \
  --host 0.0.0.0 \
  --healthEndpoint /health
