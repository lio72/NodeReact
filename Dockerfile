# Stage 1 : Build
FROM node:16.14.0-alpine3.14 AS builder
 
WORKDIR /usr/src/app
 
COPY  package*.json ./
#COPY  client/build /usr/src/app
 
RUN npm ci && npm cache clean --force
 
COPY . .
 
# On lance la commande de build
#iRUN npm run build
 
# Stage 2 : Notre image finale utilisant le contenu du build du stage 1
FROM nginx:1.21.6-alpine
 
WORKDIR /usr/share/nginx/html
 
# On supprime les données statiques de nginx
RUN rm -rf ./*
 
# On copie l'application React construite dans le stage 1 dans le répertoire de nginx
COPY --from=builder /usr/src/app/client/build .
 
# On lance nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]
