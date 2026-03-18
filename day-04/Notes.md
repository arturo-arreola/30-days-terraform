# Día 4: Gestión del Archivo de Estado - Backend Remoto

## Temas Cubiertos
- Cómo Terraform actualiza la infraestructura
- El archivo de estado de Terraform (*state file*)
- Mejores prácticas para el archivo de estado
- Configuración de un *backend* remoto con S3
- Bloqueo de estado nativo de S3 (sin necesidad de DynamoDB)
- Gestión del estado

## Puntos Clave de Aprendizaje

### Cómo Terraform actualiza la infraestructura
- **Objetivo**: Mantener el estado real igual al estado deseado
- **Archivo de Estado**: El estado real reside en el archivo `terraform.tfstate`
- **Proceso**: Terraform compara el estado actual con la configuración deseada
- **Actualizaciones**: Solo modifica los recursos que realmente requieren cambios

### El Archivo de Estado de Terraform
El archivo de estado es un documento JSON que contiene:
- Metadatos de los recursos y configuración actual
- Dependencias entre recursos
- Información de los proveedores (*providers*)
- Valores de los atributos de los recursos

### Mejores prácticas para el archivo de estado
1. **Nunca edites el archivo de estado manualmente**
2. **Almacena el archivo de estado de forma remota** (no en el sistema de archivos local)
3. **Habilita el bloqueo de estado** (*state locking*) para evitar modificaciones simultáneas
4. **Realiza copias de seguridad** periódicas de los archivos de estado
5. **Usa archivos de estado separados** para diferentes entornos
6. **Restringe el acceso** a los archivos de estado, ya que contienen datos sensibles
7. **Cifra los archivos de estado** tanto en reposo como en tránsito

### Beneficios del Backend Remoto
- **Colaboración**: Los miembros del equipo pueden compartir el estado
- **Bloqueo**: Previene modificaciones de estado concurrentes
- **Seguridad**: Almacenamiento cifrado y control de acceso
- **Respaldo**: Versionado y copias de seguridad automáticas
- **Durabilidad**: Almacenamiento de alta disponibilidad

### Componentes del Backend Remoto en AWS
- **Bucket S3**: Almacena el archivo de estado
- **Bloqueo nativo de S3**: Utiliza las escrituras condicionales de S3 para el bloqueo (introducido en Terraform 1.10)
- **Políticas IAM**: Controlan el acceso a los recursos del *backend*

## Bloqueo de Estado Nativo de S3 (*S3 Native State Locking*)

### ¿Qué es el bloqueo nativo de S3?
A partir de **Terraform 1.10** (lanzado en 2024), ya no es necesario utilizar DynamoDB para el bloqueo de estado. Terraform ahora soporta el **bloqueo de estado nativo de S3** mediante la función de **Escrituras Condicionales** (*Conditional Writes*) de Amazon S3.

### Cómo funciona
El bloqueo nativo de S3 utiliza el encabezado HTTP **If-None-Match** para implementar operaciones atómicas:
1. Cuando Terraform necesita adquirir un bloqueo, intenta crear un archivo de bloqueo en S3.
2. Las escrituras condicionales de S3 verifican si el archivo de bloqueo ya existe.
3. Si el archivo existe, la operación de escritura falla

### State Commands
```bash
# Lista los recursos en el estado
terraform state list

# Muestra información detallada de un recurso
terraform state show <resource_name>

# Elimina un recurso del estado (sin destruirlo)
terraform state rm <resource_name>

# Mueve un recurso a una dirección de estado diferente
terraform state mv <source> <destination>

# Descarga y muestra el estado actual
terraform state pull
```

### Consideraciones de Seguridad
- **Política de Bucket S3**: Restringir el acceso solo a usuarios autorizados.
- **Versionado de S3**: Requerido para el bloqueo y para permitir la recuperación de estados anteriores.
- **Cifrado**: Habilitar el cifrado en el bucket S3 (SSE).
- **Logs de acceso**: Habilitar CloudTrail para auditoría.
- **Permisos IAM**: Otorgar permisos mínimos de S3 (ya no se necesitan permisos de DynamoDB).

### Problemas Comunes
- **Error de Bloqueo**: Si el proceso falla, el bloqueo puede persistir. Elíminalo manualmente en S3 o usa: terraform force-unlock <lock-id>.
- **Versionado no habilitado**: El versionado de S3 es OBLIGATORIO para el bloqueo nativo.
- **Versión de Terraform**: Requiere Terraform 1.10+ para bloqueo nativo; se recomienda 1.11+ para mayor estabilidad.