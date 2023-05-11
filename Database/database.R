###################
### DESCRIPTION ###
###################

# This script sets up a local sqlite-database with a table to store messages.

#################
### LIBRARIES ###
#################

library(dplyr)
library(DBI)
library(RSQLite)

##############
### SQLITE ###
##############

# Setting sqlite working directory
setwd("/home/arigato/code/chatbotR/")

# Creating data directory
dir.create("Data", showWarnings = FALSE)

# Connecting to SQLite-database
con <- DBI::dbConnect(RSQLite::SQLite(), "Data/chatbot.sqlite")

# Creating messages schema
db_messages_schema <- dplyr::tibble(datetime = character(0),
                                    username = character(0),
                                    message = character(0))

# Creating messages table
if (!"messages" %in% DBI::dbListTables(con)){
  dplyr::copy_to(con, db_messages_schema, name = "messages", overwrite = TRUE,  temporary = FALSE )
}

###############
### TESTING ###
###############

# Creating a message
my_message <- dplyr::tibble(
  username = "User001",
  datetime = Sys.time(),
  message = "Hello World"
)

# Adding a message
RSQLite::dbAppendTable(con, "messages", my_message)

# Listing messages
DBI::dbReadTable(con, name = "messages")

# Deleting messages
DBI::dbSendQuery(con, "DELETE FROM messages")