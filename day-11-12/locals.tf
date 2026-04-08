locals {
  formatted_project_name = lower(replace(var.project_name, " ", "_"))
  merged_tags            = merge(var.default_tags, var.environment_tags)
  formatted_bucket_name  = lower(replace("Name of the Bucket with Spaces and Uppercase letters", " ", "-"))
  port_list              = split(",", var.allowed_ports)
  sg_rules = [for port in local.port_list :
    {
      name        = "port-${port}"
      port        = port
      description = "Allow traffic on port ${port}"
  }]
  instance_size       = lookup(var.instance_size, var.environment, "t2.micro")
  positive_costs      = [for cost in var.monthly_costs : abs(cost)]
  max_cost            = max(local.positive_costs...)
  min_cost            = min(local.positive_costs...)
  avg_cost            = local.max_cost / length(local.positive_costs)
  total_cost          = sum(local.positive_costs)
  current_timestamp   = timestamp()
  formatted_timestamp = formatdate("YYYY-MM-DD HH:mm:ss", local.current_timestamp)
  config_file_exists  = fileexists("./config.json")
  config_data = local.config_file_exists ? jsondecode(file("config.json")) : {
    id          = null
    activo      = false
    nombre      = ""
    descripcion = null
    valores     = []
    metadatos   = {}
    etiquetas   = []
  }
}
