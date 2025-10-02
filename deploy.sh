#!/bin/bash

# Script de despliegue para Anfibia Landing Page
# Autor: Anfibia Team
# Versión: 1.0.0

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración
DOCKER_USERNAME="tu-usuario-dockerhub"
IMAGE_NAME="anfibia-landing"
TAG="latest"
FULL_IMAGE_NAME="$DOCKER_USERNAME/$IMAGE_NAME:$TAG"

echo -e "${BLUE}🐸 Desplegando Landing Page de Anfibia 🐸${NC}"
echo "=================================================="

# Función para mostrar mensajes de error
error_exit() {
    echo -e "${RED}❌ Error: $1${NC}" >&2
    exit 1
}

# Función para mostrar mensajes de éxito
success_msg() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Función para mostrar mensajes informativos
info_msg() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Función para mostrar advertencias
warning_msg() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Verificar que Docker esté instalado
if ! command -v docker &> /dev/null; then
    error_exit "Docker no está instalado. Por favor instala Docker primero."
fi

# Verificar que Docker Compose esté instalado
if ! command -v docker-compose &> /dev/null; then
    error_exit "Docker Compose no está instalado. Por favor instala Docker Compose primero."
fi

# Verificar que estemos logueados en Docker Hub
if ! docker info &> /dev/null; then
    error_exit "No estás logueado en Docker. Ejecuta 'docker login' primero."
fi

# Verificar que el usuario de Docker Hub esté configurado
if [ "$DOCKER_USERNAME" = "tu-usuario-dockerhub" ]; then
    echo -e "${YELLOW}⚠️  Por favor edita este script y cambia 'tu-usuario-dockerhub' por tu usuario real de Docker Hub${NC}"
    read -p "Ingresa tu usuario de Docker Hub: " DOCKER_USERNAME
    FULL_IMAGE_NAME="$DOCKER_USERNAME/$IMAGE_NAME:$TAG"
fi

info_msg "Usuario de Docker Hub: $DOCKER_USERNAME"
info_msg "Nombre de la imagen: $FULL_IMAGE_NAME"

# Construir la imagen
echo ""
info_msg "Construyendo imagen Docker..."
docker build -t $FULL_IMAGE_NAME . || error_exit "Error al construir la imagen Docker"

success_msg "Imagen construida exitosamente"

# Probar la imagen localmente
echo ""
info_msg "Probando la imagen localmente..."
docker-compose up -d anfibia-landing || error_exit "Error al iniciar el contenedor"

# Esperar a que el contenedor esté listo
echo "Esperando a que el contenedor esté listo..."
sleep 10

# Verificar que la página esté funcionando
if curl -f http://localhost:8080 &> /dev/null; then
    success_msg "Página funcionando correctamente en http://localhost:8080"
else
    warning_msg "La página no responde en localhost:8080. Verificando logs..."
    docker-compose logs anfibia-landing
fi

# Detener el contenedor local
docker-compose down

# Preguntar si quiere subir a Docker Hub
echo ""
read -p "¿Quieres subir la imagen a Docker Hub? (y/n): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    info_msg "Subiendo imagen a Docker Hub..."
    
    # Hacer push de la imagen
    docker push $FULL_IMAGE_NAME || error_exit "Error al subir la imagen a Docker Hub"
    
    success_msg "Imagen subida exitosamente a Docker Hub!"
    echo ""
    echo -e "${GREEN}🎉 ¡Tu landing page está ahora disponible en Docker Hub! 🎉${NC}"
    echo ""
    echo "Para que otros puedan usar tu imagen:"
    echo "  docker pull $FULL_IMAGE_NAME"
    echo "  docker run -p 8080:80 $FULL_IMAGE_NAME"
    echo ""
    echo "O con docker-compose:"
    echo "  docker-compose up anfibia-landing"
    echo ""
    echo "URL de tu imagen: https://hub.docker.com/r/$DOCKER_USERNAME/$IMAGE_NAME"
else
    info_msg "Imagen no subida a Docker Hub. Puedes hacerlo manualmente con:"
    echo "  docker push $FULL_IMAGE_NAME"
fi

# Mostrar comandos útiles
echo ""
echo -e "${BLUE}📚 Comandos útiles:${NC}"
echo "=================================================="
echo "Construir imagen:     docker build -t $FULL_IMAGE_NAME ."
echo "Ejecutar localmente:  docker-compose up anfibia-landing"
echo "Ver logs:            docker-compose logs anfibia-landing"
echo "Detener:             docker-compose down"
echo "Subir a Docker Hub:  docker push $FULL_IMAGE_NAME"
echo "Descargar imagen:    docker pull $FULL_IMAGE_NAME"

echo ""
success_msg "¡Despliegue completado!"
