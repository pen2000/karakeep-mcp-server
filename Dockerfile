FROM node:22-slim

ENV PORT=8080

EXPOSE 8080

CMD npx -y supergateway \
  --stdio "npx -y @karakeep/mcp" \
  --port ${PORT} \
  --host 0.0.0.0 \
  --healthEndpoint /health
