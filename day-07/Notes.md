# Día 7: Restricciones de Tipos en Terraform

## Temas Cubiertos
- Tipos string, number y bool
- Tipos map, set, list, tuple y object
- Validación y restricciones de tipos
- Definiciones de tipos complejos

## Puntos Clave de Aprendizaje

### Tipos Básicos
1. **string** - Valores de texto
2. **number** - Valores numéricos (enteros y decimales)
3. **bool** - Valores booleanos (true/false)

### Tipos de Colección
1. **list(tipo)** - Colección ordenada de valores
2. **set(tipo)** - Colección desordenada de valores únicos
3. **map(tipo)** - Pares clave-valor con claves de tipo string
4. **tuple([tipo1, tipo2, ...])** - Colección ordenada con tipos específicos para cada elemento
5. **object({clave1=tipo1, clave2=tipo2, ...})** - Datos estructurados con atributos nombrados

### Patrones de Tipos Comunes

1. **Configuraciones específicas por entorno**
2. **Dimensionamiento de recursos según su tipo**
3. **Estandarización de etiquetas**
4. **Validación de configuración de red**
5. **Aplicación de políticas de seguridad**

## Buenas Prácticas

1. **Especifica siempre los tipos** en las variables
2. **Usa bloques de validación** para reglas de negocio
3. **Proporciona mensajes de error descriptivos**
4. **Usa el tipo de colección adecuado** (list vs set vs map)
5. **Valida objetos complejos** de forma exhaustiva
6. **Usa funciones de conversión de tipos** cuando sea necesario
7. **Documenta los requisitos de tipo** en las descripciones
