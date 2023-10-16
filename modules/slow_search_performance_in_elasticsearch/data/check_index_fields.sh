

#!/bin/bash



# Define variables

index_name=${NAME_OF_INDEX_TO_CHECK}



# Check if the index exists

curl -XHEAD -i "localhost:9200/$index_name" >/dev/null 2>&1

if [ $? -ne 0 ]; then

  echo "Error: Index $index_name does not exist."

  exit 1

fi



# Check if all necessary fields are indexed

curl -XGET -s "localhost:9200/$index_name/_mapping" | grep -q '${FIELD_NAME}'

if [ $? -ne 0 ]; then

  echo "Error: Field ${FIELD_NAME} is not indexed in index $index_name."

  exit 1

fi



# If all necessary fields are indexed, exit successfully

echo "Index $index_name is properly indexed."

exit 0