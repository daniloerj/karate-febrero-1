## API Automation Testing - Taller Karate

Proyecto de ejemplo para automatización de pruebas API usando Karate.

Resumen
- Tests implementados con Karate (features + JS) ejecutados vía Maven.
- Reports generados en `target/karate-reports`.

Estructura principal

- `pom.xml` - build y dependencias Maven.
- `src/test/java/booker/booking/booking.feature` - feature principal de Booking.
- `src/test/java/booker/booking/requests/` - payloads JSON usados en requests (create/update/partial).
- `src/test/java/booker/booking/schemas/` - esquemas JSON externos usados para validaciones (moved from inline).
- `src/test/java/booker/auth/` - autenticación y otros features relacionados.
- `target/karate-reports/` - reportes HTML generados por Karate.

Requisitos

- Java 17 o Java 21 instalado y disponible en `JAVA_HOME`.
- Maven instalado (3.x) o usar el wrapper si lo configuras.
- Conexión a Internet para ejecutar requests contra `restful-booker.herokuapp.com` (usado en los tests de ejemplo).

Cómo ejecutar las pruebas

Ejecutar toda la suite (Maven):

```bash
mvn test
```

Ejecutar un test concreto (ej. `BookerTest`):

```bash
mvn -Dtest=booker.BookerTest test
```

Ejecutar por tags de Karate (ej. solo @smoke y @get-booking-ids):

```bash
mvn test -Dkarate.options="--tags @get-booking-ids,@smoke"
```

Estructura de tests y validaciones

- Las validaciones grandes que antes estaban inline dentro de los `.feature` fueron extraídas a JSON bajo `src/test/java/booker/booking/schemas/`.
- En las features se hace `And match response == read('classpath:booker/booking/schemas/mi-esquema.json')`.
- Mantén la carpeta `schemas` en el classpath para que `read('classpath:...')` funcione; si prefieres, puedes mover los JSON a `src/test/resources/booker/booking/schemas/`.

Agregar/editar un esquema

1. Crear o editar el archivo JSON en `src/test/java/booker/booking/schemas/` (o en `src/test/resources/...` si prefieres).
2. Referenciarlo desde la feature con `read('classpath:booker/booking/schemas/mi-esquema.json')`.

Informes

- Al ejecutar tests, Karate genera reportes HTML en `target/karate-reports/karate-summary.html` y reportes por feature.
- Abre `target/karate-reports/karate-summary.html` en el navegador para ver el resumen.

Buenas prácticas y notas

- Usa patrones de Karate (`#string`, `#number`, `#regex(...)`) en esquemas cuando necesites validaciones flexibles.
- Evita valores literales cuando la API puede retornar valores dinámicos.
- Si mueves `schemas` a `src/test/resources`, recuerda actualizar cualquier IDE/CI para incluir resources en el classpath.

Solución de problemas comunes

- Error `read('classpath:...') not found`: verifica la ruta y que el archivo esté en el classpath. Considera moverlo a `src/test/resources`.
- Tests que dependen de estado en la API remota pueden fallar por datos previos: considera que los tests creen y limpien sus datos o usen ambientes aislados.

Contribuciones

Si deseas mejorar la documentación, agregar más esquemas o parametrizar endpoints, abre un PR con cambios y agrega tests o ejemplos.

Contacto

Autor: Danilo Ramirez (repositorio local)
