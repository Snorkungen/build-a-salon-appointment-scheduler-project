#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

SHOW_SERVICES() {
$PSQL "SELECT * FROM services" | while read SERVICE_ID BAR NAME; do
  if [[ -z $SERVICE_ID  ]]; then continue; fi
  echo "$SERVICE_ID) $NAME"
done
echo -e "\nSelect service"
read SERVICE_ID_SELECTED
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
if [[ -z $SERVICE_NAME ]];then
  SHOW_SERVICES
else
echo -e "\nEnter phone number"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]];then
  echo -e "\nEnter name"
  read CUSTOMER_NAME
  INSERT_RESULT=$($PSQL "INSERT INTO customers (phone,name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')") 
fi
echo -e "\nEnter time"
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
INSERT_RESULT=$($PSQL "INSERT INTO appointments (service_id,customer_id,time) VALUES ($SERVICE_ID_SELECTED, $CUSTOMER_ID,'$SERVICE_TIME')") 
echo $INSERT_RESULT
if [[ $INSERT_RESULT == "INSERT 0 1" ]];then
  echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi
fi
}

SHOW_SERVICES
