# Assignment 3 - Hangman
# BTC1855
# By Trinley Palmo

# R version 4.4.0

# Plan
#' Step 1: Prepare a text file of words for hangman and save to project directory
#' Step 2: Read the file and store it as a list to a variable
#' Step 3: Choose a random word from the list
#' Step 4: Print a message to inform the user on the length of the word
#' Step 5: Print out the rules of the game (e.g., the number of tries allowed,
#' what happens when the user runs out of tries, etc.)
#' Step 6: Loop for if the user still has tries left
#'  Step 6A: Inform the user of how many tries they have (left)
#'  Step 6B: Print out a visual cue of how they are progressing 
#'  (e.g., "b _ _ k")
#'  Step 6C: Ask the user if they want to guess a word or a letter
#'  Step 7: If the user wants to guess the word, compare the user input to word:
#'  if TRUE (the word is correct):
#'    Tell the user that they won
#'    Set the number of tries to 0
#'  if FALSE (the word is incorrect):
#'    Tell the user that the word was incorrect
#'    Subtract 1 from number of tries
#' Step 8: If the user want to guess a letter, check if it exists in the word
#'  if TRUE:
#'    Tell the letter input is correct
#'    Uncover the letters that are correct
#'    Subtract 1 from number of tries
#'  if FALSE:
#'    Tell the letter input is incorrect
#'    Subtract 1 from number of tries
#' Step 9: Ending message based on game outcome:
#'  if user figures out the word:
#'    Print a message congratulating winner and letting them know they won
#'  if user does not figure out the word within limit:
#'    Print a message letting them know they lost

# Assign the directory from which the text file is found on your computer
# and set it as the working directory.
setwd("C:/Users/tpalm/Desktop/MY FILES/UofT/MBiotech/BTC1855/BTC1855_Assignment_3")

# Function creates a string of underscores based on the number of characters
# in the secret word `x`
guess_display <- function(x) {
  paste(replicate(nchar(x), "ˍ"), collapse = "")
}

#' Function that updates the visual display of progress for user as they guess
#' new letters. Takes in the guessed letter, the current display, and the 
#' secret word.
update_display <- function(guessed_letter, guess_display, secret_word) {
  #' Find all position of all occurrences of the guessed letter in the secret
  #' word
  positions <- which(strsplit(secret_word, "")[[1]] == guessed_letter)
  #' Update the current display to reveal all locations of the guessed letter
  for (i in positions) {
  guess_display <- paste0(substr(guess_display, 1, i - 1), guessed_letter, 
                              substr(guess_display, i + 1, nchar(guess_display)))
  }
  #' Print the updated guess display after each guess attempt
  print(guess_display)
}

hangmen <- c("____\n|   |\n|   O\n|  /|\\\n|  / \\\n", 
             " ____\n|   |\n|   O\n|  /|\\\n|  /\n", 
             " ____\n|   |\n|   O\n|  /|\\\n|\n", " ____\n|   |\n|   O\n|  /|\n|\n",
             " ____\n|   |\n|   O\n|   |\n|\n", " ____\n|   |\n|   O\n|\n|\n",
             " ____\n|   |\n|\n|\n|\n")

# Read list of words and save it to a variable for use later
words_list <- read.delim("word_list.txt", header = FALSE)

# Choose a random word from the list that the users would be guessing
answer <- sample(words_list[[1]], size = 1)

# Inform the users on the rules of the game and how many letters there are.
rule_1 <- "To win the game, you must successfully guess the word before the number of lives run out."
rule_2 <- "For each try, you can guess a letter or a word."
rule_3 <- "If you guess wrong, you will lose a life.\nLet's start guessing!\n"
cat(rule_1, rule_2, rule_3, sep = "\n")

print(paste("The word has", nchar(answer), "letters."))

# Generate initial display based on the secret word
display <- guess_display(answer)
# Print the initial display to show the user
print(display)

