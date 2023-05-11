###################
### DESCRIPTION ###
###################

# This script defines the user interface of a Shiny App

#################
### LIBRARIES ###
#################

library(shiny)

##########
### UI ###
##########

ui <- fluidPage(
  # ChatbotR id
  id = "chatbox-container",
  
  # Styling
  includeCSS("www/styling.css"),
  includeScript("www/script.js"),
  
  # Chat output
  uiOutput("messages", width = "100%"),
  
  # Chat input
  tags$div(textInput(inputId = "msg_text", label = "", value = "", width = "100%"),
           actionButton(inputId = "msg_button", label = "Send Message", style = "visibility: hidden;width: 0px"))
)


