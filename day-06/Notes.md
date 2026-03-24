# Día 6: Estructura de Archivos

## Temas Cubiertos
- Organización de archivos en Terraform
- Secuencia de carga de archivos
- Buenas prácticas para la estructura de archivos
- Patrones de organización de código

## Puntos Clave de Aprendizaje

### Carga de Archivos en Terraform
- Terraform carga todos los archivos `.tf` del directorio actual
- Los archivos se cargan en **orden lexicográfico** (alfabético)
- El nombre de los archivos no afecta la funcionalidad, solo la organización
- Todos los archivos `.tf` se fusionan en una única configuración

### Estructura de Archivos Recomendada
```
project-root/
├── backend.tf           # Configuración del backend
├── provider.tf          # Configuración de proveedores
├── variables.tf         # Definición de variables de entrada
├── locals.tf            # Definición de valores locales
├── main.tf              # Definición principal de recursos
├── vpc.tf               # Recursos relacionados con la VPC
├── security.tf          # Grupos de seguridad, NACLs
├── compute.tf           # EC2, Auto Scaling, etc.
├── storage.tf           # Recursos S3, EBS, EFS
├── database.tf          # Recursos RDS, DynamoDB
├── outputs.tf           # Definición de outputs
├── terraform.tfvars     # Valores de las variables
└── README.md            # Documentación
```

### Principios de Organización de Archivos
1. **Separación de Responsabilidades**: Agrupa los recursos relacionados
2. **Agrupación Lógica**: Organiza por servicio o función
3. **Nomenclatura Consistente**: Usa nombres de archivo claros y descriptivos
4. **Enfoque Modular**: Mantén los archivos enfocados en áreas específicas
5. **Documentación**: Incluye README y comentarios

## Tareas de Práctica

### Tarea: Reorganizar los Archivos del Día Anterior
Usando los archivos del Día 5, divide la configuración en archivos separados:

#### backend.tf
```hcl
terraform {
  required_version = ">= 1.0"
  
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

  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

#### provider.tf
```hcl
provider "aws" {
  region = var.region

  default_tags {
    tags = local.common_tags
  }
}
```

#### variables.tf
```hcl
variable "environment" {
  description = "Nombre del entorno (dev, staging, production)"
  type        = string
  default     = "staging"
  
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "El entorno debe ser dev, staging o production."
  }
}

variable "region" {
  description = "Región de AWS para los recursos"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC"
  type        = string
  default     = "10.0.0.0/16"
  
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "El CIDR de la VPC debe ser un bloque CIDR IPv4 válido."
  }
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "tags" {
  description = "Etiquetas adicionales a aplicar a los recursos"
  type        = map(string)
  default     = {}
}
```

#### locals.tf
```hcl
locals {
  # Etiquetas comunes aplicadas a todos los recursos
  common_tags = merge(var.tags, {
    Environment   = var.environment
    Project       = var.project_name
    ManagedBy     = "Terraform"
    CreatedDate   = formatdate("YYYY-MM-DD", timestamp())
  })

  # Convención de nomenclatura
  name_prefix = "${var.project_name}-${var.environment}"
  
  # Configuración de red
  vpc_name = "${local.name_prefix}-vpc"
  
  # Configuración de almacenamiento  
  bucket_name = "${local.name_prefix}-${random_id.bucket_suffix.hex}"
}

# Sufijo aleatorio para nombres globalmente únicos
resource "random_id" "bucket_suffix" {
  byte_length = 4
  
  keepers = {
    project     = var.project_name
    environment = var.environment
  }
}
```

#### vpc.tf
```hcl
# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = local.vpc_name
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-igw"
  })
}

# Subredes Públicas
resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-public-subnet-${count.index + 1}"
    Type = "Public"
  })
}

# Tabla de Rutas para Subredes Públicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-public-rt"
  })
}

# Asociar Tabla de Rutas con Subredes Públicas
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
```

#### storage.tf
```hcl
# Bucket S3
resource "aws_s3_bucket" "main" {
  bucket = local.bucket_name

  tags = merge(local.common_tags, {
    Name        = local.bucket_name
    Purpose     = "Almacenamiento general"
    Environment = var.environment
  })
}

