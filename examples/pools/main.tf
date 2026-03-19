module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

  suffix = ["demo", "pools"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "swedencentral"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 9.0"

  naming = local.naming

  vnet = {
    name                = module.naming.virtual_network.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.0.0.0/16"]

    subnets = {
      sn1 = {
        address_prefixes = ["10.0.1.0/24"]
        delegations = {
          netapp = {
            name = "Microsoft.Netapp/volumes"
          }
        }
      }
    }
  }
}

module "netapp" {
  source  = "cloudnationhq/anf/azure"
  version = "~> 1.0"

  config = {
    name                = module.naming.netapp_account.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "pools" {
  source  = "cloudnationhq/anf/azure//modules/pools"
  version = "~> 1.0"

  account_name        = module.netapp.account.name
  resource_group_name = module.netapp.account.resource_group_name
  location            = module.netapp.account.location

  config = {
    pools = {
      pool-standard = {
        service_level = "Standard"
        size_in_tb    = 4

        volumes = {
          vol-nfs = {
            volume_path         = "volnfs"
            service_level       = "Standard"
            subnet_id           = module.network.subnets.sn1.id
            storage_quota_in_gb = 100
            protocols           = ["NFSv3"]

            export_policy_rule = {
              rule1 = {
                rule_index      = 1
                allowed_clients = ["0.0.0.0/0"]
                protocol        = ["NFSv3"]
                unix_read_write = true
              }
            }
          }
        }
      }
    }
  }
}
