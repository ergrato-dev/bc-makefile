FROM node:26-alpine
WORKDIR /app
# Sin dependencias de producción: no hace falta gestor de paquetes en la
# imagen. Si las añades, instálalas con pnpm (nunca npm) en una etapa
# previa de build y copia solo node_modules/.
COPY package.json ./
COPY src/ ./src/
EXPOSE 3000
# TODO: el contenedor no puede correr como root. Declara un USER sin
# privilegios antes del CMD (lab-02, pasos 7 y 8).

CMD ["node", "src/index.js"]
