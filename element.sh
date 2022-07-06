#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"


if [[ ! $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

# if numeric
if [[ $1 =~ ^[0-9]+$ ]]
then
  # compare with database - return data
  ELEMENT_ATOMIC=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number = $1")
  if [[ -z $ELEMENT_ATOMIC ]]
  then
    echo -e "I could not find that element in the database."
    exit
  else
    echo $($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1") | while read ATOM_NUM BAR ATOM_NAME BAR ATOM_SYMBOL BAR ATOM_TYPE BAR ATOM_MASS BAR ATOM_MELT BAR ATOM_BOIL
    do
      echo "The element with atomic number $ATOM_NUM is $ATOM_NAME ($ATOM_SYMBOL). It's a $ATOM_TYPE, with a mass of $ATOM_MASS amu. $ATOM_NAME has a melting point of $ATOM_MELT celsius and a boiling point of $ATOM_BOIL celsius." 
    done
  fi
exit
# equal or less than two letters
elif [[ ${#1} -le 2 ]]
then
  ELEMENT_SYMBOL=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol = '$1'")
  # if not available
  if [[ -z $ELEMENT_SYMBOL ]]
  then
    echo -e "I could not find that element in the database."
    exit
  else
    echo $($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1'") | while read ATOM_NUM BAR ATOM_NAME BAR ATOM_SYMBOL BAR ATOM_TYPE BAR ATOM_MASS BAR ATOM_MELT BAR ATOM_BOIL
    do
      echo "The element with atomic number $ATOM_NUM is $ATOM_NAME ($ATOM_SYMBOL). It's a $ATOM_TYPE, with a mass of $ATOM_MASS amu. $ATOM_NAME has a melting point of $ATOM_MELT celsius and a boiling point of $ATOM_BOIL celsius." 
    done
  fi
  exit
# named element
else [[ ${#1} -gt 2 ]]
  ELEMENT_NAME=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE name = '$1'")
  # if not available
  if [[ -z $ELEMENT_NAME ]]
  then
    echo -e "I could not find that element in the database."
    exit
  else
    echo $($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1'") | while read ATOM_NUM BAR ATOM_NAME BAR ATOM_SYMBOL BAR ATOM_TYPE BAR ATOM_MASS BAR ATOM_MELT BAR ATOM_BOIL
    do
      echo "The element with atomic number $ATOM_NUM is $ATOM_NAME ($ATOM_SYMBOL). It's a $ATOM_TYPE, with a mass of $ATOM_MASS amu. $ATOM_NAME has a melting point of $ATOM_MELT celsius and a boiling point of $ATOM_BOIL celsius." 
    done
  fi

fi
