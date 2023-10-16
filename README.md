
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Slow search performance in Elasticsearch
---

This incident type refers to a situation in which the search performance within an Elasticsearch database is slow or degraded. This can result in slow response times or timeouts when users try to search for specific data, affecting the overall user experience and causing frustration. Elasticsearch is a search engine that is commonly used in various applications to provide fast and efficient search capabilities, so any slowdown or performance issues can have a significant impact on the application's functionality.

### Parameters
```shell
export ELASTICSEARCH_URL="PLACEHOLDER"

export CLUSTER_NAME="PLACEHOLDER"

export INDEX_NAME="PLACEHOLDER"

export SEARCH_TERM="PLACEHOLDER"

export FIELD_NAME="PLACEHOLDER"

export NAME_OF_INDEX_TO_CHECK="PLACEHOLDER"
```

## Debug

### Check the status of the Elasticsearch indices
```shell
curl -XGET '${ELASTICSEARCH_URL}/_cat/indices?v'
```

### Check the cluster health status
```shell
curl -XGET '${ELASTICSEARCH_URL}/_cluster/health?pretty'
```

### Check the status of the Elasticsearch nodes
```shell
curl -XGET '${ELASTICSEARCH_URL}/_cat/nodes?v'
```

### Check the status of the Elasticsearch shards
```shell
curl -XGET '${ELASTICSEARCH_URL}/_cat/shards?v'
```

### Check the Elasticsearch logs for any errors or warnings
```shell
sudo tail -f /var/log/elasticsearch/${CLUSTER_NAME}.log
```

### Check the Elasticsearch query performance using the profile API
```shell
curl -XGET '${ELASTICSEARCH_URL}/${INDEX_NAME}/_search?profile=true&pretty'
```

### Check the Elasticsearch query performance using the explain API
```shell
curl -XGET '${ELASTICSEARCH_URL}/${INDEX_NAME}/_search/explain?pretty' -d '

{

  "query": {

    "match": {

      "${FIELD_NAME}": "${SEARCH_TERM}"

    }

  }

}'
```

### Check the Elasticsearch query performance using the search profiler
```shell
curl -XPOST '${ELASTICSEARCH_URL}/${INDEX_NAME}/_search?profile=true&pretty' -d '

{

  "query": {

    "match": {

      "${FIELD_NAME}": "${SEARCH_TERM}"

    }

  },

  "profile": true

}'
```

### Check the indexing settings and ensure that all the necessary fields are indexed properly. This can improve the search performance significantly.
```shell


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


```