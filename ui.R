library(shiny)
library(shinythemes)
library(DT)

ui <- fluidPage(
  theme = shinytheme("sandstone"),
  h1("Vocabulario emocional"),
  br(),
  sidebarLayout(
    sidebarPanel(
      textAreaInput("input_words", "Pegue su texto aquí:", height = "75px"),
      br(),
      textAreaInput("input_words2", "Filtrar palabras (no use puntuación)", height = "75px"),
      h5("Quizás quiera eliminar estas palabras:"),
      h6("quiero quise quería querer querida querido quieres quisieron quiere quiso quisiera"),
      h6("amor amar amada amado amante amaba amé amó amo ama"),
      br()
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Introducción",
                 br(), h1(" "),
                 h4("Esta aplicación analiza el vocabulario emocional explícito utilizando un diccionario anotado de vocabulario emocional.")
        ),
        tabPanel("Vocabulario emocional",
                 h2("Frecuencia del vocabulario emocional"),
                 plotOutput("emotion_plot"),
                 h2("Palabras frecuentes"),
                 dataTableOutput("word_freq_table1"),
                 h2("Familias léxicas frecuentes"),
                 dataTableOutput("word_freq_table12")
        ),
        tabPanel("Polaridad",
                 h2("Proporción de vocabulario emocional negativo/positivo"),
                 plotOutput("emotion_plot2"),
                 h2("Tabla"),
                 dataTableOutput("word_freq_table2")
        ),
        tabPanel("Valencia y Arousal",
                 h2("Valencia y Arousal del texto"),
                 plotOutput("emotion_plot3"),
                 dataTableOutput("word_freq_table3")
        )
      )
    )
  )
)
