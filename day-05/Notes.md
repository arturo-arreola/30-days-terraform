# Día 5/28 - Demo de Variables en Terraform

Una demo sencilla que muestra los tres tipos de variables en Terraform usando un bucket S3 básico.

## 🎯 Los Tres Tipos de Variables

### 1. **Variables de Entrada** (`variables.tf`)
Valores que tú proporcionas a Terraform — como parámetros de una función
```hcl
variable "environment" {
  description = "Nombre del entorno"
  type        = string
  default     = "staging"
}
```

### 2. **Variables Locales** (`locals.tf`)
Valores calculados internamente — como variables locales en programación
```hcl
locals {
  common_tags = {
    Environment = var.environment
    Project     = "Terraform-Demo"
  }
  
  full_bucket_name = "${var.environment}-${var.bucket_name}-${random_string.suffix.result}"
}
```

### 3. **Variables de Salida** (`output.tf`)
Valores retornados después del despliegue — como el valor de retorno de una función
```hcl
output "bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.demo.bucket
}
```

## 📥 Variables de Entrada en Detalle

### ¿Qué son las Variables de Entrada?
Las variables de entrada son como **parámetros de función** — permiten personalizar tu configuración de Terraform sin necesidad de codificar valores directamente.

### Estructura Básica de una Variable de Entrada
```hcl
variable "nombre_variable" {
  description = "Para qué sirve esta variable"
  type        = string
  default     = "valor_por_defecto"  # Opcional
}
```

### Cómo Usar Variables de Entrada
```hcl
# Definir en variables.tf
variable "environment" {
  description = "Nombre del entorno"
  type        = string
  default     = "staging"
}

variable "bucket_name" {
  description = "Nombre del bucket S3"
  type        = string
  default     = "my-terraform-bucket"
}

# Referenciar con el prefijo var. en main.tf
resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name  # Usando variable de entrada
  
  tags = {
    Environment = var.environment  # Usando variable de entrada
  }
}
```

### Formas de Proveer Valores a las Variables de Entrada

**1. Valores por defecto** (en variables.tf)
```hcl
variable "environment" {
  default = "staging"
}
```

**2. Archivo terraform.tfvars** (cargado automáticamente)
```hcl
environment = "demo"
bucket_name = "terraform-demo-bucket"
```

**3. Línea de comandos**
```bash
terraform plan -var="environment=production"
```

**4. Variables de entorno**
```bash
export TF_VAR_environment="development"
terraform plan
```

## 📤 Variables de Salida en Detalle

### ¿Qué son las Variables de Salida?
Las variables de salida son como **valores de retorno de una función** — muestran información importante después de que Terraform crea tu infraestructura.

### Estructura Básica de una Variable de Salida
```hcl
output "nombre_output" {
  description = "Qué muestra este output"
  value       = recurso.nombre_recurso.atributo
}
```

### Cómo Usar Variables de Salida

**Definir en output.tf**
```hcl
# Output de un atributo de recurso
output "bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.demo.bucket
}

output "bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.demo.arn
}

# Output de una variable de entrada (para confirmar el valor usado)
output "environment" {
  description = "Entorno obtenido de la variable de entrada"
  value       = var.environment
}

# Output de una variable local (para ver valores calculados)
output "tags" {
  description = "Etiquetas obtenidas de la variable local"
  value       = local.common_tags
}
```

### Ver los Outputs

Después de ejecutar `terraform apply`, puedes consultar los outputs:
```bash
terraform output                    # Mostrar todos los outputs
terraform output bucket_name        # Mostrar un output específico
terraform output -json              # Mostrar todos los outputs en formato JSON
```

**Ejemplo de salida:**
```
bucket_arn = "arn:aws:s3:::demo-terraform-demo-bucket-abc123"
bucket_name = "demo-terraform-demo-bucket-abc123"
environment = "demo"
tags = {
  "Environment" = "demo"
  "Owner" = "DevOps-Team"
  "Project" = "Terraform-Demo"
}
```

## 🏗️ ¿Qué Crea Esta Configuración?

Solo un bucket S3 sencillo que demuestra los tres tipos de variables:
- Usa **variables de entrada** para el entorno y el nombre del bucket
- Usa **variables locales** para calcular el nombre del bucket y las etiquetas
- Usa **variables de salida** para mostrar los detalles del bucket creado

## 🚀 Prueba de Precedencia de Variables

### 1. **Valores por Defecto** (ocultar temporalmente terraform.tfvars)
```bash
mv terraform.tfvars terraform.tfvars.backup
terraform plan
# Usa: environment = "staging" (valor por defecto en variables.tf)
mv terraform.tfvars.backup terraform.tfvars  # restaurar
```

