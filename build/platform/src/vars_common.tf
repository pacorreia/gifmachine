variable "project" {
  description = "Project name"
  type        = string
  default     = "gifmagic"
}

variable "environment" {
  description = "Environment"
  type = object({
    name      = string
    shortName = string
    regions   = list(string)
  })
  default = {
    name      = "development"
    shortName = "dev"
  regions = ["eu-west-3"] }
}
