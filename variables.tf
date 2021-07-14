variable "name" {
  description = "Name for this spoke VPC and it's gateways"
  type        = string
}

variable "prefix" {
  description = "Boolean to determine if name will be prepended with avx-"
  type        = bool
  default     = true
}

variable "suffix" {
  description = "Boolean to determine if name will be appended with -spoke"
  type        = bool
  default     = true
}

variable "region" {
  description = "The ALI region to deploy this module in"
  type        = string
}

variable "cidr" {
  description = "The CIDR range to be used for the VPC"
  type        = string
  default     = ""
}

variable "account" {
  description = "The ALI account name, as known by the Aviatrix controller"
  type        = string
}

variable "instance_size" {
  description = "ALI Instance size for the Aviatrix gateways"
  type        = string
  default     = "t3.medium"
}

variable "ha_gw" {
  description = "Boolean to determine if module will be deployed in HA or single mode"
  type        = bool
  default     = true
}

variable "transit_gw" {
  description = "Name of the transit gateway to attach this spoke to"
  type        = string
  default     = ""
}

variable "transit_gw_route_tables" {
  description = "Route tables to propagate routes to for transit_gw attachment"
  type        = list(string)
  default     = []
}

variable "active_mesh" {
  description = "Set to false to disable active mesh."
  type        = bool
  default     = true
}

variable "attached" {
  description = "Set to false if you don't want to attach spoke to transit_gw."
  type        = bool
  default     = true
}

variable "security_domain" {
  description = "Provide security domain name to which spoke needs to be deployed. Transit gateway mus tbe attached and have segmentation enabled."
  type        = string
  default     = ""
}

variable "single_az_ha" {
  description = "Set to true if Controller managed Gateway HA is desired"
  type        = bool
  default     = true
}

variable "customized_spoke_vpc_routes" {
  description = "A list of comma separated CIDRs to be customized for the spoke VPC routes. When configured, it will replace all learned routes in VPC routing tables, including RFC1918 and non-RFC1918 CIDRs. It applies to this spoke gateway only​. Example: 10.0.0.0/116,10.2.0.0/16"
  type        = string
  default     = ""
}

variable "filtered_spoke_vpc_routes" {
  description = "A list of comma separated CIDRs to be filtered from the spoke VPC route table. When configured, filtering CIDR(s) or it’s subnet will be deleted from VPC routing tables as well as from spoke gateway’s routing table. It applies to this spoke gateway only. Example: 10.2.0.0/116,10.3.0.0/16"
  type        = string
  default     = ""
}

variable "included_advertised_spoke_routes" {
  description = "A list of comma separated CIDRs to be advertised to on-prem as Included CIDR List. When configured, it will replace all advertised routes from this VPC. Example: 10.4.0.0/116,10.5.0.0/16"
  type        = string
  default     = ""
}

variable "private_vpc_default_route" {
  description = "Program default route in VPC private route table."
  type        = bool
  default     = false
}

variable "skip_public_route_table_update" {
  description = "Skip programming VPC public route table."
  type        = bool
  default     = false
}

variable "auto_advertise_s2c_cidrs" {
  description = "Auto Advertise Spoke Site2Cloud CIDRs."
  type        = bool
  default     = false
}

variable "tunnel_detection_time" {
  description = "The IPsec tunnel down detection time for the Spoke Gateway in seconds. Must be a number in the range [20-600]."
  type        = number
  default     = null
}

variable "use_existing_vpc" {
  description = "Set to true to use existing VPC."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID, for using an existing VPC."
  type        = string
  default     = ""
}

variable "gw_subnet" {
  description = "Subnet CIDR, for using an existing VPC. Required when use_existing_vpc is true"
  type        = string
  default     = ""
}

variable "hagw_subnet" {
  description = "Subnet CIDR, for using an existing VPC. Required when use_existing_vpc is true and ha_gw is true"
  type        = string
  default     = ""
}

locals {
  lower_name = replace(lower(var.name), " ", "-")
  prefix     = var.prefix ? "avx-" : ""
  suffix     = var.suffix ? "-spoke" : ""
  cidr       = var.use_existing_vpc ? "10.0.0.0/20" : var.cidr #Set dummy if existing VPC is used.
  name       = "${local.prefix}${local.lower_name}${local.suffix}"
  cidrbits   = tonumber(split("/", local.cidr)[1])
  newbits    = 26 - local.cidrbits
  netnum     = pow(2, local.newbits)
  subnet     = var.use_existing_vpc ? var.gw_subnet : aviatrix_vpc.default[0].public_subnets[0].cidr
  ha_subnet  = var.use_existing_vpc ? var.hagw_subnet : aviatrix_vpc.default[0].public_subnets[1].cidr
}
