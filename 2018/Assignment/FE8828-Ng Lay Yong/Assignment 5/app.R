library(shiny)
ui<-fluidPage(
  numericInput("shock","Shock",value=round(runif(1)*1000),0),
  actionButton("add","Add"),
  numericInput("removeinput","Remove scenario",value=0),
  actionButton("remove","Remove"),
  checkboxGroupInput("scenarios","Scenarios",choices=c(),selected=c()),
  verbatimTextOutput("o1")
)
scenarios<-c(-100,-50,0,50,100)
server<-function(input,output,session){
  updateCheckboxGroupInput(session,"scenarios",
                           choices=scenarios,
                           selected=scenarios)
  observeEvent(input$add,{
    shock<-isolate(input$shock)
    if(!(shock%in%scenarios)){
      scenarios<<-sort(c(scenarios,shock))
      updateCheckboxGroupInput(session,"scenarios",
                               choices=scenarios,
                               selected=scenarios)
    }
    #putanewrandomvalue
    updateNumericInput(session,"shock",value=round(runif(1)*1000))
  })
  observeEvent(input$remove,{
    removeinput<-isolate(input$removeinput)
    if(!(removeinput%in%scenarios)){
      showModal(modalDialog(
        title = "Input not found in existing list of scenarios. Please input a value from existing scenarios",
        easyClose = TRUE,
        footer=NULL
      ))
    }
    #removevalue
    scenarios<<-scenarios[scenarios != removeinput]
    updateCheckboxGroupInput(session,"scenarios",
                             choices=scenarios,
                             selected=scenarios)
  })
  
  output$o1<-renderPrint({
    x<-input$scenarios
    str(x)
    cat(paste0("length:",length(x),"\n"))
    cat(paste0(x,"\n"))
  })
 }
shinyApp(ui,server)