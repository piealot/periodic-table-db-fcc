#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
if [[ $1 =~ ^[0-9]+$ ]]; then
   NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
   if [[ -z $NAME ]]
   then
   echo I could not find that element in the database.
   else
    DATA=$($PSQL "SELECT atomic_number, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$NAME'")
    echo "$DATA" | while IFS="|" read ATOMIC_NUMBER SYMBOL ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE 
    do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
   fi
else
   ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name='$1'")
   if [[ -z $ATOMIC_NUMBER ]]
   then
   echo I could not find that element in the database.
   else
    DATA=$($PSQL "SELECT name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number='$ATOMIC_NUMBER'")
    echo "$DATA" | while IFS="|" read NAME SYMBOL ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE 
    do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
   fi
fi
else
echo Please provide an element as an argument.
fi

