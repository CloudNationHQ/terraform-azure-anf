variable "config" {
  description = "describes pools and backup configuration"
  type = object({
    backup_vaults = optional(map(object({
      name = optional(string)
      tags = optional(map(string))
      backup_policies = optional(map(object({
        name                    = optional(string)
        daily_backups_to_keep   = optional(number)
        enabled                 = optional(bool)
        monthly_backups_to_keep = optional(number)
        weekly_backups_to_keep  = optional(number)
        tags                    = optional(map(string))
      })), {})
    })), {})
    pools = optional(map(object({
      name                    = optional(string)
      service_level           = string
      size_in_tb              = number
      cool_access_enabled     = optional(bool)
      custom_throughput_mibps = optional(number)
      encryption_type         = optional(string)
      qos_type                = optional(string)
      tags                    = optional(map(string))
      volumes = optional(map(object({
        name                                                 = optional(string)
        volume_path                                          = string
        service_level                                        = string
        subnet_id                                            = string
        storage_quota_in_gb                                  = number
        protocols                                            = optional(set(string))
        security_style                                       = optional(string)
        network_features                                     = optional(string)
        zone                                                 = optional(string)
        snapshot_directory_visible                           = optional(bool)
        throughput_in_mibps                                  = optional(number)
        encryption_key_source                                = optional(string)
        key_vault_private_endpoint_id                        = optional(string)
        kerberos_enabled                                     = optional(bool)
        large_volume_enabled                                 = optional(bool)
        azure_vmware_data_store_enabled                      = optional(bool)
        create_from_snapshot_resource_id                     = optional(string)
        accept_grow_capacity_pool_for_short_term_clone_split = optional(string)
        smb3_protocol_encryption_enabled                     = optional(bool)
        smb_access_based_enumeration_enabled                 = optional(bool)
        smb_continuous_availability_enabled                  = optional(bool)
        smb_non_browsable_enabled                            = optional(bool)
        tags                                                 = optional(map(string))
        cool_access = optional(object({
          coolness_period_in_days = number
          retrieval_policy        = string
          tiering_policy          = string
        }))
        data_protection_backup_policy = optional(object({
          backup_vault_key  = string
          backup_policy_key = string
          policy_enabled    = optional(bool)
        }))
        data_protection_replication = optional(object({
          endpoint_type             = optional(string)
          remote_volume_location    = string
          remote_volume_resource_id = string
          replication_frequency     = string
        }))
        data_protection_snapshot_policy = optional(object({
          snapshot_policy_id = string
        }))
        export_policy_rule = optional(map(object({
          rule_index                     = number
          allowed_clients                = set(string)
          protocol                       = optional(list(string))
          unix_read_only                 = optional(bool)
          unix_read_write                = optional(bool)
          root_access_enabled            = optional(bool)
          kerberos_5_read_only_enabled   = optional(bool)
          kerberos_5_read_write_enabled  = optional(bool)
          kerberos_5i_read_only_enabled  = optional(bool)
          kerberos_5i_read_write_enabled = optional(bool)
          kerberos_5p_read_only_enabled  = optional(bool)
          kerberos_5p_read_write_enabled = optional(bool)
        })))
        snapshots = optional(map(object({
          name = optional(string)
        })), {})
        quota_rules = optional(map(object({
          name              = optional(string)
          quota_size_in_kib = number
          quota_type        = string
          quota_target      = optional(string)
        })), {})
      })), {})
    })), {})
  })
}

variable "account_name" {
  description = "netapp account name"
  type        = string
}

variable "resource_group_name" {
  description = "resource group name"
  type        = string
}

variable "location" {
  description = "azure region"
  type        = string
}
