# MagicVillaApp

> This repository demonstrates a Dockerized ASP.NET Core API application with Nginx as a reverse proxy, orchestrated using Docker Compose.
---

## Overview

This project sets up:

1. **MagicVilla API** (ASP.NET Core)  
   - Runs on port 8080 inside the container.  
   - Built using a multi-stage Dockerfile for optimized image size.

2. **Nginx Reverse Proxy**  
   - Exposes port 80 to the host.  
   - Routes traffic to the API container.  

3. **Docker Compose Orchestration**  
   - Creates an isolated network `magic-network`.  
   - Ensures proper container dependencies.

---

## Docker Compose Setup
- API is accessible via Nginx at http://localhost.
- Nginx configuration is mounted from nginx.conf.

## Key Technologies

- Backend: ASP.NET Core 7.0
- Containerization: Docker, multi-stage build
- Reverse Proxy: Nginx
- Orchestration: Docker Compose


```bash
docker-compose up --build