# Set the total number of lives that the user has
num_tries <- 6
while (num_tries > 0) {
  # Remind the user of how many lives they have left
  print(paste("You have", num_tries, "lives left."))
  # Let the user decide if they want to guess a letter or word
  guess_type <- readline(prompt = "Type `1` if you want to guess a letter and type `2` if you want to guess a word. ")
  
  #' Ensures the user inputs either a 1 or 2. If user inputs none of these two
  #' options, prompt the user again.
  while (guess_type != 1 && guess_type != 2){
    cat("Invalid input. Please try again.")
    guess_type <- readline(prompt = "Type `1` if you want to guess a letter and type `2` if you want to guess a word. ")
  }
  
  if (guess_type == 1){
    print("You are guessing a letter.")
    guess <- readline(prompt = "Please enter your guess: ")
    
    #' Check if the user input for guess is a single letter
    while(!grepl("[a-zA-Z]", guess) || nchar(guess) != 1) {
      print("Invalid input. Please enter a single letter.")
      guess <- readline(prompt = "Please enter your guess: ")
    }
    
    # Convert string to lowercase to ensure match even if user input was 
    # uppercase
    guess <- tolower(guess)
    
    #' Check if the guessed letter is in the secret word. Let the user know if 
    #' it is correct or incorrect.
    if (grepl(guess, answer)){
      #' Informs the user that the guessed letter is correct (since it is found
      #' in the secret word)
      print(paste(guess, "is correct! :)"))
      #' Update the visual display and print it.
      cat(hangmen[num_tries + 1])
      display <- update_display(guess, display, answer)
    } else {
      #' Informs the user that the guessed letter is incorrect (since it is not
      #' found in the secret word)
      print(paste(guess, "is incorrect! :("))
      # User guessed incorrectly - lost a try
      num_tries <- num_tries - 1
      # Show current progress with visual display
      cat(hangmen[num_tries + 1])
      print(display)
    }
  }else{
    print("You are guessing a word.")
    guess <- readline(prompt = "Please enter your guess: ")
    
    #' Check if the user input for guess is a single word - only letters and no
    #' spaces
    while(grepl(" ", guess) || !grepl("^[a-zA-Z]+$", guess)) {
      print("Invalid input. Please enter a single word composed of only letters.")
      guess <- readline(prompt = "Please enter your guess: ")
    }
    
    # Convert string to lowercase to ensure match even if user input was 
    # uppercase
    guess <- tolower(guess)
    
    #' Check if the guessed word is in the secret word. Let the user know if it
    #' is correct or incorrect.
    if (guess == answer) {
      #' Informs the user that the guessed word is correct
      print(paste(guess, "is the correct answer! :D"))
      # User got the correct answer. No remaining tries needed.
      display <- answer
      num_tries <- 0
    } else {
      #' Informs the user that the guessed word is incorrect
      print(paste(guess, "is the wrong answer! :c"))
      # User has used up a try
      num_tries <- num_tries - 1
      # Display the current progress
      cat(hangmen[num_tries + 1])
      print(display)
    }
  }
}

#' Output game outcome message based on if the user guessed the word or not
if (num_tries == 0 && grepl("ˍ", display)) {
  print(paste("GAME OVER: You have used up all your tries.", answer, 
              "was the answer. Better luck next time!"))
} else {
  print(paste("YOU WON! Congratulations! :)"))
}

# cat(" ____\n|   |\n|\n|\n|")
# # cat(" ____\n|   |\n|   O\n|\n|")
# # cat(" ____\n|   |\n|   O\n|   |\n|")
# # cat(" ____\n|   |\n|   O\n|  /|\n|")
# # cat(" ____\n|   |\n|   O\n|  /|\\\n|")
# # cat(" ____\n|   |\n|   O\n|  /|\\\n|  /")
# cat("____\n|   |\n|   O\n|  /|\\\n|  / \\")
