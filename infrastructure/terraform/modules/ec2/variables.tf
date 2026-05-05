variable "instance_name" {
  description = "Logical name for this instance (e.g. app, jenkins)"
  type        = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "create_eip" {
  type    = bool
  default = false
}

variable "user_data" {
  type    = string
  default = ""
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 20
}

variable "force_destroy" {
  type    = bool
  default = false
}
