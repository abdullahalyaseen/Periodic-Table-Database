#!/bin/bash

PSQL="psql --username=postgres --dbname=periodic_table -t --no-align -c"
#take argument from user
USER_CHOISE=$1
if [[ ! $1 ]]
then
 echo "Please provide an element as an argument."
else
    if [[ $USER_CHOISE =~ ^[1-9]+[0-9]*$ ]]
then
  ELEMENT_DATA=$($PSQL "select name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number = $USER_CHOISE")
  if [[ -z $ELEMENT_DATA ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT_DATA" | while IFS="|" read ELEMENT SYMBOL TYPE MASS MELTING BOILING
    do
    echo "The element with atomic number $USER_CHOISE is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $ELEMENT has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
  fi
elif [[ $USER_CHOISE =~ ^[a-zA-Z]{1,2}$ ]]
then
  ELEMENT_DATA=$($PSQL "select name,symbol,atomic_number,type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where symbol ILIKE '$USER_CHOISE'")

  if [[ -z $ELEMENT_DATA ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT_DATA" | while IFS="|" read NAME SYMBOL ATOMIC TYPE MASS MELTING BOILING
    do
    echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
  fi
elif [[ $USER_CHOISE =~ ^[a-zA-Z]*$ ]]
then
    ELEMENT_DATA=$($PSQL "select symbol,name,atomic_number,type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where name ILIKE '$USER_CHOISE'")
  if [[ -z $ELEMENT_DATA ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT_DATA" | while IFS="|" read SYMBOL NAME ATOMIC TYPE MASS MELTING BOILING
    do
    echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
  fi
fi
fi


