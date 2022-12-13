# Openstack project Id

variable "serviceName" {
  type = string
}

// Network common parameters

variable "common" {
  type = object({
    regions         = list(string)
    monoNwName      = string
    monoSubnetName  = string
    routerName      = string
    multiNwName     = string
    multiNwVlanId   = number
    backSubnetName  = string
    backRouterName  = string
    multiSubnetCIDR = string
  })
}

# Network by regions parameters

variable "multi" {
  type = list(object({
    region             = string
    monoSubnetCIDR     = string
    routerMonoNwIP  = string
    routerMultiNwIP    = string
    multiSubnetStart   = string
    multiSubnetEnd     = string
  }))
}

# SSH keypair

variable "keypair" {
  type = object({
    keypairName               = string
    keypairMainRegion         = string
    keypairToReproduceRegions = list(string)
  })
}

# Bastion parameters

variable "bastion" {
  type = object({
    frontNwName    = string
    bRegion        = string
    bSubnetCIDR    = string
    bRtrIp         = string
    bGateway       = string
    bastionName    = string
    bastionFlavor  = string
    bastionImage   = string
    bastionUser    = string
    bastionIP      = string
    backSubnetCIDR = string
  })
}

# Target parameters

variable "target" {
  type = object({
    frontNwName    = string
    bRegion        = string
    bSubnetCIDR    = string
    bRtrIp         = string
    bGateway       = string
    targetName     = string
    targetFlavor   = string
    targetImage    = string
    targetUser     = string
    targetIP       = string
    backSubnetCIDR = string
  })
}
