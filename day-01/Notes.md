# Día 1: [Introduction to Terraform](https://youtu.be/s5fwSG_00P8?si=UucabQJ-_FCK1aAz)

### Qué es la infraestructura como código? (IAC)
Se refiere al proceso de provisionar infraestructura atraves de codigo en lugar de realizarlo con un proceso manual.

### Porqué se necesita?
- **Consistencia**: Entornos idénticos en desarrollo, staging y producción
- **Eficiencia de tiempo**: El aprovisionamiento automatizado ahorra horas de trabajo manual
- **Gestión de costos**: Fácil seguimiento de costos y limpieza automatizada
- **Escalabilidad**: Implementación en cientos de servidores con el mismo esfuerzo que uno solo
- **Control de versiones**: Seguimiento de cambios en Git
- **Reducción de errores humanos**: Eliminación de errores de configuración manual
- **Colaboración**: El equipo puede trabajar en conjunto en la infraestructura

### Beneficios de la IaC
- Implementación consistente en entornos
- Fácil seguimiento y gestión de costos
- Escribir una vez, implementar muchas (código base único)
- Automatización que ahorra tiempo
- Reducción de errores humanos
- Optimización de costos mediante la automatización
- Control de versiones para cambios en la infraestructura
- Limpieza automatizada y destrucción programada
- Enfoque del desarrollador en el desarrollo de aplicaciones
- Fácil creación de entornos de producción idénticos para la resolución de problemas

### Qué es Terraform?
Es una herramienta de IAC que ayuda a automatizar el aprovisionamiento de infraestructura y su administración atraves de multiples proveedores de nube.

### Cómo funciona Terraform?
Escribes archivos de Terraform → Ejecutas comandos de Terraform → Se realizan llamadas a las APIs de AWS a través de un Terraform Provider

### Instalar Terraform
Seguir la guía de instalación: https://developer.hashicorp.com/terraform/install

o

### Instalación con comandos
```bash
# Para macOS
brew install hashicorp/tap/terraform

# Para Ubuntu/Debian
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### Comandos Setup
```bash
terraform -install-autocomplete
alias tf=terraform
terraform -version
```