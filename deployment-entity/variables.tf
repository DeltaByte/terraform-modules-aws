variable "name" {
  type = string
}

variable "path" {
  type        = string
  description = "IAM user/role path"
  default     = "/deployment/"

  validation {
    error_message = "path must by prefixed/suffixed with slashes."
    condition     = can(regex("^\\/[\\w-]+\\/$", var.path))
  }
}

variable "remotestate_role" {
  type        = string
  description = "IAM role ARN for accessing terraform backend"
}
