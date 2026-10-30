FROM node:26-alpine
WORKDIR /app
# Sin dependencias de producción: no hace falta gestor de paquetes en la
# imagen. Si las añades, instálalas con pnpm (nunca npm) en una etapa
# previa de build y copia solo node_modules/.
COPY package.json ./
COPY src/ ./src/
EXPOSE 3000
# La imagen oficial trae el usuario sin privilegios "node"
USER node

CMD ["node", "src/index.js"]
