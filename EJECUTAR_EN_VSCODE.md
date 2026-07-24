# Cómo ejecutar el proyecto en VS Code

Este proyecto fue creado originalmente en NetBeans con Ant. VS Code no entiende ese formato de proyecto directamente, así que hay que configurar 4 cosas: JDK, JavaFX SDK, extensión de Java, y la base de datos.

## 1. Instalar JDK 17 o 21
Descarga desde https://adoptium.net (Temurin) e instálalo. Verifica con:
```
java -version
javac -version
```

## 2. Descargar el SDK de JavaFX (por separado)
Desde JDK 11 en adelante, JavaFX ya no viene incluido con el JDK. Descárgalo desde:
https://gluonhq.com/products/javafx/

Elige la versión **SDK** (no jmods) que coincida con tu sistema operativo (Windows/macOS/Linux) y con la versión de tu JDK (por ejemplo JavaFX 21 si usas JDK 21). Descomprímelo en cualquier carpeta, por ejemplo `C:\javafx-sdk-21.0.4` o `~/javafx-sdk-21.0.4`.

## 3. Instalar la extensión de Java en VS Code
Instala **"Extension Pack for Java"** (de Microsoft) desde el marketplace. Esto instala automáticamente:
- Language Support for Java (Red Hat)
- Debugger for Java
- Test Runner for Java
- Maven/Gradle for Java
- Project Manager for Java

## 4. Abrir el proyecto
Abre en VS Code la carpeta **`Aplicacion1JavaFX`** (no la carpeta raíz `javaFX-PostgreSQL`). Ya incluye:
- `.vscode/settings.json` → le dice a VS Code dónde está el código fuente (`src`) y las librerías (`librerias/*.jar`, que ya trae el driver de PostgreSQL y commons-codec).
- `.vscode/launch.json` → configuración para ejecutar la clase principal `ScreensFramework`.

**Debes editar `.vscode/launch.json`** y reemplazar `RUTA_A_TU_JAVAFX_SDK/lib` por la ruta real donde descomprimiste el SDK de JavaFX en el paso 2, por ejemplo:
```json
"vmArgs": "--module-path \"C:\\javafx-sdk-21.0.4\\lib\" --add-modules javafx.controls,javafx.fxml,javafx.swing"
```

## 5. Preparar PostgreSQL
1. Instala PostgreSQL si no lo tienes.
2. Crea la base de datos: `createdb -U postgres ventas`
3. Restaura el backup: `pg_restore -U postgres -d ventas ventas.backup`
4. Abre `src/screensframework/DBConnect/DBConnection.java` y verifica que el usuario/contraseña coincidan con tu instalación local (por defecto está `postgres` / `wilpolanco`).

## 6. Ejecutar
Con el archivo `ScreensFramework.java` abierto, presiona **F5**, o usa el botón "Run" que aparece sobre el método `main`. También puedes ir al panel "Run and Debug" y elegir la configuración **"Launch ScreensFramework (JavaFX)"**.

## Nota sobre el driver de PostgreSQL
El driver incluido (`postgresql-9.1-902.jdbc4.jar`) es de 2012. Si usas una versión reciente de PostgreSQL (14+) y tienes problemas de conexión, puedes reemplazarlo por un driver moderno (por ejemplo `postgresql-42.7.x.jar`, descargable desde https://jdbc.postgresql.org/download/) colocándolo en la carpeta `librerias/` — el código no necesita cambios, ya que usa JDBC estándar.

## Problemas comunes
| Error | Causa probable |
|---|---|
| `Error: JavaFX runtime components are missing` | Falta el `--module-path`/`--add-modules` en `launch.json`, o la ruta está mal escrita |
| `Connection refused` al conectar a PostgreSQL | El servicio de PostgreSQL no está corriendo, o el puerto/usuario/contraseña en `DBConnection.java` no coinciden |
| `relation "ventas" does not exist` o similar | No se restauró el backup en la base de datos correcta |
