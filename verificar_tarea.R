#!/usr/bin/env Rscript
# =============================================================================
# VERIFICADOR DE ENTREGA - TAREA DE PROYECTO 1
# SOCI 4186 - Métodos Computacionales en Sociología
# Universidad de Puerto Rico, Recinto de Río Piedras
# =============================================================================
#
# IMPORTANTE: Este script NO califica tu tarea.
# Solo verifica que cumple los requisitos técnicos mínimos para renderizarse.
#
# Uso:
#   En RStudio: Abre este archivo y haz clic en "Source" (o Ctrl+Shift+S)
#   En terminal: Rscript verificar_tarea.R
#
# =============================================================================

# --- Configuración -----------------------------------------------------------

ARCHIVO_QMD <- "tarea_proyecto_01.qmd"
ARCHIVO_BIB <- "Referencias.bib"
ARCHIVOS_SOPORTE <- c("apa-clacso.csl", "uprrp-theme.css")

# Textos que indican que la plantilla no fue editada
PLACEHOLDERS <- c(
  "Pon tu nombre aquí",
  "Su número de estudiante"
)

# --- Funciones auxiliares ----------------------------------------------------

msg <- function(texto, tipo = "info") {
  simbolo <- switch(tipo,
    ok    = "\u2714",
    error = "\u2718",
    warn  = "\u26A0",
    info  = "\u2139",
    "\u2022"
  )
  prefijo <- switch(tipo,
    ok    = "[OK]   ",
    error = "[ERROR]",
    warn  = "[AVISO]",
    info  = "[INFO] ",
    "       "
  )
  cat(sprintf("%s %s %s\n", simbolo, prefijo, texto))
}

leer_yaml <- function(archivo) {
  lineas <- tryCatch(
    readLines(archivo, warn = FALSE, encoding = "UTF-8"),
    error = function(e) NULL
  )
  if (is.null(lineas)) return(NULL)

  indices_yaml <- which(lineas == "---")
  if (length(indices_yaml) < 2) return(NULL)

  yaml_texto <- paste(lineas[(indices_yaml[1] + 1):(indices_yaml[2] - 1)],
                      collapse = "\n")
  tryCatch(yaml::yaml.load(yaml_texto), error = function(e) NULL)
}

# --- Verificaciones ----------------------------------------------------------

cat("\n")
cat("===========================================================================\n")
cat("   VERIFICADOR DE ENTREGA - TAREA DE PROYECTO 1\n")
cat("===========================================================================\n")
cat("\n")
cat("   NOTA: Este script NO califica tu tarea.\n")
cat("   Solo verifica que pueda renderizarse correctamente.\n")
cat("   La evaluación del contenido la realiza el profesor.\n")
cat("\n")
cat("---------------------------------------------------------------------------\n")
cat("\n")

errores <- 0
avisos <- 0

# --- 1. Verificar directorio de trabajo ---
cat("1. Verificando directorio de trabajo...\n\n")

if (!file.exists(ARCHIVO_QMD)) {
  msg(sprintf("No se encuentra '%s' en el directorio actual", ARCHIVO_QMD), "error")
  msg(sprintf("Directorio actual: %s", getwd()), "info")
  msg("Asegúrate de abrir el proyecto en RStudio o cambiar al directorio correcto.", "info")
  cat("\n")
  stop("Verificación abortada: archivo principal no encontrado.")
}
msg(sprintf("Archivo principal '%s' encontrado", ARCHIVO_QMD), "ok")

# --- 2. Verificar archivos de soporte ---
cat("\n2. Verificando archivos de soporte...\n\n")

for (archivo in ARCHIVOS_SOPORTE) {
  if (!file.exists(archivo)) {
    msg(sprintf("Falta '%s' - no borres los archivos originales", archivo), "error")
    errores <- errores + 1
  } else {
    msg(sprintf("'%s' presente", archivo), "ok")
  }
}

if (!file.exists(ARCHIVO_BIB)) {
  msg(sprintf("Falta '%s'", ARCHIVO_BIB), "error")
  errores <- errores + 1
} else {
  msg(sprintf("'%s' presente", ARCHIVO_BIB), "ok")
}

# --- 3. Verificar que la plantilla fue editada ---
cat("\n3. Verificando que editaste la plantilla...\n\n")

yaml_data <- leer_yaml(ARCHIVO_QMD)

