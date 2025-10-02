# Usar Nginx Alpine como imagen base (ligera y eficiente)
FROM nginx:alpine

# Etiquetas para identificar la imagen
LABEL maintainer="Anfibia Team <info@anfibia.com>"
LABEL description="Landing page de Anfibia - Software Ambiental Inteligente"
LABEL version="1.0.0"

# Instalar herramientas adicionales si es necesario
RUN apk add --no-cache curl

# Crear directorio de trabajo
WORKDIR /usr/share/nginx/html

# Copiar los archivos de la landing page
COPY index.html .
COPY styles.css .
COPY script.js .

# Copiar configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Crear directorio para logs
RUN mkdir -p /var/log/nginx

# Exponer puerto 80
EXPOSE 80

# Health check para verificar que la página esté funcionando
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
