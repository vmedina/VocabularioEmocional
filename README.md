# Vocabulario Emocional - App Shiny

Esta aplicación analiza el **vocabulario emocional** presente en un texto, utilizando un diccionario anotado llamado **DAVE** (Diccionario Anotado de Vocabulario Emocional). Fue desarrollada con **R y Shiny** como parte de una unidad curricular de *Neurociencia y Procesos Socioafectivos*.

---

## ¿Qué hace la app?

- Permite ingresar un texto o subir un archivo `.txt`.
- Analiza las palabras según su **polaridad** (positiva, negativa, neutra).
- Calcula estadísticas de **valencia** (agrado) y **arousal** (intensidad emocional).
- Muestra resultados en tablas y gráficos interactivos.
- Permite **filtrar palabras** (por ejemplo: “amor”, “querer”, etc.).
- Genera **gráficos descargables en PDF** y **tablas en CSV**.

---

## Estructura del proyecto
VocabularioEmocional/
├── ui.R # Interfaz de usuario (frontend)
├── server.R # Lógica del servidor (backend)
├── DAVE.csv # Diccionario emocional (no incluido en Git por .gitignore)
├── README.md # Este archivo

## Requisitos

Antes de ejecutar la app, asegurate de tener instalado R y RStudio.

Instalá los paquetes necesarios con:

```r
install.packages(c("shiny", "tidyverse", "tidytext", "DT", "shinythemes", "ggwordcloud"))

¿Cómo ejecutarla?
Cloná este repositorio.

Asegurate de tener el archivo DAVE.csv en la misma carpeta que ui.R y server.R.

Abrí RStudio y ejecutá:

shiny::runApp()

Cambios realizados (respecto a la versión original commit kickoff-codigoNigerManchini)
- Separación del código en ui.R y server.R para facilitar mantenimiento.

- Se agregó un botón “Analizar texto” para controlar cuándo se ejecuta el análisis.

- Posibilidad de subir archivos .txt con el texto a analizar.

- Mejora visual con el tema flatly de Shiny.

- Botones para descargar resultados:

- CSV: polaridad, valencia y arousal.

- PDF: gráficos de nube de palabras y proporción de polaridad.

Autoría
Esta aplicación fue adaptada y extendida por Verónica Medina, con base en un proyecto de análisis lingüístico y emocional realizaso por Niger Manchini.
Para más información sobre el diccionario DAVE, contactá al docente responsable de la unidad curricular Neurociencia y Proceso Socioafectivos Niger Manchini.