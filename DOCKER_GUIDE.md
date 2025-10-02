# 🐳 Guía Docker para Anfibia Landing Page

## 🚀 **Despliegue Rápido**

### **1. Prerrequisitos**
- Docker instalado
- Docker Compose instalado
- Cuenta en Docker Hub

### **2. Configuración Inicial**

```bash
# 1. Edita el archivo deploy.sh y cambia tu usuario de Docker Hub
nano deploy.sh
# Cambia: DOCKER_USERNAME="tu-usuario-dockerhub"
# Por: DOCKER_USERNAME="tu-usuario-real"

# 2. Dale permisos de ejecución al script
chmod +x deploy.sh

# 3. Logueate en Docker Hub
docker login
```

### **3. Despliegue Automático**

```bash
# Ejecuta el script de despliegue
./deploy.sh
```

## 🐙 **Comandos Manuales**

### **Construir y Ejecutar Localmente**

```bash
# Construir la imagen
docker build -t anfibia-landing .

# Ejecutar con docker-compose
docker-compose up anfibia-landing

# O ejecutar directamente
docker run -p 8080:80 anfibia-landing
```

### **Subir a Docker Hub**

```bash
# Etiquetar la imagen
docker tag anfibia-landing tu-usuario/anfibia-landing:latest

# Subir a Docker Hub
docker push tu-usuario/anfibia-landing:latest
```

## 🌐 **Acceso a la Página**

Una vez desplegada:
- **Local**: http://localhost:8080
- **Docker Hub**: https://hub.docker.com/r/tu-usuario/anfibia-landing

## 📱 **Para Otros Usuarios**

### **Descargar y Usar tu Imagen**

```bash
# Descargar la imagen
docker pull tu-usuario/anfibia-landing:latest

# Ejecutar la imagen
docker run -p 8080:80 tu-usuario/anfibia-landing:latest

# O usar docker-compose
docker-compose up anfibia-landing
```

### **Docker Compose para Usuarios**

```yaml
# docker-compose.yml para usuarios
version: '3.8'
services:
  anfibia-landing:
    image: tu-usuario/anfibia-landing:latest
    ports:
      - "8080:80"
    restart: unless-stopped
```

## 🔧 **Configuración Avanzada**

### **Variables de Entorno**

```bash
# Personalizar puerto
docker run -p 3000:80 -e NGINX_PORT=80 anfibia-landing

# Configurar host
docker run -p 8080:80 -e NGINX_HOST=anfibia.com anfibia-landing
```

### **Volúmenes Personalizados**

```bash
# Montar configuración personalizada
docker run -p 8080:80 \
  -v /ruta/local/nginx.conf:/etc/nginx/nginx.conf:ro \
  anfibia-landing
```

### **Redes Personalizadas**

```bash
# Crear red personalizada
docker network create anfibia-network

# Ejecutar en la red
docker run --network anfibia-network -p 8080:80 anfibia-landing
```

## 📊 **Monitoreo y Logs**

### **Ver Logs**

```bash
# Logs del contenedor
docker logs anfibia-landing-page

# Logs con docker-compose
docker-compose logs anfibia-landing

# Logs en tiempo real
docker-compose logs -f anfibia-landing
```

### **Health Check**

```bash
# Verificar estado del contenedor
docker ps

# Verificar health check
docker inspect anfibia-landing-page | grep Health -A 10
```

## 🚀 **Despliegue en Producción**

### **Servidor VPS/Cloud**

```bash
# 1. Conectarse al servidor
ssh usuario@tu-servidor.com

# 2. Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 3. Descargar tu imagen
docker pull tu-usuario/anfibia-landing:latest

# 4. Ejecutar en producción
docker run -d \
  --name anfibia-prod \
  -p 80:80 \
  --restart unless-stopped \
  tu-usuario/anfibia-landing:latest
```

### **Con Nginx Reverse Proxy**

```nginx
# /etc/nginx/sites-available/anfibia
server {
    listen 80;
    server_name anfibia.com www.anfibia.com;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 🔒 **Seguridad**

### **Firewall**

```bash
# Abrir solo puerto 80 (HTTP)
sudo ufw allow 80/tcp

# O si usas puerto personalizado
sudo ufw allow 8080/tcp
```

### **SSL/HTTPS con Let's Encrypt**

```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx

# Obtener certificado
sudo certbot --nginx -d anfibia.com -d www.anfibia.com
```

## 📈 **Escalabilidad**

### **Múltiples Instancias**

```yaml
# docker-compose.yml escalable
version: '3.8'
services:
  anfibia-landing:
    image: tu-usuario/anfibia-landing:latest
    ports:
      - "8080:80"
    deploy:
      replicas: 3
    restart: unless-stopped
```

### **Load Balancer**

```nginx
# Configuración de load balancer
upstream anfibia_backend {
    server localhost:8080;
    server localhost:8081;
    server localhost:8082;
}

server {
    listen 80;
    server_name anfibia.com;
    
    location / {
        proxy_pass http://anfibia_backend;
    }
}
```

## 🐛 **Solución de Problemas**

### **Problemas Comunes**

1. **Puerto ya en uso**
   ```bash
   # Ver qué está usando el puerto
   sudo netstat -tulpn | grep :8080
   
   # Cambiar puerto
   docker run -p 8081:80 anfibia-landing
   ```

2. **Permisos de archivos**
   ```bash
   # Dar permisos al script
   chmod +x deploy.sh
   
   # Verificar permisos de Docker
   sudo usermod -aG docker $USER
   ```

3. **Imagen no se construye**
   ```bash
   # Ver logs de construcción
   docker build -t anfibia-landing . --progress=plain
   
   # Limpiar cache
   docker system prune -a
   ```

### **Logs de Debug**

```bash
# Ver logs detallados de Nginx
docker exec anfibia-landing-page tail -f /var/log/nginx/error.log

# Ver configuración de Nginx
docker exec anfibia-landing-page nginx -T
```

## 📚 **Recursos Adicionales**

- [Documentación oficial de Docker](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Docker Compose](https://docs.docker.com/compose/)

## 🆘 **Soporte**

Si tienes problemas:
1. Revisa los logs: `docker logs anfibia-landing-page`
2. Verifica la configuración: `docker exec anfibia-landing-page nginx -t`
3. Contacta al equipo: info@anfibia.com

---

**¡Tu landing page de Anfibia ahora está lista para el mundo! 🌍🐸**
