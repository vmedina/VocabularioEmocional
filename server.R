# Carga de librerías necesarias para el procesamiento
library(shiny)
library(tidyverse)
library(tidytext)
library(DT)
library(ggwordcloud)

# Logica necesaria para la aplicación

server <- function(input, output, session) {
  
  # Carga del diccionario emocional DAVE
  diccionario <- read.csv("DAVE.csv", encoding = "UTF-8")
  
  # Aplica filtro de palabras si el usuario indicó alguna a eliminar
  filtered_diccionario <- eventReactive(input$analizar, {
    if (input$input_words2 != "") {
      words_to_filter <- tibble(word = unlist(str_split(input$input_words2, "\\s+")))
      diccionario %>% anti_join(words_to_filter, by = "word")
    } else {
      diccionario
    }
  })
  # Selecciona texto desde archivo o entrada manual
  selected_text <- eventReactive(input$analizar, {
    if (!is.null(input$archivo_txt)) {
      paste(readLines(input$archivo_txt$datapath, encoding = "UTF-8"), collapse = " ")
    } else if (input$input_words != "") {
      input$input_words
    } else {
      ""
    }
  })
  # Procesamiento principal: cuenta lemas por polaridad
  processed_data1 <- eventReactive(input$analizar, {
    req(selected_text() != "")
    tibble(word = unlist(str_split(selected_text(), "\\s+"))) %>%
      filter(word != "") %>%
      unnest_tokens(word, word, to_lower = TRUE) %>%
      inner_join(filtered_diccionario(), by = "word") %>%
      count(lema, Polaridad, sort = TRUE) %>%
      mutate(Porcentaje = round(n / sum(n) * 100, 2))
  })
  # Cuenta palabras exactas por polaridad
  processed_data12 <- eventReactive(input$analizar, {
    req(selected_text() != "")
    tibble(word = unlist(str_split(selected_text(), "\\s+"))) %>%
      filter(word != "") %>%
      unnest_tokens(word, word, to_lower = TRUE) %>%
      inner_join(filtered_diccionario(), by = "word") %>%
      count(word, Polaridad, sort = TRUE) %>%
      mutate(Porcentaje = round(n / sum(n) * 100, 2))
  })
  # Cuenta proporción por polaridad (positivo, negativo, etc.)
  processed_data2 <- eventReactive(input$analizar, {
    req(selected_text() != "")
    tibble(word = unlist(str_split(selected_text(), "\\s+"))) %>%
      filter(word != "") %>%
      unnest_tokens(word, word, to_lower = TRUE) %>%
      inner_join(filtered_diccionario(), by = "word") %>%
      count(Polaridad, sort = TRUE) %>%
      mutate(Porcentaje = round(n / sum(n) * 100, 2))
  })
  # Calcula estadísticas de valencia y arousal
  processed_data3 <- eventReactive(input$analizar, {
    req(selected_text() != "")
    words <- tibble(word = unlist(str_split(selected_text(), "\\s+"))) %>%
      filter(word != "") %>%
      unnest_tokens(word, word, to_lower = TRUE) %>%
      inner_join(filtered_diccionario(), by = "word")
    
    tibble(
      variable = c("Valencia", "Arousal"),
      media = c(round(mean(words$valencia), 3), round(mean(words$arousal), 3)),
      desv_estandar = c(round(sd(words$valencia), 3), round(sd(words$arousal), 3)),
      mediana = c(round(median(words$valencia), 3), round(median(words$arousal), 3))
    )
  })
  # Nube de palabras por lema y polaridad
  output$emotion_plot <- renderPlot({
    req(processed_data1())
    data <- processed_data1() %>%
      head(50) %>%
      mutate(Polaridad = factor(Polaridad))
    
    ggplot(data, aes(label = lema, size = n, color = Polaridad)) +
      geom_text_wordcloud(area_corr = TRUE) +
      scale_size_area(max_size = 30) +
      theme_classic() +
      scale_color_manual(values = c("#BD1C1C", "#6F1FA4", "#1D1294"))
  })
  
  output$word_freq_table1 <- renderDataTable({
    req(processed_data12())
    datatable(processed_data12(), options = list(pageLength = 5))
  })
  
  output$word_freq_table12 <- renderDataTable({
    req(processed_data1())
    datatable(processed_data1(), options = list(pageLength = 5))
  })
  
  output$emotion_plot2 <- renderPlot({
    req(processed_data2())
    ggplot(processed_data2(), aes(Polaridad, Porcentaje, fill = Polaridad)) +
      geom_col() +
      coord_flip() +
      theme_classic() +
      labs(title = "Proporción de palabras por polaridad") +
      scale_fill_manual(values = c("#BD1C1C", "#6F1FA4", "#1D1294"))
  })
  
  output$word_freq_table2 <- renderDataTable({
    req(processed_data2())
    datatable(processed_data2(), options = list(pageLength = 3, dom = 't'))
  })
  
  output$emotion_plot3 <- renderPlot({
    req(processed_data3())
    ggplot(processed_data3(), aes(variable, media, fill = variable)) +
      geom_col() +
      coord_flip() +
      theme_classic() +
      labs(title = "Valencia y Arousal medio") +
      scale_fill_manual(values = c("#4D4D4D", "#666666"))
  })
  
  output$word_freq_table3 <- renderDataTable({
    req(processed_data3())
    datatable(processed_data3(), options = list(pageLength = 2, dom = 't'))
  })
  # Descarga PDF del gráfico de palabras
  output$descargar_emotion_plot <- downloadHandler(
    filename = function() {
      paste0("frecuencia_emocional_", Sys.Date(), ".pdf")
    },
    content = function(file) {
      data <- processed_data1() %>%
        head(50) %>%
        mutate(Polaridad = factor(Polaridad))
      grafico <- ggplot(data, aes(label = lema, size = n, color = Polaridad)) +
        geom_text_wordcloud(area_corr = TRUE) +
        scale_size_area(max_size = 30) +
        theme_classic() +
        scale_color_manual(values = c("#BD1C1C", "#6F1FA4", "#1D1294"))
      ggsave(file, grafico, device = "pdf", width = 7, height = 5)
    }
  )

  # Descarga CSV de polaridad
  output$descargar_polaridad <- downloadHandler(
    filename = function() {
      paste0("polaridad_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(processed_data2(), file, row.names = FALSE)
    }
  )
  # Descarga CSV de valencia/arousal
  output$descargar_valencia <- downloadHandler(
    filename = function() {
      paste0("valencia_arousal_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(processed_data3(), file, row.names = FALSE)
    }
  )
  # Descargar gráficos como PDF
  output$descargar_grafico_polaridad <- downloadHandler(
    filename = function() {
      paste0("grafico_polaridad_", Sys.Date(), ".pdf")
    },
    content = function(file) {
      grafico <- ggplot(processed_data2(), aes(Polaridad, Porcentaje, fill = Polaridad)) +
        geom_col() +
        coord_flip() +
        theme_classic() +
        labs(title = "Proporción de palabras por polaridad") +
        scale_fill_manual(values = c("#BD1C1C", "#6F1FA4", "#1D1294"))
      
      ggsave(file, grafico, device = "pdf", width = 7, height = 5)
    }
  )
}