#  Vocabulario Emocional – App Shiny

Esta aplicación analiza el **vocabulario emocional** presente en un texto, utilizando un diccionario anotado llamado **DAVE** (Diccionario Anotado de Vocabulario Emocional).  
Fue desarrollada en **R con Shiny** como parte de la unidad curricular *Neurociencia y Procesos Socioafectivos*.

---

##  ¿Qué hace la app?

- Permite ingresar texto manualmente o subir un archivo `.txt`.
- Analiza palabras según su **polaridad**: positiva, negativa o neutra.
- Calcula estadísticas de **valencia** (agrado) y **arousal** (intensidad emocional).
- Muestra los resultados en **tablas y gráficos interactivos**.
- Permite **filtrar palabras** (por ejemplo: “amor”, “querer”, etc.).
- Ofrece la descarga de resultados como:
  - 📄 **CSV** (polaridad, valencia y arousal)
  - 📊 **PDF** (gráficos de polaridad y nube de palabras)

---

##  Estructura del proyecto

```
VocabularioEmocional/
├── ui.R           # Interfaz de usuario (frontend)
├── server.R       # Lógica del servidor (backend)
├── DAVE.csv       # Diccionario emocional (ignorado por Git)
├── README.md      # Este archivo
```

---

##  Requisitos

Antes de ejecutar la app, asegurate de tener instalado **R y RStudio**.

Instalá los paquetes necesarios desde R:

```r
install.packages(c("shiny", "tidyverse", "tidytext", "DT", "shinythemes", "ggwordcloud"))
```

---

##  ¿Cómo ejecutarla?

1. Cloná este repositorio.
2. Asegurate de que el archivo `DAVE.csv` esté en la misma carpeta que `ui.R` y `server.R`.
3. Abrí RStudio, navegá a la carpeta del proyecto, y ejecutá en la consola:

```r
shiny::runApp()
```

La aplicación se abrirá automáticamente en tu navegador.

---

##  Cambios realizados (respecto al commit original de Niger Manchini)

-  Separación del código en `ui.R` y `server.R` para facilitar el mantenimiento.
-  Se incorporó un botón **“Analizar texto”** para controlar la ejecución del análisis.
-  Se agregó la posibilidad de **subir archivos `.txt`** como alternativa al texto pegado.
-  Se mejoró la apariencia visual con el tema `flatly` de Shiny.
-  Se agregaron botones de descarga para:
  - CSV: resultados de polaridad, valencia y arousal.
  - PDF: nube de palabras y gráfico de polaridad.

---

##  Autoría

Esta aplicación fue adaptada y extendida por **Verónica Medina**, con base en un proyecto de análisis lingüístico y emocional realizado por **Niger Manchini**.

Para más información sobre el diccionario DAVE, contactá al docente responsable de la unidad curricular *Neurociencia y Procesos Socioafectivos*, **Niger Manchini**.
