# Guía de Aprendizaje de Funciones en Terraform - Edición AWS (Días 11-12)

## 📚 Descripción General

¡Bienvenido a la guía completa de funciones en Terraform! Este módulo de dos días cubre las funciones integradas de Terraform a través de 12 ejercicios prácticos. Cada ejercicio se enfoca en funciones específicas y casos de uso del mundo real.

**📋 Para instrucciones detalladas del demo paso a paso, consulta [DEMO_GUIDE.md](DEMO_GUIDE.md)**

---

## 🎯 Objetivos de Aprendizaje

Al finalizar este módulo, serás capaz de:
1. Dominar las funciones integradas de Terraform en todas sus categorías
2. Entender cuándo y cómo usar cada tipo de función
3. Combinar múltiples funciones de forma efectiva
4. Usar con soltura la consola de Terraform para pruebas
5. Implementar validaciones y manejo de errores adecuados
6. Manejar datos sensibles de forma segura
7. Crear configuraciones dinámicas y reutilizables

---

## Comandos de Consola

Practica estos comandos fundamentales en `terraform console` antes de comenzar los ejercicios:
```hcl
# Manipulación Básica de Strings
lower("HELLO WORLD")
max(5, 12, 9)
trim("  hello  ")
chomp("hello\n")
reverse(["a", "b", "c"])
```

## 📋 Resumen de Ejercicios

| # | Ejercicio | Funciones | Dificultad | Recursos AWS |
|---|-----------|-----------|------------|--------------|
| 1 | Nomenclatura de Proyectos | `lower`, `replace` | ⭐ | Resource Group |
| 2 | Etiquetado de Recursos | `merge` | ⭐ | VPC |
| 3 | Nomenclatura de Buckets S3 | `substr`, `replace`, `lower` | ⭐⭐ | S3 Bucket |
| 4 | Puertos de Security Groups | `split`, `join`, `for` | ⭐⭐ | Security Group |
| 5 | Búsqueda por Entorno | `lookup` | ⭐⭐ | Instancia EC2 |
| 6 | Validación de Instancias | `length`, `can`, `regex` | ⭐⭐⭐ | Instancia EC2 |
| 7 | Configuración de Backups | `endswith`, `sensitive` | ⭐⭐ | Ninguno |
| 8 | Procesamiento de Rutas de Archivos | `fileexists`, `dirname` | ⭐⭐ | Ninguno |
| 9 | Gestión de Ubicaciones | `toset`, `concat` | ⭐ | Ninguno |
| 10 | Cálculo de Costos | `abs`, `max`, `sum` | ⭐⭐ | Ninguno |
| 11 | Gestión de Timestamps | `timestamp`, `formatdate` | ⭐⭐ | S3 Bucket |
| 12 | Manejo de Contenido de Archivos | `file`, `jsondecode` | ⭐⭐⭐ | Secrets Manager |

---

## 🚀 Inicio Rápido
```bash
# Navegar al directorio
cd /home/baivab/repos/Terraform-Full-Course-Aws/lessons/day11-12

# Inicializar
terraform init

# Comenzar con el Ejercicio 1 (ya descomentado por defecto)
terraform plan
terraform apply -auto-approve

# Ver outputs
terraform output

# Limpieza
terraform destroy -auto-approve
```

---

## 📖 Categorías de Funciones

### Funciones de String
`lower()`, `upper()`, `replace()`, `substr()`, `trim()`, `split()`, `join()`, `chomp()`

### Funciones Numéricas
`abs()`, `max()`, `min()`, `ceil()`, `floor()`, `sum()`

### Funciones de Colección
`length()`, `concat()`, `merge()`, `reverse()`, `toset()`, `tolist()`

### Conversión de Tipos
`tonumber()`, `tostring()`, `tobool()`, `toset()`, `tolist()`

### Funciones de Archivo
`file()`, `fileexists()`, `dirname()`, `basename()`

### Funciones de Fecha/Hora
`timestamp()`, `formatdate()`, `timeadd()`

### Funciones de Validación
`can()`, `regex()`, `contains()`, `startswith()`, `endswith()`

### Funciones de Búsqueda
`lookup()`, `element()`, `index()`

---


## ✅ Resumen de Ejercicios

### Ejercicio 1: Nomenclatura de Proyectos ⭐
Transforma "Project ALPHA Resource" → "project-alpha-resource"

**Funciones:** `lower()`, `replace()`  
**Estado:** ✅ Activo por defecto

### Ejercicio 2: Etiquetado de Recursos ⭐
Combinar etiquetas por defecto y etiquetas de entorno

**Función:** `merge()`

### Ejercicio 3: Nomenclatura de Buckets S3 ⭐⭐
Sanear nombres de buckets para cumplir con los requisitos de AWS

**Funciones:** `substr()`, `replace()`, `lower()`

### Ejercicio 4: Puertos de Security Groups ⭐⭐
Transformar "80,443,8080" en reglas de security group

**Funciones:** `split()`, `join()`, `for`

### Ejercicio 5: Búsqueda por Entorno ⭐⭐
Seleccionar el tamaño de instancia según el entorno

**Función:** `lookup()`

### Ejercicio 6: Validación de Instancias ⭐⭐⭐
Validar el formato del tipo de instancia

**Funciones:** `length()`, `can()`, `regex()`

### Ejercicio 7: Configuración de Backups ⭐⭐
Validar nombres y manejar datos sensibles

**Funciones:** `endswith()`, `sensitive`

### Ejercicio 8: Procesamiento de Rutas de Archivos ⭐⭐
Verificar la existencia de archivos y extraer rutas

**Funciones:** `fileexists()`, `dirname()`

### Ejercicio 9: Gestión de Ubicaciones ⭐
Combinar regiones y eliminar duplicados

**Funciones:** `toset()`, `concat()`

### Ejercicio 10: Cálculo de Costos ⭐⭐
Procesar costos con créditos aplicados

**Funciones:** `abs()`, `max()`, `sum()`

### Ejercicio 11: Gestión de Timestamps ⭐⭐
Formatear timestamps para recursos y etiquetas

**Funciones:** `timestamp()`, `formatdate()`

### Ejercicio 12: Manejo de Contenido de Archivos ⭐⭐⭐
Leer configuración JSON y almacenarla en Secrets Manager

**Funciones:** `file()`, `jsondecode()`, `jsonencode()`

---