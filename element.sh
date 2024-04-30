#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  # if it is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    CONDITION="elements.atomic_number = $1"
  else
    CONDITION="symbol = '$1' OR name = '$1'"
  fi

  ELEMENT="$($PSQL "SELECT elements.name, elements.symbol, elements.atomic_number, types.type, properties.melting_point_celsius, properties.boiling_point_celsius, properties.atomic_mass FROM elements LEFT JOIN properties ON properties.atomic_number = elements.atomic_number LEFT JOIN types ON properties.type_id = types.type_id WHERE $CONDITION")"

  # if not found
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else  

    # Split the result by the pipe character '|'
    IFS='|' read -ra columns <<< "$ELEMENT"

    # Assign each column to a variable
    name=${columns[0]//[[:space:]]/}
    symbol=${columns[1]//[[:space:]]/}
    atomic_number=${columns[2]//[[:space:]]/}
    type=${columns[3]//[[:space:]]/}
    melting_point_celsius=${columns[4]//[[:space:]]/}
    boiling_point_celsius=${columns[5]//[[:space:]]/}
    atomic_mass=${columns[6]//[[:space:]]/}

    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
  fi  
fi
