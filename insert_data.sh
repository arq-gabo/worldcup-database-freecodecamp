#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  # Script to insert data from games.csv into worldcup database
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "TRUNCATE teams, games RESTART IDENTITY"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  if [[ $WINNER != winner && $OPPONENT != opponent ]]
  then
      
    # Get WINNER_NAME from teams table
    WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
    # If WINNER_NAME not exist
    if [[ -z $WINNER_NAME ]]
    then
      # Insert WINNER_NAME in the teams Table
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      # If the data was inserted correctly
      if [[ $INSERT_WINNER_RESULT ]]
      then
        echo "The team $WINNER was successfully added"
      fi
    fi

    # Get OPPONENT_NAME from teams table
    OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
    # If OPPONENT_NAME not exist
    if [[ -z $OPPONENT_NAME ]]
    then
      # Insert OPPONENT_NAME in the teams Table
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      # If the data was inserted correctly
      if [[ $INSERT_OPPONENT_RESULT ]]
      then
        echo "The team $OPPONENT was successfully added"
      fi
    fi

  #Get id Winner Team
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  #Get id Opponent Team
  OPPONENT_ID=$($PSQL "SELECT team_ID FROM teams WHERE name = '$OPPONENT'")

  #Insert data the games in the games table
  DATA_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  echo The data from the game between $WINNER and $OPPONENT was successfully added
  
  fi
done

