curl -XGET '${ELASTICSEARCH_URL}/${INDEX_NAME}/_search/explain?pretty' -d '

{

  "query": {

    "match": {

      "${FIELD_NAME}": "${SEARCH_TERM}"

    }

  }

}'