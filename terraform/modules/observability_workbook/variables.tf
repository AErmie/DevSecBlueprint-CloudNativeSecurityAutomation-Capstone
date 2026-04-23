variable "location" {
  description = "Azure region for the workbook."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where workbook is created."
  type        = string
}

variable "display_name" {
  description = "Workbook display name."
  type        = string
}

variable "source_id" {
  description = "Source resource ID, typically Log Analytics workspace."
  type        = string
}

variable "data_json" {
  description = "Workbook serialized data JSON."
  type        = string
}

variable "tags" {
  description = "Tags for workbook resource."
  type        = map(string)
  default     = {}
}
