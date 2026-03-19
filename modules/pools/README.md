<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm)

## Resources

The following resources are used by this module:

- [azurerm_netapp_backup_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_backup_policy) (resource)
- [azurerm_netapp_backup_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_backup_vault) (resource)
- [azurerm_netapp_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_pool) (resource)
- [azurerm_netapp_snapshot.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_snapshot) (resource)
- [azurerm_netapp_volume.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_volume) (resource)
- [azurerm_netapp_volume_quota_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_volume_quota_rule) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_account_name"></a> [account\_name](#input\_account\_name)

Description: netapp account name

Type: `string`

### <a name="input_config"></a> [config](#input\_config)

Description: describes pools and backup configuration

Type:

```hcl
object({
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
```

### <a name="input_location"></a> [location](#input\_location)

Description: azure region

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: resource group name

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_backup_policies"></a> [backup\_policies](#output\_backup\_policies)

Description: contains all exported attributes of the netapp backup policies

### <a name="output_backup_vaults"></a> [backup\_vaults](#output\_backup\_vaults)

Description: contains all exported attributes of the netapp backup vaults

### <a name="output_pools"></a> [pools](#output\_pools)

Description: contains all exported attributes of the netapp pools

### <a name="output_quota_rules"></a> [quota\_rules](#output\_quota\_rules)

Description: contains all exported attributes of the netapp volume quota rules

### <a name="output_snapshots"></a> [snapshots](#output\_snapshots)

Description: contains all exported attributes of the netapp snapshots

### <a name="output_volumes"></a> [volumes](#output\_volumes)

Description: contains all exported attributes of the netapp volumes
<!-- END_TF_DOCS -->