curl -XPOST '${ELASTICSEARCH_URL}/${INDEX_NAME}/_search?profile=true&pretty' -d '

{

  "query": {

    "match": {

      "${FIELD_NAME}": "${SEARCH_TERM}"

    }

  },

  "profile": true

}'