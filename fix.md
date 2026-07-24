# Informe de Inspección de Código Fuente — Punto de Venta (JavaFX + PostgreSQL)

**Proyecto:** Aplicacion1JavaFX
**Fecha:** julio 2026

## Resumen

Se identificaron **9 fallas intencionalmente introducidas** en el código fuente, distribuidas en 4 archivos, más **1 problema de compatibilidad** en la librería/driver de conexión a PostgreSQL detectado al desplegar contra un servidor remoto. Se agrupan en cuatro categorías: **errores de sintaxis/compilación** (el proyecto no compilaba), **errores de nombres de tabla/columna** (no coincidían con el script `ventas.backup`), **errores de lógica** (condiciones o mensajes invertidos) y **el driver JDBC de PostgreSQL, que no era compatible con conexiones remotas que exigen SSL (`sslmode`)** — ver sección 8.

Se validaron los nombres reales de tablas y columnas contra el script `ventas.backup` (pg_dump), confirmando: `categoria`, `marca`, `producto`, `usuarios (idusuarios, nombre, apellido, sexo, correo, usuario, pass)`.

---

## 1. Errores de compilación (impedían generar el .jar)

### 1.1 `ControlesBasicos.java` — identificador no definido
```java
if (pregunta == yes) {   // "yes" no existe en ningún lado
```
**Causa:** variable inexistente en vez de la constante de `JOptionPane`.
**Solución:**
```java
if (pregunta == JOptionPane.YES_OPTION) {
```

### 1.2 `RegistroController.java` — variable con mayúscula incorrecta
```java
cbAddsex.setItems(Options);   // se declaró "options" (minúscula)
```
**Solución:** `cbAddsex.setItems(options);`

### 1.3 `ProductoController.java` — import faltante
`PreparedStatement` se usaba en `addProducto()`, `modificarProducto()` y `eliminarProducto()` pero nunca se importaba.
**Solución:** se agregó `import java.sql.PreparedStatement;`

### 1.4 `ProductoController.java` (método `eliminarProducto`) — variable `n` no declarada
```java
estado.executeUpdate();
if (n > 0) { ... }   // "n" nunca existió
```
**Solución:**
```java
int n = estado.executeUpdate();
if (n > 0) { ... }
```

---

## 2. Errores de nombres de tabla/columna (fallaban en tiempo de ejecución con SQLException)

Comparando contra el backup de la base de datos (`categoria`, `marca`, `producto`, `usuarios`):

| Archivo | Método | Error | Corrección |
|---|---|---|---|
| `ProductoController.java` | `initialize()` | `SELECT ... FROM category` | `FROM categoria` |
| `ProductoController.java` | `addProducto()` | `INSERT INTO product (...)` | `INSERT INTO producto (...)` |
| `RegistroController.java` | `registroUsuario()` | `INSERT INTO usuario (..., email, ...)` | `INSERT INTO usuarios (..., correo, ...)` — la tabla es `usuarios` (plural) y la columna es `correo`, no `email` |

Estas tres consultas producían `org.postgresql.util.PSQLException: relation "X" does not exist` o `column "email" does not exist` al ejecutarse, aunque el proyecto compilara.

---

## 3. Errores lógicos

### 3.1 `ProductoController.java` (`cargarDatosTabla`) — desbordamiento de índice de columna
```java
for(int i = 1 ; i <= rs.getMetaData().getColumnCount()+1; i++){
    row.add(rs.getString(i));  // intenta leer una columna que no existe
}
```
El `+1` hacía que el bucle intentara leer una 6ª columna en un `ResultSet` de solo 5, lanzando `SQLException: The column index is out of range`.
**Solución:** se guardó `totalColumnas = rs.getMetaData().getColumnCount()` y se usó como límite exacto (`i <= totalColumnas`) tanto al crear las columnas de la tabla como al recorrer las filas.

### 3.2 `RegistroController.java` (`registroUsuario`) — condición de éxito invertida
```java
int n = estado.executeUpdate();
if (n > 0) {
    JOptionPane.showMessageDialog(null, "Fallo el registro");  // ¡se mostraba "fallo" cuando SÍ funcionó!
}
```
Además, los campos del formulario se limpiaban **antes** de ejecutar el `INSERT`, por lo que si la inserción fallaba, el usuario perdía los datos igualmente.
**Solución:** se invirtió la condición (mensaje de éxito cuando `n > 0`, de fallo en el `else`) y se movió la limpieza de campos dentro del bloque de éxito.

### 3.3 `Validaciones.java` (`validarCorreo`) — mensaje contradictorio
```java
if (!m.find()) {
    JOptionPane.showMessageDialog(null, "La direccion de correo es correcta"); // dice "correcta" cuando en realidad NO coincide con el patrón
    return false;
}
```
La validación devolvía correctamente `false` (correo inválido), pero el mensaje mostrado al usuario decía lo contrario, causando confusión.
**Solución:** se cambió el texto a `"La direccion de correo es incorrecta"`.

---

## 4. Observaciones adicionales (no corregidas, recomendadas para una siguiente iteración)

