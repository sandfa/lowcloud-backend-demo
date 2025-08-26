# Multi-stage build für optimierte Produktions-Images
FROM node:18-alpine AS builder

WORKDIR /app

# Dependencies installieren
COPY package*.json ./
RUN npm ci --only=production

# Anwendungscode kopieren
COPY . .

# Produktions-Image
FROM node:18-alpine AS production

WORKDIR /app

# Nur Produktions-Dependencies und Anwendungscode
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/app.js ./
COPY --from=builder /app/package.json ./

# Nicht-root User für Sicherheit
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001
USER nodejs

# Port exponieren
EXPOSE 3000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

CMD ["npm", "start"]
