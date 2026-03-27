# Día 9: Meta-argumentos de Lifecycle en Terraform (AWS)

## 📚 Temas Cubiertos
- `create_before_destroy` - Despliegues sin tiempo de inactividad
- `prevent_destroy` - Proteger recursos críticos
- `ignore_changes` - Manejar modificaciones externas
- `replace_triggered_by` - Reemplazos basados en dependencias
- `precondition` - Validación previa al despliegue
- `postcondition` - Validación posterior al despliegue

---

## 🎯 Objetivos de Aprendizaje

Al finalizar esta lección, serás capaz de:
1. Comprender todos los meta-argumentos de lifecycle en Terraform
2. Saber cuándo usar cada regla de lifecycle
3. Proteger recursos en producción
4. Implementar despliegues sin tiempo de inactividad
5. Manejar recursos modificados por sistemas externos
6. Validar recursos antes y después de su creación

---

## 🔧 Meta-argumentos de Lifecycle Explicados

### 1. create_before_destroy

**¿Qué hace?**  
Obliga a Terraform a crear el recurso de reemplazo ANTES de destruir el recurso original.

**Comportamiento por defecto:**  
Normalmente, Terraform destruye el recurso antiguo primero y luego crea el nuevo.

**Casos de uso:**
- ✅ Instancias EC2 detrás de load balancers (sin tiempo de inactividad)
- ✅ Instancias RDS con réplicas de lectura
- ✅ Infraestructura crítica que no puede tener interrupciones
- ✅ Recursos referenciados por otra infraestructura

**Ejemplo:**
```hcl
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }
}
```

**Ventajas:**
- ✅ Previene interrupciones del servicio
- ✅ Mantiene la disponibilidad del recurso durante las actualizaciones
- ✅ Reduce los riesgos durante el despliegue
- ✅ Habilita despliegues blue-green

**Cuándo NO usarlo:**
- ❌ Cuando el nombre del recurso debe ser único e invariable
- ❌ Cuando puedes permitirte tiempo de inactividad
- ❌ Cuando quieres minimizar costos (se crean recursos duplicados temporalmente)

---

### 2. prevent_destroy

**¿Qué hace?**  
Impide que Terraform destruya un recurso. Si se intenta la destrucción, Terraform lanzará un error.

**Casos de uso:**
- ✅ Bases de datos en producción
- ✅ Buckets S3 críticos con datos importantes
- ✅ Security groups que protegen recursos de producción
- ✅ Recursos con estado que nunca deben eliminarse

**Ejemplo:**
```hcl
resource "aws_s3_bucket" "critical_data" {
  bucket = "my-critical-production-data"

  lifecycle {
    prevent_destroy = true
  }
}
```

**Ventajas:**
- ✅ Protege contra eliminaciones accidentales
- ✅ Agrega una capa de seguridad a los recursos críticos
- ✅ Previene la pérdida de datos
- ✅ Exige intervención manual para la eliminación

**Cómo eliminarlo:**
1. Comenta `prevent_destroy = true`
2. Ejecuta `terraform apply` para actualizar el estado
3. Ahora puedes destruir el recurso

**Cuándo usarlo:**
- ✅ Bases de datos en producción
- ✅ Almacenamiento de archivos de estado
- ✅ Recursos requeridos por normativas de cumplimiento
- ✅ Recursos con datos importantes

---

### 3. ignore_changes

**¿Qué hace?**  
Indica a Terraform que ignore los cambios en atributos específicos de un recurso. Terraform no intentará revertir esos cambios.

**Casos de uso:**
- ✅ Capacidad de Auto Scaling Groups (gestionada por políticas de auto-scaling)
- ✅ Etiquetas de instancias EC2 (agregadas por herramientas de monitoreo)
- ✅ Reglas de security groups (gestionadas por otros equipos)
- ✅ Contraseñas de bases de datos (gestionadas vía Secrets Manager)

**Ejemplo:**
```hcl
resource "aws_autoscaling_group" "app_servers" {
  # ... otra configuración ...
  
  desired_capacity = 2

  lifecycle {
    ignore_changes = [
      desired_capacity,  # Ignorar cambios de capacidad por auto-scaling
      load_balancers,    # Ignorar si se agregan externamente
    ]
  }
}
```

**Valores especiales:**
- `ignore_changes = all` - Ignorar TODOS los cambios de atributos
- `ignore_changes = [tags]` - Ignorar solo las etiquetas

**Ventajas:**
- ✅ Evita problemas de drift en la configuración
- ✅ Permite que sistemas externos gestionen ciertos atributos
- ✅ Reduce el ruido en el output de `terraform plan`
- ✅ Habilita enfoques de gestión híbrida

**Cuándo usarlo:**
- ✅ Recursos modificados por auto-scaling
- ✅ Atributos gestionados por herramientas externas
- ✅ Valores que cambian frecuentemente
- ✅ Valores gestionados fuera de Terraform

---

### 4. replace_triggered_by

