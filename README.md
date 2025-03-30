# Closers Steam Browser

![ClosersSteamBrowser Imagen](https://i.imgur.com/7nvAQEe.png)

## Ejecuta Closers con Steam y el Navegador en una sola instalación

Si te gusta usar *Closers Online* tanto en el Navegador como en Steam, o simplemente deseas usar ambos sin tener que mantener dos instalaciones separadas, este programa es para ti.

Este script te permite crear un acceso directo especial que simula una carpeta real, permitiéndote acceder a *Closers* desde el Navegador o Steam de manera indistinta. Además, si has instalado *Closers* en una ruta personalizada, el script funcionará directamente desde esa carpeta.

El script está programado en Batch y es sencillo de usar. Solo necesitas ejecutarlo en la carpeta donde tienes instalado *Closers* y seguir las instrucciones en pantalla.

### Características Técnicas
- **Detección de Rutas**: Busca la instalación de *Closers* en Steam, discos locales, externos (excluyendo unidades de red como Z, X, W, Y), y el registro de Windows.
- **Enlaces Simbólicos**: Crea enlaces simbólicos entre la carpeta de Steam y la instalación de *Closers* para sincronizar ambas plataformas.
- **Configuración del Registro**: Modifica el registro para asociar el protocolo `naddiclauncherna`, permitiendo abrir *Closers* desde el Navegador.
- **Copias de Seguridad**: Respaldará archivos clave antes de realizar cambios, protegiéndolos de cualquier alteración accidental.

### Instrucciones de Uso
1. **Descarga el Archivo ZIP**: [Descargar ClosersSteamBrowser.zip](https://github.com/Henrykun/ClosersSteamBrowser/archive/master.zip)
2. **Extrae el Contenido**: Extrae los archivos en la carpeta donde tienes instalado *Closers*.
3. **Ejecuta el Script como Administrador**: Haz click derecho en el script y selecciona "Ejecutar como Administrador".
4. **Sigue las Instrucciones**: Responde a las prompts en pantalla para confirmar y seleccionar rutas si es necesario.

### Advertencias
- Asegúrate de no tener carpetas duplicadas de *Closers*. El script crea un acceso directo especial y puede causar problemas si hay instalaciones múltiples.
- Si usas rutas personalizadas, asegúrate de que el script esté en la carpeta correcta de instalación de *Closers*.
- Para que funcione correctamente con Steam, asegúrate de que Steam esté instalado y configurado en tu sistema.

### Requisitos
- Tener Steam instalado en el sistema.
- Permisos de Administrador para ejecutar el script.
- Windows con soporte para enlaces simbólicos (`mklink`).

### Agradecimientos
A los amigos de Discord por su motivación y ayuda en el desarrollo de este script.

### Historial de Cambios
- **Versión 1.0 (01 de Junio de 2023)**:
  - Lanzamiento inicial del script para configurar *Closers* en Steam y Navegador.
  - Detección básica de rutas y Creación de enlaces simbólicos.

- **Versión 1.1 (02 de Junio de 2023)**:
  - Mejorados los mensajes de error para mayor claridad.
  - Redactados mejor los párrafos de la descripción inicial.

- **Versión 1.2 (04 de Junio de 2023)**:
  - Añadida detección de carpetas vacías para evitar problemas al usuario.
  - Mejorada la redacción de diálogos de detección de errores.

- **Versión 1.3 (07 de Junio de 2023)**:
  - Añadido soporte para instalaciones incompletas.
  - Corregidos comentarios internos para mayor legibilidad.

- **Versión 1.4 (Commit reciente)**:
  - Añadidos archivos via upload, incluyendo el script principal y descripción extendida.
  - Mejorada la integración con GitHub mediante Markdown.
