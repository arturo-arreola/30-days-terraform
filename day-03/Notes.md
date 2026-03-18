# Día 3 - [Create an AWS S3 Bucket Using Terraform](https://youtu.be/09HQ_R1P7Lw?si=K6i_lLJwmyOH9E-5)

**El bloque resource**: Para crear infraestructura, siempre comienzas con la palabra clave resource, seguida del tipo exacto de recurso en AWS (ej. aws_s3_bucket) y un nombre interno que usarás para referenciarlo solo dentro de tu código.

### Autenticacion en AWS
Antes de crear recursos, debes configurar tus credenciales de AWS para que Terraform pueda autenticarse cuando haga uso de las AWS APIs.

### Métodos de Autenticación
1. **AWS CLI Configuration**: `aws configure`
2. **Environment Variables**: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
3. **IAM Roles**: For EC2 instances or AWS services
4. **AWS Profiles**: Named credential profiles

**Propiedades del recurso**: Para crear un bucket, necesitas definir un nombre (que debe ser único a nivel global en todo AWS) y puedes agregar `tags` o etiquetas para organizarlo.

Los 4 comandos esenciales (El flujo de trabajo):

```bash
# Inicializa tu directorio de trabajo y descarga los plugins del proveedor necesarios.
terraform init

# Hace un simulacro (dry run) y te muestra exactamente qué recursos se van a crear, modificar o destruir, sin hacer cambios reales.
terraform plan

# Ejecuta el plan y crea el bucket en AWS. Puedes agregar la opción -auto-approve para que no te pida confirmación manual.
terraform apply

# Elimina permanentemente de AWS todos los recursos creados por tu código.
terraform destroy
```

**Actualizaciones inteligentes**: Si modificas algo en tu código (por ejemplo, cambias el valor de un tag) y vuelves a ejecutar terraform apply, Terraform es lo suficientemente inteligente para detectar la diferencia y solo actualizar ese detalle en AWS, sin crear un bucket nuevo.
