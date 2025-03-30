# Closers Steam Browser

![ClosersSteamBrowser Imagen](https://i.imgur.com/7nvAQEe.png)

## Ejecuta Closers con Steam y el Navegador en una sola instalación

Si eres de los que gusta instalar *Closers Online* tanto en el navegador como en Steam, o simplemente quieres usarlo de ambas formas sin necesidad de tener dos instalaciones, ¡tenemos la solución para ti!

Este programa te permitirá crear un acceso directo especial que emula una carpeta real, lo que te permitirá acceder a *Closers* desde el navegador o Steam de manera indistinta. Además, si tienes instalado *Closers* en una ruta personalizada, podrás ejecutar el programa desde la carpeta de instalación y listo.

El script está programado en lenguaje Batch y su uso es muy sencillo. Solo tienes que ejecutarlo en la carpeta donde instalaste *Closers* y el programa hará el resto.

### Características Técnicas
- **Detección de Rutas**: Busca la instalación de *Closers* en Steam, discos locales, externos (excluyendo unidades de red como Z, X, W, Y) y el registro de Windows.
- **Enlaces Simbólicos**: Crea enlaces simbólicos entre la carpeta de Steam y la instalación de *Closers* para sincronizar ambas plataformas.
- **Configuración del Registro**: Modifica el registro para asociar el protocolo `naddiclauncherna`, permitiendo abrir *Closers* desde el navegador.
- **Copias de Seguridad**: Respaldará archivos clave antes de realizar cambios, protegiendo los datos del usuario.

### Instrucciones de Uso
1. Descarga el archivo ZIP desde [este enlace](https://github.com/Henrykun/ClosersSteamBrowser/archive/master.zip).
2. Extrae el contenido en la carpeta donde tienes instalado *Closers*.
3. Ejecuta el script como administrador (haz clic derecho y selecciona "Ejecutar como administrador").
4. Sigue las instrucciones en pantalla para confirmar y seleccionar rutas si es necesario.

### Advertencias
Es importante tener en cuenta que el programa crea un acceso directo especial, por lo que es necesario evitar tener carpetas duplicadas de *Closers*. Si utilizas rutas personalizadas de instalación de Steam o *Closers* instalado desde un disco duro externo, el programa también funciona siempre y cuando no existan carpetas duplicadas.

Si antes usabas *Closers* en el navegador y ahora quieres usarlo desde Steam, simplemente instala Steam, ábrelo sin instalar *Closers*, ciérralo, ejecuta el script y al volver a abrir Steam tendrás a *Closers* en tu biblioteca de Steam de manera mágica.

### Requisitos
- Tener Steam instalado en el sistema.
- Permisos de administrador para ejecutar el script.
- Windows con soporte para enlaces simbólicos (`mklink`).

### Descarga
[Descargar ClosersSteamBrowser.zip](https://github.com/Henrykun/ClosersSteamBrowser/archive/master.zip)

### Agradecimientos
A los amigos de Discord que me motivaron a programarlo, para facilitar las tareas mencionadas anteriormente.

### Historial de Cambios
- Ver sección de abajo para detalles.
