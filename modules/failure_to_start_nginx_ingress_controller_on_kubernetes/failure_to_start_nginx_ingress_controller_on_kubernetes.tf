resource "shoreline_notebook" "failure_to_start_nginx_ingress_controller_on_kubernetes" {
  name       = "failure_to_start_nginx_ingress_controller_on_kubernetes"
  data       = file("${path.module}/data/failure_to_start_nginx_ingress_controller_on_kubernetes.json")
  depends_on = [shoreline_action.invoke_rescale_node_resources]
}

resource "shoreline_file" "rescale_node_resources" {
  name             = "rescale_node_resources"
  input_file       = "${path.module}/data/rescale_node_resources.sh"
  md5              = filemd5("${path.module}/data/rescale_node_resources.sh")
  description      = "Check if there are resource constraints on the node where the Nginx Ingress Controller is deployed. Move the deployment to a node with more resources."
  destination_path = "/tmp/rescale_node_resources.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_rescale_node_resources" {
  name        = "invoke_rescale_node_resources"
  description = "Check if there are resource constraints on the node where the Nginx Ingress Controller is deployed. Move the deployment to a node with more resources."
  command     = "`chmod +x /tmp/rescale_node_resources.sh && /tmp/rescale_node_resources.sh`"
  params      = ["MEMORY_REQUEST","CPU_REQUEST","INGRESS_CONTROLLER_DEPLOYMENT_NAME","NODE_NAME"]
  file_deps   = ["rescale_node_resources"]
  enabled     = true
  depends_on  = [shoreline_file.rescale_node_resources]
}

