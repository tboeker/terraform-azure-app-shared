variable "location" {
  type        = string
  default     = "westeurope"
  description = "Specify a location see: az account list-locations -o table"
}

variable "appname" {
  type = string
  default = "tb-code1"
  description = "the long name of the app: tb-code1"
}

variable "appshort" {
  type = string
  default = "tbcode1"
  description = "the short name of the app: tbcode1"
}

variable "devgroupid" {
  type        = string
  default     = "a11cdfb2-0654-472b-a1e3-55c4748a1f01"
  description = "the developer group id for keyvault access"
}


variable "tags" {
  type        = map
  description = "A list of tags associated to all resources"

  default = {
    maintained_by = "terraform"
  }
}