**¿Qué hace?**  
Fuerza el reemplazo de un recurso cuando cambian las dependencias especificadas, incluso si el recurso en sí no ha cambiado.

**Casos de uso:**
- ✅ Reemplazar instancias EC2 cuando cambian los security groups
- ✅ Recrear contenedores cuando cambia la configuración
- ✅ Forzar la rotación de recursos basándose en actualizaciones de otros recursos

**Ejemplo:**
```hcl
resource "aws_security_group" "app_sg" {
  name = "app-security-group"
  # ... reglas de seguridad ...
}

resource "aws_instance" "app_with_sg" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  lifecycle {
    replace_triggered_by = [
      aws_security_group.app_sg.id  # Reemplazar instancia cuando cambie el SG
    ]
  }
}
```

**Ventajas:**
- ✅ Garantiza consistencia tras cambios en dependencias
- ✅ Fuerza despliegues frescos
- ✅ Útil para patrones de infraestructura inmutable

**Cuándo usarlo:**
- ✅ Cuando cambios en recursos dependientes requieren recreación
- ✅ Para patrones de infraestructura inmutable
- ✅ Cuando quieres forzar la rotación de recursos

---

### 5. precondition

**¿Qué hace?**  
Valida condiciones ANTES de que Terraform intente crear o actualizar un recurso. Lanza un error si la condición es falsa.

**Casos de uso:**
- ✅ Validar que la región de despliegue está permitida
- ✅ Asegurar que las etiquetas requeridas están presentes
- ✅ Verificar variables de entorno antes del despliegue
- ✅ Validar parámetros de configuración

**Ejemplo:**
```hcl
resource "aws_s3_bucket" "regional_validation" {
  bucket = "validated-region-bucket"

  lifecycle {
    precondition {
      condition     = contains(var.allowed_regions, data.aws_region.current.name)
      error_message = "ERROR: Solo se puede desplegar en las regiones permitidas: ${join(", ", var.allowed_regions)}"
    }
  }
}
```

**Ventajas:**
- ✅ Detecta errores antes de la creación del recurso
- ✅ Aplica políticas organizacionales
- ✅ Proporciona mensajes de error claros
- ✅ Previene configuraciones inválidas

**Cuándo usarlo:**
- ✅ Aplicar requisitos de cumplimiento normativo
- ✅ Validar entradas antes del despliegue
- ✅ Asegurar que las dependencias están satisfechas
- ✅ Verificar restricciones del entorno

---

### 6. postcondition

**¿Qué hace?**  
Valida condiciones DESPUÉS de que Terraform crea o actualiza un recurso. Lanza un error si la condición es falsa.

**Casos de uso:**
- ✅ Asegurar que las etiquetas requeridas existen tras la creación
- ✅ Validar que los atributos del recurso están correctamente configurados
- ✅ Verificar el estado del recurso después del despliegue
- ✅ Comprobar el cumplimiento normativo tras la creación

**Ejemplo:**
```hcl
resource "aws_s3_bucket" "compliance_bucket" {
  bucket = "compliance-bucket"

  tags = {
    Environment = "production"
    Compliance  = "SOC2"
  }

  lifecycle {
    postcondition {
      condition     = contains(keys(self.tags), "Compliance")
      error_message = "ERROR: ¡El bucket debe tener una etiqueta 'Compliance'!"
    }

    postcondition {
      condition     = contains(keys(self.tags), "Environment")
      error_message = "ERROR: ¡El bucket debe tener una etiqueta 'Environment'!"
    }
  }
}
```

**Ventajas:**
- ✅ Verifica que el recurso fue creado correctamente
- ✅ Garantiza el cumplimiento normativo tras el despliegue
- ✅ Detecta problemas de configuración post-creación
- ✅ Valida el estado del recurso

**Cuándo usarlo:**
- ✅ Verificar que el recurso cumple los requisitos tras su creación
- ✅ Asegurar que las etiquetas o atributos están correctamente definidos
- ✅ Comprobar el estado del recurso post-despliegue
- ✅ Validar requisitos de cumplimiento normativo

---

## Patrones Comunes

### Patrón 1: Protección de Bases de Datos
Combinar `prevent_destroy` con `create_before_destroy` para instancias RDS.

### Patrón 2: Integración con Auto-Scaling
Usar `ignore_changes` para atributos gestionados por servicios de AWS.

### Patrón 3: Infraestructura Inmutable
Usar `replace_triggered_by` para despliegues basados en cambios de configuración.

## Buenas Prácticas
- Usa `create_before_destroy` para recursos críticos
- Aplica `prevent_destroy` a los almacenes de datos en producción
- Documenta todas las personalizaciones de lifecycle
- Prueba los comportamientos de lifecycle en desarrollo primero
- Ten cuidado con `ignore_changes` — puede ocultar cambios importantes

## Errores Comunes
- Olvidar las dependencias al usar `create_before_destroy`
- Abusar de `ignore_changes` y perder actualizaciones importantes
- No probar las reglas de lifecycle antes de aplicarlas en producción