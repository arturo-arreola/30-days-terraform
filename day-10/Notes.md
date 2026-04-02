# 📚 Temas Cubiertos
- **Expresiones Condicionales** - Tomar decisiones en tus configuraciones
- **Bloques Dinámicos** - Crear bloques anidados flexibles y reutilizables
- **Expresiones Splat** - Extraer valores de listas de forma eficiente

---

## 🎯 Objetivos de Aprendizaje

Al finalizar esta lección, serás capaz de:
1. Dominar las expresiones condicionales para configuraciones basadas en entorno
2. Usar bloques dinámicos para eliminar la duplicación de código
3. Aplicar expresiones splat para extraer datos de múltiples recursos
4. Entender cuándo usar cada tipo de expresión
5. Combinar múltiples tipos de expresiones para configuraciones potentes
6. Escribir código Terraform más limpio y mantenible

---

## 🔧 Expresiones Explicadas

### 1. Expresiones Condicionales

**¿Qué hacen?**  
Evalúan una condición y retornan uno de dos valores dependiendo de si la condición es verdadera o falsa.

**Sintaxis:**
```hcl
condición ? valor_si_verdadero : valor_si_falso
```

**Cómo funciona:**
- Si `condición` es `true`, retorna `valor_si_verdadero`
- Si `condición` es `false`, retorna `valor_si_falso`
- Similar al operador ternario en otros lenguajes de programación

**Casos de uso:**
- ✅ Elegir tipos de instancia según el entorno (dev vs prod)
- ✅ Habilitar/deshabilitar monitoreo según la configuración
- ✅ Seleccionar diferentes AMIs según la región
- ✅ Definir conteos de recursos distintos por entorno
- ✅ Aplicar etiquetas específicas por entorno

**Ventajas:**
- ✅ Una sola configuración para múltiples entornos
- ✅ Reduce la duplicación de código
- ✅ Hace explícitas las diferencias entre entornos
- ✅ Simplifica la gestión de configuraciones
- ✅ Fácil de entender y mantener

**Cuándo usarlas:**
- ✅ Configuraciones específicas por entorno
- ✅ Feature flags (habilitar/deshabilitar funcionalidades)
- ✅ Creación condicional de recursos
- ✅ Configuraciones específicas por región
- ✅ Optimización de costos (recursos más pequeños en dev)

**Cuándo NO usarlas:**
- ❌ Lógica compleja con muchas condiciones (usa `locals` en su lugar)
- ❌ Cuando archivos de entorno separados son más claros
- ❌ Cuando todos los entornos deben ser idénticos

---

### 2. Bloques Dinámicos

**¿Qué hacen?**  
Generan múltiples bloques anidados dentro de un recurso a partir de una colección (lista o map). Eliminan la necesidad de repetir configuraciones de bloques similares.

**Sintaxis:**
```hcl
dynamic "nombre_bloque" {
    for_each = var.coleccion
    content {
        # Configuración del bloque usando each.key y each.value
    }
}
```

**Cómo funciona:**
- `for_each` itera sobre una lista o map
- `content` define lo que cada bloque debe contener
- Los valores se acceden usando `nombre_bloque.value` o `nombre_bloque.key`

**Casos de uso:**
- ✅ Reglas de ingress/egress en security groups
- ✅ Múltiples volúmenes EBS en instancias EC2
- ✅ Declaraciones de políticas IAM
- ✅ Listeners de load balancers
- ✅ Rutas en tablas de enrutamiento
- ✅ Cualquier estructura de bloque anidado repetitiva

**Ventajas:**
- ✅ Elimina código repetitivo
- ✅ Facilita agregar o eliminar elementos
- ✅ Configuración a través de variables
- ✅ Código más limpio y mantenible
- ✅ Soporta estructuras de datos complejas

**Cuándo usarlos:**
- ✅ Múltiples bloques anidados similares
- ✅ Número variable de configuraciones
- ✅ Reglas de security groups
- ✅ Políticas inline
- ✅ Cualquier patrón de bloque repetitivo

**Cuándo NO usarlos:**
- ❌ Uno o pocos bloques estáticos (la complejidad no lo justifica)
- ❌ Cuando dificultan la legibilidad del código
- ❌ Para recursos de nivel superior (usa `count` o `for_each` en su lugar)

**Buenas Prácticas:**
1. Usa nombres de iterador descriptivos (no solo `item`)
2. Mantén los bloques dinámicos simples
3. Documenta la estructura de datos esperada
4. Valida las variables de entrada
5. Evita anidar bloques dinámicos demasiado profundamente

---

### 3. Expresiones Splat

**¿Qué hacen?**  
Extraen valores de atributos de todos los elementos de una lista en una expresión única y concisa. El operador `[*]` es el operador splat.

**Sintaxis:**
```hcl
lista_de_recursos[*].nombre_atributo
```

**Cómo funciona:**
- Toma una lista de recursos u objetos
- Extrae el atributo especificado de cada elemento
- Retorna una nueva lista con solo esos valores

**Casos de uso:**
- ✅ Obtener todos los IDs de instancias de múltiples instancias EC2
- ✅ Extraer todos los IDs de subnets de una VPC
- ✅ Recopilar todos los IDs de security groups
- ✅ Obtener IPs privadas de una lista de instancias
- ✅ Extraer ARNs para outputs
- ✅ Reunir atributos de recursos para otros recursos

---

## 📚 Recursos Adicionales

- [Expresiones Condicionales en Terraform](https://www.terraform.io/language/expressions/conditionals)
- [Bloques Dinámicos en Terraform](https://www.terraform.io/language/expressions/dynamic-blocks)
- [Expresiones Splat en Terraform](https://www.terraform.io/language/expressions/splat)
- [Expresiones For en Terraform](https://www.terraform.io/language/expressions/for)

---