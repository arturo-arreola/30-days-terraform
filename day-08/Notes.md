## 📚 Qué Aprenderás

- Comprender todos los meta-argumentos de Terraform
- **count** - Crear múltiples recursos con indexación numérica
- **for_each** - Crear múltiples recursos con maps/sets
- **depends_on** - Dependencias explícitas entre recursos
- **lifecycle** - Controlar el comportamiento de creación y destrucción de recursos
- **provider** - Usar configuraciones alternativas de proveedor
- Transformaciones de outputs con expresiones `for`
- Buenas prácticas para cada meta-argumento

## 📁 Estructura de la Lección
```
day08/
├── provider.tf      # Configuración del proveedor AWS
├── variables.tf     # Variables de entrada (tipos list, set, map, object)
├── local.tf         # Valores locales y etiquetas comunes
├── backend.tf       # Configuración del backend en S3
├── main.tf          # Definiciones principales de recursos con ejemplos de count y for_each
├── output.tf        # Valores de salida que demuestran el uso de bucles for
├── task.md          # Ejercicios prácticos y tareas
└── README.md        # Este archivo
```

## 🎯 Conceptos Clave

### Resumen de Meta-Argumentos

Los meta-argumentos son argumentos especiales que pueden usarse con **cualquier tipo de recurso** para modificar su comportamiento:

1. **count** - Crear múltiples instancias de un recurso basándose en un número
2. **for_each** - Crear múltiples instancias de un recurso basándose en un map o set
3. **depends_on** - Dependencias explícitas entre recursos
4. **lifecycle** - Personalizar el comportamiento del ciclo de vida de un recurso
5. **provider** - Seleccionar una configuración de proveedor no predeterminada
6. **provisioner** - Ejecutar scripts al crear o destruir recursos (no recomendado)

**¡Esta lección incluye ejemplos simples para todos los meta-argumentos!**

### Meta-Argumento COUNT
```hcl
resource "aws_s3_bucket" "example" {
  count  = 3
  bucket = "my-bucket-${count.index}"
}
```

**Casos de uso:**
- Crear N recursos idénticos
- Iteración simple sobre una lista
- Cuando un índice numérico es suficiente

**Limitaciones:**
- Eliminar elementos del medio de una lista provoca la recreación de recursos
- Direccionamiento de recursos menos estable
- Más difícil de mantener

### Meta-Argumento FOR_EACH
```hcl
resource "aws_s3_bucket" "example" {
  for_each = toset(["bucket1", "bucket2", "bucket3"])
  bucket   = each.value
}
```

**Casos de uso:**
- Crear recursos a partir de un map o set
- Direccionamiento estable de recursos por clave
- Entornos de producción
- Configuraciones de recursos complejas

**Ventajas:**
- Agregar o eliminar elementos no afecta a los demás recursos
- Referencias a recursos más legibles
- Mejor opción para producción

### Meta-Argumento DEPENDS_ON
```hcl
resource "aws_s3_bucket" "dependent" {
  bucket = "my-bucket"
  
  depends_on = [aws_s3_bucket.primary]
}
```

**Casos de uso:**
- Ordenamiento explícito de recursos
- Dependencias implícitas no capturadas por referencias directas
- Garantizar que los recursos se creen en un orden específico

### Meta-Argumento LIFECYCLE
```hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-bucket"
  
  lifecycle {
    prevent_destroy       = true  # Prevenir eliminación accidental
    create_before_destroy = true  # Crear el nuevo antes de destruir el antiguo
    ignore_changes        = [tags] # Ignorar cambios en las etiquetas
  }
}
```

**Casos de uso:**
- Proteger recursos críticos de ser eliminados
- Actualizaciones sin tiempo de inactividad (zero-downtime)
- Ignorar cambios externos en atributos específicos

### Meta-Argumento PROVIDER
```hcl
resource "aws_s3_bucket" "example" {
  provider = aws.west  # Usar proveedor alternativo
  bucket   = "my-bucket"
}
```

**Casos de uso:**
- Despliegues multi-región
- Configuraciones multi-cuenta
- Replicación entre regiones

## 🚀 Inicio Rápido

### Requisitos Previos

- Terraform >= 1.9.0
- AWS CLI configurado con las credenciales adecuadas
- Conocimiento básico de la sintaxis de Terraform

### Pasos

1. **Clona y navega a la carpeta de la lección:**
```bash
   cd lessons/day08
```

