# --------------- Network ---------------
variable "cidr_block" {
  default = "10.40.0.0/16"
}

variable "az" {
  type = map
  default = {
    az1 = "ap-northeast-1a"
    az2 = "ap-northeast-1b"
    az3 = "ap-northeast-1c"
  }
}

variable "subnet_cidr_block" {
  type = map
  default = {
    pub1 = "10.40.0.0/20"
    pub2 = "10.40.16.0/20"
    pub3 = "10.40.32.0/20"
    pri1 = "10.40.48.0/20"
    pri2 = "10.40.64.0/20"
    pri3 = "10.40.80.0/20"
  }
}
