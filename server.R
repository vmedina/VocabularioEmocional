library(shiny)
library(tidyverse)
library(tidytext)
library(DT)
library(ggwordcloud)

server <- function(input, output, session) {
  diccionario <- read.csv("DAVE.csv", encoding = "UTF-8")
  
  filtered_diccionario <- reactive({
    if (input$input_words2 != "") {
      words_to_filter <- tibble(word = unlist(str_split(input$input_words2, "\\s+")))
      diccionario %>% anti_join(words_to_filter, by = "word")
    } else {
      diccionario
    }
  })
  
  selected_text <- reactive({
    if (input$input_words != "") {
      input$input_words
    } else {
      ""
    }
  })
  
  processed_data1 <- reactive({
    req(selected_text() != "")
    tibble(word = unlist(str_split(selected_text(), "\\s+"))) %>%
      filter(word != "") %>%
      unnest_tokens(word, word, to_lower = TRUE) %>%
      inner_join(filtered_diccionario(), by = "word") %>%
      count(lema, Polaridad, sort = TRUE) %>%
      mutate(Porcentaje = round(n / sum(n) * 100, 2))
  })
  
  processed_data12 <- reactive({
    req(selected_text() != "")
    tibble(word = unlist(str_split(selected_text(), "\\s+"))) %>%
      filter(word != "") %>%
      unnest_tokens(word, word, to_lower = TRUE) %>%
      inner_join(filtered_diccionario(), by = "word") %>%
      count(word, Polaridad, sort = TRUE) %>%
      mutate(Porcentaje = round(n / sum(n) * 100, 2))
  })
  
  processed_data2 <- reactive({
    req(selected_text() != "")
    tibble(word = unlist(str_split(selected_text(), "\\s+"))) %>%
      filter(word != "") %>%
      unnest_tokens(word, word, to_lower = TRUE) %>%
      inner_join(filtered_diccionario(), by = "word") %>%
      count(Polaridad, sort = TRUE) %>%
      mutate(Porcentaje = round(n / sum(n) * 100, 2))
  })
  
  processed_data3 <- reactive({
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
}