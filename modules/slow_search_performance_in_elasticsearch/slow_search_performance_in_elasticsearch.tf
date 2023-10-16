resource "shoreline_notebook" "slow_search_performance_in_elasticsearch" {
  name       = "slow_search_performance_in_elasticsearch"
  data       = file("${path.module}/data/slow_search_performance_in_elasticsearch.json")
  depends_on = [shoreline_action.invoke_curl_search_explain,shoreline_action.invoke_search_profile,shoreline_action.invoke_check_index_fields]
}

resource "shoreline_file" "curl_search_explain" {
  name             = "curl_search_explain"
  input_file       = "${path.module}/data/curl_search_explain.sh"
  md5              = filemd5("${path.module}/data/curl_search_explain.sh")
  description      = "Check the Elasticsearch query performance using the explain API"
  destination_path = "/tmp/curl_search_explain.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "search_profile" {
  name             = "search_profile"
  input_file       = "${path.module}/data/search_profile.sh"
  md5              = filemd5("${path.module}/data/search_profile.sh")
  description      = "Check the Elasticsearch query performance using the search profiler"
  destination_path = "/tmp/search_profile.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "check_index_fields" {
  name             = "check_index_fields"
  input_file       = "${path.module}/data/check_index_fields.sh"
  md5              = filemd5("${path.module}/data/check_index_fields.sh")
  description      = "Check the indexing settings and ensure that all the necessary fields are indexed properly. This can improve the search performance significantly."
  destination_path = "/tmp/check_index_fields.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_curl_search_explain" {
  name        = "invoke_curl_search_explain"
  description = "Check the Elasticsearch query performance using the explain API"
  command     = "`chmod +x /tmp/curl_search_explain.sh && /tmp/curl_search_explain.sh`"
  params      = ["FIELD_NAME","ELASTICSEARCH_URL","SEARCH_TERM","INDEX_NAME"]
  file_deps   = ["curl_search_explain"]
  enabled     = true
  depends_on  = [shoreline_file.curl_search_explain]
}

resource "shoreline_action" "invoke_search_profile" {
  name        = "invoke_search_profile"
  description = "Check the Elasticsearch query performance using the search profiler"
  command     = "`chmod +x /tmp/search_profile.sh && /tmp/search_profile.sh`"
  params      = ["FIELD_NAME","ELASTICSEARCH_URL","SEARCH_TERM","INDEX_NAME"]
  file_deps   = ["search_profile"]
  enabled     = true
  depends_on  = [shoreline_file.search_profile]
}

resource "shoreline_action" "invoke_check_index_fields" {
  name        = "invoke_check_index_fields"
  description = "Check the indexing settings and ensure that all the necessary fields are indexed properly. This can improve the search performance significantly."
  command     = "`chmod +x /tmp/check_index_fields.sh && /tmp/check_index_fields.sh`"
  params      = ["FIELD_NAME","NAME_OF_INDEX_TO_CHECK"]
  file_deps   = ["check_index_fields"]
  enabled     = true
  depends_on  = [shoreline_file.check_index_fields]
}