- **Inyección SQL:** `LoginController.iniciarSesion()`, `RegistroController` (verificación de usuario existente) y `ProductoController.buscarProducto()` arman las consultas por concatenación de texto en vez de usar `PreparedStatement`. Funciona, pero es vulnerable. Se recomienda migrarlas a consultas parametrizadas como ya se hace en `addProducto`/`modificarProducto`.
- **Credenciales de conexión:** `DBConnection.java` tiene usuario/contraseña de PostgreSQL fijos (`postgres` / `wilpolanco`). Cada integrante debe ajustar estos valores a su ambiente local antes de ejecutar la aplicación.
- **Proyecto NetBeans antiguo:** `nbproject/project.properties` usa `javac.source/target=1.7` y las librerías de JavaFX del JDK 8 (esta versión de JavaFX no viene incluida desde JDK 11 en adelante). Para compilar y ejecutar el proyecto tal cual está armado se necesita **JDK 8** con NetBeans (o agregar el SDK de OpenJFX si se usa un JDK más moderno).

---

## 5. Pasos para poner el proyecto en funcionamiento

1. Restaurar la base de datos: `pg_restore -U postgres -d ventas ventas.backup` (crear la base `ventas` primero si no existe).
2. Ajustar usuario/contraseña en `DBConnection.java` si difieren de los del ambiente local.
3. Abrir el proyecto en NetBeans con **JDK 8** (o configurar JavaFX/OpenJFX si se usa otro JDK).
4. Compilar y ejecutar `ScreensFramework.java` (clase principal).

## 6. Repartición sugerida del trabajo en equipo (5 integrantes)

| Integrante | Responsabilidad |
|---|---|
| 1 | Preparar ambiente: restaurar `ventas.backup`, validar conexión PostgreSQL, documentar credenciales del equipo |
| 2 | Revisar e inspeccionar `DBConnection.java`, `LoginController.java`, `Validaciones.java` |
| 3 | Revisar e inspeccionar `RegistroController.java`, `ControlesBasicos.java` |
| 4 | Revisar e inspeccionar `ProductoController.java` (el archivo más extenso, con más fallas) |
| 5 | Pruebas funcionales de extremo a extremo (login, registro, alta/edición/eliminación/búsqueda de productos) y redacción final del informe grupal |

## 7. Verificación realizada

El proyecto corregido se **compiló exitosamente** con `javac` usando las librerías reales (JavaFX 11, `postgresql-9.1-902.jdbc4.jar` y `commons-codec-1.7.jar` incluidas en `librerias/`), generando las 10 clases sin ningún error (solo advertencias normales por API antigua y tipos "raw", presentes desde el código original). Además se validó que:
- Los 4 archivos `.fxml` son XML válido.
- Cada `onAction`/`onMouseClicked` de los FXML corresponde a un método `@FXML` existente en su controlador.
- Cada `fx:id` de los FXML corresponde a un campo inyectado en su controlador.
- Cada tabla y columna usada en las consultas SQL coincide exactamente con el esquema real de `ventas.backup` (`categoria`, `marca`, `producto`, `usuarios`).

## 8. Actualización: driver JDBC no soportaba `sslmode` (detectado al conectar contra un servidor remoto con SSL obligatorio)

Al conectar la aplicación contra una base de datos PostgreSQL alojada en un proveedor en la nube (Render), que exige SSL obligatorio, apareció:
```
Error org.postgresql.util.PSQLException: FATAL: SSL/TLS required
```
aunque la URL de conexión ya incluía `?sslmode=require`.

**Causa raíz confirmada:** el proyecto trae el driver `postgresql-9.1-902.jdbc4.jar`, publicado en 2012. Al desempaquetar sus clases se confirmó que el parser de la URL de conexión de esa versión solo reconoce las propiedades `ssl`, `sslfactory` y `sslfactoryarg` — **no reconoce el parámetro `sslmode`** (se agregó en versiones bastante posteriores del driver). El driver ignora silenciosamente `sslmode=require` e intenta conectarse sin cifrar, y el servidor remoto rechaza la conexión por no venir cifrada.

**Reproducción y validación:** se levantó un PostgreSQL local configurado para exigir SSL en todas las conexiones (igual que Render). Con el driver de 2012 se reprodujo el error (`no encryption`); con un driver moderno (`postgresql-42.7.13.jar`) la misma URL con `sslmode=require` conectó exitosamente.

**Solución aplicada:**
- Se reemplazó `librerias/postgresql-9.1-902.jdbc4.jar` por `librerias/postgresql-42.7.13.jar` (última versión estable del driver oficial de PostgreSQL, descargada desde el repositorio oficial `pgjdbc/pgjdbc`).
- No fue necesario cambiar ni una línea de `DBConnection.java`: el paquete sigue siendo `org.postgresql.Driver` y la API de `DriverManager`/`Connection` es 100% compatible.
- Se recompiló el proyecto completo con el nuevo driver y no se generó ningún error.

Si tu equipo abre el proyecto en VS Code o NetBeans, asegúrate de que la referencia a librerías apunte al nuevo jar (`librerias/postgresql-42.7.13.jar`) y no al antiguo.

---

Todos deben revisar el `fix.md` final y estar preparados para explicar cualquier corrección durante la sustentación.