# Versionado del Bucket S3
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Cifrado del lado del servidor para el Bucket S3
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Bloqueo de acceso público al Bucket S3
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

#### outputs.tf
```hcl
# Outputs de la VPC
output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "Bloque CIDR de la VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_arn" {
  description = "ARN de la VPC"
  value       = aws_vpc.main.arn
}

# Outputs de las Subredes
output "public_subnet_ids" {
  description = "IDs de las subredes públicas"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "Bloques CIDR de las subredes públicas"
  value       = aws_subnet.public[*].cidr_block
}

# Outputs de S3
output "s3_bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.main.bucket
}

output "s3_bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.main.arn
}

output "s3_bucket_domain_name" {
  description = "Nombre de dominio del bucket S3"
  value       = aws_s3_bucket.main.bucket_domain_name
}

# Outputs del Entorno
output "environment" {
  description = "Nombre del entorno"
  value       = var.environment
}

output "region" {
  description = "Región de AWS"
  value       = var.region
}

output "common_tags" {
  description = "Etiquetas comunes aplicadas a los recursos"
  value       = local.common_tags
}
```

#### terraform.tfvars
```hcl
# Configuración del Proyecto
project_name = "aws-terraform-course"
environment  = "demo"
region       = "us-east-1"

# Configuración de Red
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

# Etiquetas
tags = {
  Owner       = "DevOps-Team"
  Department  = "Engineering"
  CostCenter  = "Engineering-001"
  Project     = "TerraformLearning"
}
```

### Patrones Avanzados de Organización de Archivos

#### Estructura por Entorno
```
environments/
├── dev/
│   ├── backend.tf
│   ├── terraform.tfvars
│   └── main.tf
├── staging/
│   ├── backend.tf
│   ├── terraform.tfvars
│   └── main.tf
└── production/
    ├── backend.tf
    ├── terraform.tfvars
    └── main.tf

modules/
├── vpc/
├── security/
└── compute/

shared/
├── variables.tf
├── outputs.tf
└── locals.tf
```

#### Estructura por Servicio
```
infrastructure/
├── networking/
│   ├── vpc.tf
│   ├── subnets.tf
│   └── routing.tf
├── security/
│   ├── security-groups.tf
│   ├── nacls.tf
│   └── iam.tf
├── compute/
│   ├── ec2.tf
│   ├── autoscaling.tf
│   └── load-balancers.tf
├── storage/
│   ├── s3.tf
│   ├── ebs.tf
│   └── efs.tf
└── data/
    ├── rds.tf
    ├── dynamodb.tf
    └── elasticache.tf
```

### Buenas Prácticas

1. **Nomenclatura Consistente**
   - Usa nombres de archivo claros y descriptivos
   - Sigue las convenciones del equipo
   - Usa minúsculas con guiones o guiones bajos

2. **Agrupación Lógica**
   - Agrupa los recursos relacionados
   - Separa por servicio de AWS o por función
   - Considera las dependencias al organizar

3. **Gestión del Tamaño**
   - Mantén los archivos manejables (< 500 líneas)
   - Divide archivos grandes por funcionalidad
   - Usa módulos para componentes reutilizables

4. **Dependencias**
   - Coloca primero las configuraciones del proveedor y del backend
   - Define las variables antes de usarlas
   - Declara los outputs al final

5. **Documentación**
   - Incluye un README.md
   - Comenta las configuraciones complejas
   - Documenta el propósito de cada variable

### Comandos para Validar
```bash
# Validar la estructura reorganizada
terraform validate

# Formatear todos los archivos de manera consistente
terraform fmt -recursive

# Planificar para asegurarse de que no hay cambios
terraform plan

# Aplicar si todo se ve bien
terraform apply
```

### Errores Comunes en la Organización de Archivos

1. **Todo en main.tf** — Dificulta la navegación del código
2. **Nomenclatura inconsistente** — Confunde a los miembros del equipo
3. **Mezcla de responsabilidades** — Recursos que no pertenecen al mismo archivo
4. **Sin documentación** — Dificulta la comprensión para otros
5. **Estructura excesivamente compleja** — Lo simple suele ser mejor

## Próximos Pasos
Continúa con el Día 7 para aprender sobre las restricciones de tipos en Terraform y cómo definir y validar correctamente los tipos de variables.