### 2. **Usando terraform.tfvars** (cargado automáticamente)
```bash
terraform plan
# Usa: environment = "demo" (desde terraform.tfvars)
```

### 3. **Sobreescritura por Línea de Comandos** (mayor precedencia)
```bash
terraform plan -var="environment=production"
# Sobreescribe tfvars: environment = "production"
```

### 4. **Variables de Entorno**
```bash
export TF_VAR_environment="staging-from-env"
terraform plan
# Usa la variable de entorno (pero la línea de comandos sigue ganando)
```

### 5. **Usando Archivos tfvars Alternativos**
```bash
terraform plan -var-file="dev.tfvars"        # environment = "development"
terraform plan -var-file="production.tfvars"  # environment = "production"
```

## 📁 Estructura de Archivos
```
├── main.tf           # Recurso del bucket S3
├── variables.tf      # Variables de entrada (2 variables simples)
├── locals.tf         # Variables locales (etiquetas y nombre calculado)
├── output.tf         # Variables de salida (detalles del bucket)
├── provider.tf       # Proveedor AWS
├── terraform.tfvars  # Valores por defecto de las variables
└── README.md         # Este archivo
```

## 🧪 Ejemplos Prácticos

### Ejemplo 1: Probar Diferentes Valores de Entrada
```bash
# Probar con valores por defecto (ocultar temporalmente terraform.tfvars)
mv terraform.tfvars terraform.tfvars.backup
terraform plan
# Muestra: Environment = "staging", el bucket será "staging-my-terraform-bucket-xxxxx"

# Probar con terraform.tfvars
mv terraform.tfvars.backup terraform.tfvars
terraform plan  
# Muestra: Environment = "demo", el bucket será "demo-terraform-demo-bucket-xxxxx"

# Probar con sobreescritura por línea de comandos
terraform plan -var="environment=test" -var="bucket_name=my-test-bucket"
# Muestra: Environment = "test", el bucket será "test-my-test-bucket-xxxxx"
```

### Ejemplo 2: Ver los Tres Tipos de Variables en Acción
```bash
# Aplicar la configuración
terraform apply -auto-approve

# Ver todos los outputs (muestra las variables de salida)
terraform output
# bucket_arn = "arn:aws:s3:::demo-terraform-demo-bucket-abc123"
# bucket_name = "demo-terraform-demo-bucket-abc123"  
# environment = "demo"                                # (variable de entrada)
# tags = {                                           # (variable local)
#   "Environment" = "demo"
#   "Owner" = "DevOps-Team"  
#   "Project" = "Terraform-Demo"
# }

# Ver cómo las variables locales calcularon el nombre del bucket
echo "Entrada: environment = $(terraform output -raw environment)"
echo "Entrada: bucket_name = terraform-demo-bucket (desde tfvars)"  
echo "Local: full_bucket_name = $(terraform output -raw bucket_name)"
echo "¡El sufijo aleatorio fue añadido por la variable local!"
```

### Ejemplo 3: Precedencia de Variables en Acción
```bash
# Comenzar con terraform.tfvars (environment = "demo")
terraform plan | grep Environment
# Muestra: "Environment" = "demo"

# Sobreescribir con variable de entorno
export TF_VAR_environment="desde-variable-entorno"
terraform plan | grep Environment  
# Muestra: "Environment" = "desde-variable-entorno"

# Sobreescribir con línea de comandos (mayor precedencia)
terraform plan -var="environment=desde-linea-comandos" | grep Environment
# Muestra: "Environment" = "desde-linea-comandos"

# Limpiar
unset TF_VAR_environment
```

## 🔧 Comandos para Practicar
```bash
# Inicializar
terraform init

# Planificar con valores por defecto
terraform plan

# Planificar con sobreescritura por línea de comandos
terraform plan -var="environment=test"

# Planificar con un archivo tfvars alternativo
terraform plan -var-file="dev.tfvars"

# Aplicar y ver outputs
terraform apply
terraform output

# Destruir la infraestructura
terraform destroy
```

## 💡 Conclusiones Clave

- **Variables de entrada**: Parametrizan tu configuración
- **Variables locales**: Calculan y reutilizan valores internamente
- **Variables de salida**: Exponen resultados después del despliegue
- **Precedencia**: Línea de comandos > tfvars > variables de entorno > valores por defecto

¡Este ejemplo sencillo muestra exactamente cómo funciona el sistema de variables — claro, enfocado y fácil de entender!