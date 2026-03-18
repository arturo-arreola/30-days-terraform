# Día 2 - [Providers](https://youtu.be/JFiMmaktnuM?si=V7H9cyhcH00A8c-6)

### ¿Qué es el Proveedor (`Provider`)? 
Terraform no entiende nativamente a AWS. El `proveedor` es un "plugin" que actúa como traductor: toma tu código Terraform (HCL) y lo convierte en llamadas a la API de AWS para aprovisionar los recursos.

### Tipos de Proveedores
Existen proveedores oficiales (AWS, Azure), asociados (partners) y los creados por la comunidad. Todos se buscan y descargan desde el Terraform Registry.

### La regla de oro de las Versiones
Existen dos versiones distintas: la versión de Terraform y la versión del proveedor. Siempre debes "bloquear" la versión del proveedor en tu código usando operadores lógicos (como ~>) para asegurarte de que una actualización futura automática no rompa tu infraestructura.

### Seguridad de Credenciales
Aunque el bloque del proveedor te permite definir tu región por defecto (ej. us-east-1), nunca debes "hardcodear" o escribir tus contraseñas y claves de acceso directamente allí. Lo ideal es configurar esto externamente usando comandos como aws configure.

### El paso a paso
Para que Terraform entienda tu código, primero debes ejecutar `terraform init`, el cual se encarga de descargar este plugin del proveedor. Luego, ejecutas terraform plan para comparar tu código con la nube y ver qué se creará.

### Version Constraints
Es bueno usar version constraints para especificar versiones aceptables del provider:

- `= 1.2.3` - Version exacta
- `>= 1.2` - Mayor que o igual a
- `<= 1.2` - Menor que o igual a
- `~> 1.2` - Pessimistic constraint
- `>= 1.2, < 2.0` - Rango de constraint

### Configuración básica de un provider
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

### Múltiples versiones de providers
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}
```