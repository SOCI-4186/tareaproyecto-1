# Guía de Configuración Inicial

Esta guía les ayudará a configurar su entorno de trabajo para SOCI 4186. Sigan los pasos en orden.

## Paso 1: Instalar R

R es el lenguaje de programación que usaremos para análisis estadístico.

### Windows
1. Visiten [https://cran.r-project.org/bin/windows/base/](https://cran.r-project.org/bin/windows/base/)
2. Descarguen "Download R-4.x.x for Windows"
3. Ejecuten el instalador y sigan las instrucciones (opciones por defecto están bien)

### macOS
1. Visiten [https://cran.r-project.org/bin/macosx/](https://cran.r-project.org/bin/macosx/)
2. Descarguen el archivo `.pkg` apropiado para su versión de macOS
3. Abran el archivo y sigan las instrucciones

### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install r-base r-base-dev
```

## Paso 2: Instalar RStudio

RStudio es el entorno de desarrollo integrado (IDE) que facilita trabajar con R.

1. Visiten [https://posit.co/download/rstudio-desktop/](https://posit.co/download/rstudio-desktop/)
2. Descarguen la versión para su sistema operativo
3. Instalen el programa (RStudio detectará automáticamente su instalación de R)

## Paso 3: Verificar que Quarto está instalado

Las versiones recientes de RStudio incluyen Quarto. Para verificar:

1. Abran RStudio
2. En la Terminal (no la Consola), escriban:
   ```bash
   quarto --version
   ```
3. Si no está instalado, descárguenlo de [https://quarto.org/docs/get-started/](https://quarto.org/docs/get-started/)

## Paso 4: Instalar TinyTeX (para generar PDFs)

Abran RStudio y ejecuten estos comandos en la **Consola** (panel inferior izquierdo):

```r
# Instalar el paquete tinytex
install.packages("tinytex")

# Instalar TinyTeX (esto puede tomar varios minutos)
tinytex::install_tinytex()
```

**Nota**: Después de instalar TinyTeX, cierren y vuelvan a abrir RStudio.

## Paso 5: Verificar la configuración de caracteres

Para que los acentos y caracteres especiales funcionen correctamente:

1. En RStudio, vayan a: **Tools → Global Options → Code → Saving**
2. Verifiquen que "Default text encoding" esté configurado en **UTF-8**
3. Si no lo está, cámbienlo y hagan clic en OK

## Paso 6: Instalar paquetes útiles

Ejecuten estos comandos en la Consola de RStudio:

```r
# Paquetes para manejo de datos
install.packages(c("tidyverse", "psych", "data.table"))

# Paquetes para crear documentos
install.packages(c("rmarkdown", "knitr"))

# Paquete para tablas bonitas
install.packages("kableExtra")
```

## Paso 7: Probar su configuración

Pueden verificar que todo funciona con estos comandos en la Consola de RStudio:

```r
# Verificar versión de R
R.version.string

# Verificar que los paquetes se instalaron
library(tidyverse)
library(knitr)

# Verificar Quarto (en Terminal, no Consola)
# quarto --version
```

Si no hay errores, ¡están listos!

## Estructura de RStudio

Cuando abran RStudio por vez primera, verán 4 paneles principales:

```
┌─────────────────┬─────────────────┐
│                 │                 │
│   Editor        │   Entorno       │
│   (Scripts)     │   (Variables)   │
│                 │                 │
├─────────────────┼─────────────────┤
│                 │                 │
│   Consola       │   Archivos      │
│   (Comandos R)  │   (Navegador)   │
│                 │                 │
└─────────────────┴─────────────────┘
```

- **Editor** (arriba izquierda): Donde escribirán sus documentos Quarto y scripts R
- **Consola** (abajo izquierda): Donde R ejecuta comandos
- **Entorno** (arriba derecha): Muestra variables y objetos en memoria
- **Archivos** (abajo derecha): Navegador de archivos, gráficos, ayuda, etc.

## Configuración de GitHub + RStudio (Opcional por ahora)

Si desean configurar GitHub ahora (lo haremos juntos en clase más adelante):

1. Creen una cuenta en [https://github.com](https://github.com) (ya lo deben haber hecho)
2. Instalen Git:
   - **Windows**: [https://git-scm.com/download/win](https://git-scm.com/download/win)
   - **macOS**: Ya viene instalado, o pueden instalar vía Homebrew: `brew install git`
   - **Linux**: `sudo apt install git` (en general no usen si no conocen bien lo que es `sudo`)
3. En RStudio, vayan a **Tools → Global Options → Git/SVN**
4. Verifiquen que RStudio puede encontrar Git

### Configurar Git (primer uso)

En la Terminal de RStudio:

```bash
git config --global user.name "Su Nombre"
git config --global user.email "su.email@ejemplo.com"
```

## Atajos de teclado útiles en RStudio

| Acción                          | Windows/Linux      | macOS              |
|:--------------------------------|:-------------------|:-------------------|
| Ejecutar línea/selección        | Ctrl+Enter         | Cmd+Enter          |
| Ejecutar todo el script         | Ctrl+Shift+Enter   | Cmd+Shift+Enter    |
| Renderizar documento Quarto     | Ctrl+Shift+K       | Cmd+Shift+K        |
| Nuevo archivo                   | Ctrl+Shift+N       | Cmd+Shift+N        |
| Guardar archivo                 | Ctrl+S             | Cmd+S              |
| Buscar/reemplazar               | Ctrl+F             | Cmd+F              |
| Comentar/descomentar líneas     | Ctrl+Shift+C       | Cmd+Shift+C        |
| Insertar chunk de R (en Quarto) | Ctrl+Alt+I         | Cmd+Option+I       |

## Solución de problemas

### No puedo generar PDFs

**Error**: "LaTeX not found"
**Solución**: Instalen TinyTeX siguiendo el Paso 4

### Los acentos no se ven bien

**Problema**: Los acentos aparecen como símbolos extraños
**Solución**: Verifiquen la configuración UTF-8 (Paso 5)

### RStudio no encuentra R

**Problema**: RStudio muestra error al iniciar
**Solución**: 
1. Desinstalen RStudio
2. Verifiquen que R esté instalado
3. Reinstalen RStudio

### Paquetes no se instalan

**Error**: "installation of package 'X' had non-zero exit status"
**Solución Windows**: Instalen Rtools desde [https://cran.r-project.org/bin/windows/Rtools/](https://cran.r-project.org/bin/windows/Rtools/)
**Solución macOS**: Instalen Xcode Command Line Tools: `xcode-select --install`
**Solución Linux**: Instalen herramientas de desarrollo: `sudo apt install build-essential`

## Recursos adicionales

### Tutoriales en español
- [Introducción a R](https://cran.r-project.org/doc/contrib/rdebuts_es.pdf)
- [R para principiantes](https://bookdown.org/jboscomendoza/r-principiantes4/)
- [Ciencia de Datos con R](https://es.r4ds.hadley.nz/)

### Tutoriales en inglés
- [RStudio Education](https://education.rstudio.com/)
- [Quarto Guide](https://quarto.org/docs/guide/)
- [R for Data Science](https://r4ds.had.co.nz/)

### Comunidades de ayuda
- [RStudio Community](https://community.rstudio.com/)
- [Stack Overflow (etiqueta R)](https://stackoverflow.com/questions/tagged/r)
- Canal de Discord/Slack de la clase (si aplica)

## Lista de verificación final

Antes de la primera clase de laboratorio, asegúrense de tener:

- [ ] R instalado y funcionando
- [ ] RStudio instalado y funcionando
- [ ] Quarto disponible (verificado con `quarto --version`)
- [ ] TinyTeX instalado (para PDFs)
- [ ] Configuración UTF-8 establecida
- [ ] Paquetes básicos instalados (tidyverse, rmarkdown, knitr)
- [ ] Script de verificación ejecutado exitosamente

## ¿Necesitan ayuda?

Si encuentran problemas durante la configuración:

1. **Primero**: Revisen la sección de Solución de problemas arriba
2. **Segundo**: Busquen el mensaje de error en Google (probablemente no son les primeres en tener ese problema)
3. **Tercero**: Envíen un correo al profesor con:
   - Descripción del problema
   - Mensaje de error completo (si aplica)
   - Su sistema operativo y versiones de R/RStudio
   - Capturas de pantalla si es relevante

¡No se preocupen si esto parece mucho! Lo haremos paso a paso en clase. Esta guía es para que tengan referencia.

---

**¿Listes para empezar?** Una vez tengan todo configurado, descarguen la Tarea 1 del repositorio de GitHub Classroom y ¡empiecen a trabajar!
