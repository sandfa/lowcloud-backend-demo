FROM node:18-alpine

WORKDIR /app

# Dependencies installieren
COPY package*.json ./
RUN npm install --production

# Anwendungscode kopieren
COPY . .

# Port exponieren
EXPOSE 3000

# Anwendung starten
CMD ["npm", "start"]
