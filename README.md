# terraform-aviatrix-ali-spoke

# This module will be deprecated in favor of the new multi-cloud spoke module
The Multi-Cloud can be found here: https://registry.terraform.io/modules/terraform-aviatrix-modules/mc-spoke/aviatrix/latest
This legacy module will remain available in the Terraform registry and on Github for the forseable future, but please plan to replace any usage of it with the multi-cloud spoke module.
This module will no longer be maintained and updated.

### Description
This module deploys a very simple spoke VPC, with a public and a private subnet in each availability zone.

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v4.0.0 | 0.13-0.15 | >=6.4 | >=0.2.19

### Diagram
<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-ali-spoke/blob/master/img/spoke-vpc-ali-ha.png?raw=true">

with ha_gw set to false, the following will be deployed:

<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-ali-spoke/blob/master/img/spoke-vpc-ali.png?raw=true">

### Usage Example
```
module "spoke_ali_1" {
  source  = "terraform-aviatrix-modules/ali-spoke/aviatrix"
  version = "4.0.0"

  name            = "App1"
  cidr            = "10.1.0.0/20"
  region          = "acs-us-west-1 (Silicon Valley)"
  account         = "ALI"
  transit_gw      = "avx-silicon-valley-transit"
  security_domain = "blue"
}
```

### Variables
The following variables are required:

key | value
:--- | :---
name | Name for this spoke VPC and it's gateways
region | ALI region to deploy this VPC in
cidr | What ip CIDR to use for this VPC (Not required when use_existing_vpc is true)
account | The account name as known by the Aviatrix controller
transit_gw | The name of the transit gateway we want to attach this spoke to. Not required when attached is set to false.

The following variables are optional:

key | default | value 
:---|:---|:---
instance_size | ecs.g5ne.large | The size of the Aviatrix spoke gateways
ha_gw | true | Set to false if you only want to deploy a single Aviatrix spoke gateway
active_mesh | true | Set to false to disable active mesh.
prefix | true | Boolean to enable prefix name with avx-
suffix | true | Boolean to enable suffix name with -spoke
attached | true | Set to false if you don't want to attach spoke to transit_gw.
security_domain | | Provide security domain name to which spoke needs to be deployed. Transit gateway must be attached and have segmentation enabled.
single_az_ha | true | Set to false if Controller managed Gateway HA is desired
customized_spoke_vpc_routes | | A list of comma separated CIDRs to be customized for the spoke VPC routes. When configured, it will replace all learned routes in VPC routing tables, including RFC1918 and non-RFC1918 CIDRs. Example: 10.0.0.0/116,10.2.0.0/16
filtered_spoke_vpc_routes | | A list of comma separated CIDRs to be filtered from the spoke VPC route table. When configured, filtering CIDR(s) or it’s subnet will be deleted from VPC routing tables as well as from spoke gateway’s routing table. Example: 10.2.0.0/116,10.3.0.0/16
included_advertised_spoke_routes | | A list of comma separated CIDRs to be advertised to on-prem as Included CIDR List. When configured, it will replace all advertised routes from this VPC. Example: 10.4.0.0/116,10.5.0.0/16
enable_encrypt_volume | false | Set to true to enable EBS volume encryption for Gateway.
customer_managed_keys | null | Customer managed key ID for EBS Volume encryption.
private_vpc_default_route | false | Program default route in VPC private route table.
skip_public_route_table_update | false | Skip programming VPC public route table.
auto_advertise_s2c_cidrs | false | Auto Advertise Spoke Site2Cloud CIDRs.
tunnel_detection_time | null | The IPsec tunnel down detection time for the Spoke Gateway in seconds. Must be a number in the range [20-600]. Default is 60.
use_existing_vpc | false | Set to true to use an existing VPC in stead of having this module create one.
vpc_id | | VPC ID, for using an existing VPC.
gw_subnet | | Subnet CIDR, for using an existing VPC. Required when use_existing_vpc is enabled. Make sure this is a public subnet.
hagw_subnet | | Subnet CIDR, for using an existing VPC. Required when use_existing_vpc is enabled and ha_gw is true. Make sure this is a public subnet.
transit_gw_route_tables | [] | A list of route tables to propagate routes to for transit_gw attachment.

### Outputs
This module will return the following outputs:

key | description
:---|:---
[vpc](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/aviatrix_vpc) | The created VPC as an object with all of it's attributes (when use_existing_vpc is false). This was created using the aviatrix_vpc resource.
[spoke_gateway](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/aviatrix_spoke_gateway) | The created Aviatrix spoke gateway as an object with all of it's attributes.

