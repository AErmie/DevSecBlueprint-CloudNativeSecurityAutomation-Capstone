variable "name" {
  description = "Azure Monitor Action Group name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group that contains the action group."
  type        = string
}

variable "short_name" {
  description = "Action group short name, limited by Azure to 12 characters."
  type        = string
}

variable "enabled" {
  description = "Whether the action group is enabled."
  type        = bool
  default     = true
}

variable "email_receiver" {
  description = "Optional email receiver configuration."
  type = object({
    name          = string
    email_address = string
  })
  default  = null
  nullable = true
}

variable "webhook_receiver" {
  description = "Optional webhook receiver configuration for automation routing."
  type = object({
    name        = string
    service_uri = string
  })
  default  = null
  nullable = true
}

variable "tags" {
  description = "Tags applied to the action group."
  type        = map(string)
  default     = {}
}