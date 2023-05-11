###################
### DESCRIPTION ###
###################

# This script defines the server side of a Shiny App

#################
### LIBRARIES ###
#################

library(dplyr)
library(DBI)
library(RSQLite)
library(shiny)

################
### USERNAME ###
################

# Name of chat user
username = "Ebbemonster"

###########################
### DATABASE CONNECTION ###
###########################

# Setting sqlite working directory
setwd("/home/arigato/code/chatbotR/")

# Connecting to SQLite-database
con <- DBI::dbConnect(RSQLite::SQLite(), "Data/chatbot.sqlite")

#########################
### MESSAGE FUNCTIONS ###
#########################

# Reads all messages in database
read_messages <- function(con){
  DBI::dbReadTable(con, name = "messages")
}

#################
### CHAT HTML ###
#################

# Renders chat
render_msg <- function(messages, username) {
  div(id = "chat-container",
      class = "chat-container",
      messages %>%
        purrrlyr::by_row(~ div(class =  dplyr::if_else(
          .$username == username,
          "chat-message-left", "chat-message-right"),
          a(class = "username", .$username),
          div(class = "message", .$message),
          div(class = "datetime", .$datetime)
        ))
      %>% {.$.out}
  )
}

####################
### SERVER LOGIC ###
####################

function(input, output) {
  # Action on button press
  update_message_table <- eventReactive(input$msg_button, valueExpr = {
    # Reacts if text
    if (!(input$msg_text == "" | is.null(input$msg_text))) {

      # Time when submitting message
      msg_time <- format(Sys.time(), usetz = TRUE) %>%
        as.character()
      
      # Creating message
      new_message <- dplyr::tibble(username = username,
                                   message = input$msg_text,
                                   datetime = msg_time)
      
      # Writing message to database
      RSQLite::dbAppendTable(con, "messages", new_message)
      
      # Clearing the message text
      shiny::updateTextInput(inputId = "msg_text",
                             value = "")
    }
    
    # Returns full message history
    read_messages(con)
  })
  
  # Creates output
  output$messages <- shiny::renderUI({
      render_msg(update_message_table(), username)
  })
}