if (is.null(yaml_data)) {
  msg("No se pudo leer el encabezado YAML", "error")
  msg("Verifica que el documento comience con '---'", "info")
  errores <- errores + 1
} else {
  # Verificar campo author
  if (is.null(yaml_data$author) || yaml_data$author == "") {
    msg("El campo 'author' está vacío", "error")
    errores <- errores + 1
  } else if (any(sapply(PLACEHOLDERS, function(p) grepl(p, yaml_data$author)))) {
    msg("No has cambiado tu nombre en el campo 'author'", "error")
    msg("Edita la línea 4 del documento con tu nombre real", "info")
    errores <- errores + 1
  } else {
    autor_limpio <- gsub("\\s+", " ", gsub("\\\\n", " ", yaml_data$author))
    msg(sprintf("Autor: %s", autor_limpio), "ok")
  }
}

# --- 4. Verificar declaración de MEL ---
cat("\n4. Verificando declaración de MEL...\n\n")

contenido <- tryCatch(
  paste(readLines(ARCHIVO_QMD, warn = FALSE, encoding = "UTF-8"), collapse = "\n"),
  error = function(e) ""
)

if (grepl("Su declaración aquí", contenido)) {
  msg("No ha completado la declaración de uso de MEL/LLM", "warn")
  msg("Recuerde indicar si usó herramientas de IA", "info")
  avisos <- avisos + 1
} else {
  msg("Sección de declaración de MEL presente", "ok")
}

# --- 5. Verificar renderizado ---
cat("\n5. Verificando que el documento renderiza...\n\n")

msg("Intentando renderizar (esto puede tomar unos segundos)...", "info")
cat("\n")

quarto_disponible <- tryCatch({
  resultado <- system("quarto --version", intern = TRUE, ignore.stderr = TRUE)
  length(resultado) > 0 && nchar(resultado[1]) > 0
}, error = function(e) FALSE)

if (!quarto_disponible) {
  msg("Quarto no está instalado o no está en el PATH", "error")
  msg("Instala Quarto desde https://quarto.org/docs/get-started/", "info")
  errores <- errores + 1
} else {
  render_result <- tryCatch({
    # Renderizar solo HTML (más rápido)
    system2("quarto",
            args = c("render", ARCHIVO_QMD, "--to", "html"),
            stdout = TRUE, stderr = TRUE)
  }, error = function(e) {
    c("ERROR:", e$message)
  })

  html_file <- sub("\\.qmd$", ".html", ARCHIVO_QMD)

  if (file.exists(html_file)) {
    msg("Documento renderizado exitosamente", "ok")
  } else {
    msg("El documento no se pudo renderizar", "error")
    msg("Revisa los errores de Quarto mostrados arriba", "info")
    errores <- errores + 1

    # Mostrar errores relevantes
    errores_quarto <- grep("error|Error|ERROR", render_result, value = TRUE)
    if (length(errores_quarto) > 0) {
      cat("\n   Errores detectados:\n")
      for (err in head(errores_quarto, 5)) {
        cat(sprintf("   > %s\n", err))
      }
    }
  }
}

# --- Resumen final -----------------------------------------------------------

cat("\n")
cat("===========================================================================\n")
cat("   RESUMEN\n")
cat("===========================================================================\n")
cat("\n")

if (errores == 0 && avisos == 0) {
  cat("\u2705 Tu tarea cumple los requisitos técnicos para ser entregada.\n")
  cat("\n")
  cat("   Recuerda:\n")
  cat("   - Esta verificación NO es una calificación\n")
  cat("   - El profesor evaluará el contenido académico\n")
  cat("   - Sube tu .qmd y .html a GitHub\n")
  cat("\n")
} else if (errores == 0) {
  cat(sprintf("\u26A0\uFE0F  Tu tarea tiene %d aviso(s) pero puede entregarse.\n", avisos))
  cat("\n")
  cat("   Los avisos son recomendaciones, no bloquean la entrega.\n")
  cat("   Considera atenderlos antes de entregar.\n")
  cat("\n")
} else {
  cat(sprintf("\u274C Tu tarea tiene %d error(es) técnico(s).\n", errores))
  cat("\n")
  cat("   DEBES corregir los errores antes de entregar.\n")
  cat("   Los errores indican que el documento no puede procesarse.\n")
  cat("   Revisa los mensajes [ERROR] arriba.\n")
  cat("\n")
}

cat("===========================================================================\n")
cat("\n")

# Código de salida para integración con CI
if (errores > 0) {
  quit(status = 1, save = "no")
}
