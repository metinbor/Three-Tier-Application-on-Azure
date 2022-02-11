
variable "location" {
    default = "West Europe"
}

variable "name" {
    default = "azure-project"
}
 variable "vnetcidr" {
     default = "10.0.0.0/16"
 }
 variable "websubnetcidr" {
     default = "10.0.1.0/24"
 }
 
 variable "appsubnetcidr" {
     default = "10.0.2.0/24"
 }
 variable "dbsubnetcidr" {
     default = "10.0.3.0/24"
 }

