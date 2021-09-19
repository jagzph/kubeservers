# variables for kubernetes hosts

# Image distro
variable "image" {
  type = string
  default = "CentOS-7"
}

variable "int_net" {
  type = string
  default = "vmnet1"
}

variable "knodes" {
  type = string
  default = "m1.medium"
}

variable "kprx" {
  type = string
  default = "m1.small"
}

variable "sshkey" {
  type = string
  default = "k8snode"
}

variable "secgroup" {
  type = list(string)
  default = ["default"]
}

