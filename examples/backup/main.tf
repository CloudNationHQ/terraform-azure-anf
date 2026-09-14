module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.32"

  suffix = ["demo", "bkup"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "swedencentral"
    }
  }
}

module "netapp" {
  source  = "cloudnationhq/anf/azure"
  version = "~> 2.0"

  netapp = {
    name                = module.naming.netapp_account.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "pools" {
  source  = "cloudnationhq/anf/azure//modules/pools"
  version = "~> 2.0"

  account_name        = module.netapp.account.name
  resource_group_name = module.netapp.account.resource_group_name
  location            = module.netapp.account.location

  netapp = {
    backup_vaults = {
      vault-demo = {
        backup_policies = {
          policy-daily = {
            daily_backups_to_keep   = 7
            weekly_backups_to_keep  = 4
            monthly_backups_to_keep = 3
          }
        }
      }
    }
  }
}