2. **Actualiza las variables (¡importante!):**
   - Edita `variables.tf` o crea un archivo `terraform.tfvars`
   - Cambia los nombres de los buckets S3 para que sean globalmente únicos
   - Actualiza la región de AWS si es necesario

3. **Inicializa Terraform:**
```bash
   terraform init
```

4. **Formatea el código:**
```bash
   terraform fmt
```

5. **Valida la configuración:**
```bash
   terraform validate
```

6. **Revisa el plan de ejecución:**
```bash
   terraform plan
```

7. **Aplica (opcional):**
```bash
   terraform apply
```

8. **Consulta los outputs:**
```bash
   terraform output
```

9. **Limpieza:**
```bash
   terraform destroy
```

## 📝 Ejemplos Incluidos

### 1. Meta-Argumento COUNT
- Crea múltiples buckets S3 usando una variable de tipo lista
- Demuestra el uso de `count.index`
- Direccionamiento de recursos basado en índice

### 2. Meta-Argumento FOR_EACH (Set)
- Crea buckets S3 usando una variable de tipo set
- Demuestra el uso de `each.key` y `each.value`
- Direccionamiento de recursos más estable

### 3. Meta-Argumento DEPENDS_ON
- Muestra dependencias explícitas entre recursos
- Ejemplo con bucket primario y bucket dependiente
- Control del orden de creación de recursos

### 4. Meta-Argumento LIFECYCLE
- Demuestra `prevent_destroy`, `create_before_destroy` e `ignore_changes`
- Protege recursos críticos
- Maneja actualizaciones sin tiempo de inactividad

### 5. Meta-Argumento PROVIDER
- Muestra cómo usar proveedores alternativos (ejemplo comentado)
- Patrón de despliegue multi-región
- Alias de proveedores

### 6. Outputs Avanzados
- Expresiones splat (`[*]`)
- Bucles `for` en outputs
- Transformaciones de maps
- Outputs combinados

## 🎓 Ruta de Aprendizaje

1. **Comienza con las Tareas 1-3** en `task.md` para entender los conceptos básicos
2. **Practica con las Tareas 4-5** para crear tus propios recursos
3. **Domina los outputs con la Tarea 6**
4. **Profundiza con la Tarea 7** para entender las diferencias entre count y for_each
5. **Aplica el conocimiento con la Tarea 8** en un escenario del mundo real

## ⚠️ Notas Importantes

### Nombres de Buckets S3
- Los nombres de buckets S3 deben ser **globalmente únicos** en todas las cuentas de AWS
- Actualiza los nombres de bucket por defecto en `variables.tf` antes de aplicar
- Usa el prefijo de tu organización o un identificador único

### Configuración del Backend
- El archivo `backend.tf` usa S3 para el estado remoto
- Comenta el bloque de backend si deseas usar estado local
- Crea el bucket S3 manualmente antes de ejecutar `terraform init`

### Costos
- La mayoría de los recursos de esta lección son elegibles para el nivel gratuito
- Los buckets S3 generan costos mínimos de almacenamiento
- Los usuarios de IAM son gratuitos
- **¡Siempre ejecuta `terraform destroy` al terminar!**

## 🔍 Diferencias Clave: COUNT vs FOR_EACH

| Característica | COUNT | FOR_EACH |
|----------------|-------|----------|
| **Tipo de Entrada** | Número o lista | Map o set |
| **Direccionamiento** | Índice numérico `[0]` | Basado en clave `["nombre"]` |
| **Estabilidad** | Menos estable | Más estable |
| **Eliminación de Elementos** | Puede recrear recursos | Solo elimina el recurso específico |
| **Caso de Uso** | Escenarios simples | Entornos de producción |
| **Legibilidad** | Basada en índice | Basada en nombre (mejor) |

## 💡 Buenas Prácticas

1. **Prefiere for_each sobre count** en entornos de producción
2. **Usa claves descriptivas** al usar for_each con maps
3. **Usa toset()** para convertir listas en sets para for_each
4. **Agrega etiquetas adecuadas** a todos los recursos para mejor organización
5. **Documenta tus decisiones** — explica por qué elegiste count o for_each
6. **Prueba las eliminaciones** — comprende qué ocurre al eliminar elementos

## 🔗 Recursos Adicionales

- [Meta-Argumento Count en Terraform](https://www.terraform.io/language/meta-arguments/count)
- [Meta-Argumento For_Each en Terraform](https://www.terraform.io/language/meta-arguments/for_each)
- [Expresiones For](https://www.terraform.io/language/expressions/for)
- [Expresiones Splat](https://www.terraform.io/language/expressions/splat)