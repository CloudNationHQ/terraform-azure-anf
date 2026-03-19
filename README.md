# Azure NetApp Files

This terraform module simplifies the creation and management of azure netapp files resources, providing customizable options for accounts, capacity pools, volumes, snapshots, backup policies, and snapshot policies, all managed through code.

## Features

Capability to handle capacity pools with nested volumes, snapshots, and quota rules.

Includes support for backup policies and backup vaults.

Utilization of terratest for robust validation.

Supports snapshot policies with hourly, daily, weekly, and monthly schedules.

Supports volume groups for Oracle and SAP HANA workloads.

Supports customer-managed key encryption for accounts.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_netapp_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_account) (resource)
- [azurerm_netapp_account_encryption.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_account_encryption) (resource)
- [azurerm_netapp_snapshot_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_snapshot_policy) (resource)
- [azurerm_netapp_volume_group_oracle.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_volume_group_oracle) (resource)
- [azurerm_netapp_volume_group_sap_hana.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_volume_group_sap_hana) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_config"></a> [config](#input\_config)

Description: describes netapp account related configuration

Type:

```hcl
object({
    name                = string
    resource_group_name = optional(string)
    location            = optional(string)
    tags                = optional(map(string))
    active_directory = optional(object({
      aes_encryption_enabled            = optional(bool)
      dns_servers                       = list(string)
      domain                            = string
      kerberos_ad_name                  = optional(string)
      kerberos_kdc_ip                   = optional(string)
      ldap_over_tls_enabled             = optional(bool)
      ldap_signing_enabled              = optional(bool)
      local_nfs_users_with_ldap_allowed = optional(bool)
      organizational_unit               = optional(string)
      password                          = string
      server_root_ca_certificate        = optional(string)
      site_name                         = optional(string)
      smb_server_name                   = string
      username                          = string
    }))
    identity = optional(object({
      identity_ids = optional(set(string))
      type         = string
    }))
    encryption = optional(object({
      encryption_key                        = string
      system_assigned_identity_principal_id = optional(string)
      user_assigned_identity_id             = optional(string)
      federated_client_id                   = optional(string)
      cross_tenant_key_vault_resource_id    = optional(string)
    }))
    snapshot_policies = optional(map(object({
      name    = optional(string)
      enabled = bool
      tags    = optional(map(string))
      daily_schedule = optional(object({
        hour              = number
        minute            = number
        snapshots_to_keep = number
      }))
      hourly_schedule = optional(object({
        minute            = number
        snapshots_to_keep = number
      }))
      monthly_schedule = optional(object({
        days_of_month     = set(number)
        hour              = number
        minute            = number
        snapshots_to_keep = number
      }))
      weekly_schedule = optional(object({
        days_of_week      = set(string)
        hour              = number
        minute            = number
        snapshots_to_keep = number
      }))
    })), {})
    volume_group_oracles = optional(map(object({
      name                   = optional(string)
      application_identifier = string
      group_description      = string
      volume = map(object({
        capacity_pool_id              = string
        name                          = optional(string)
        protocols                     = list(string)
        security_style                = string
        service_level                 = string
        snapshot_directory_visible    = bool
        storage_quota_in_gb           = number
        subnet_id                     = string
        throughput_in_mibps           = number
        volume_path                   = string
        volume_spec_name              = string
        proximity_placement_group_id  = optional(string)
        zone                          = optional(string)
        network_features              = optional(string)
        encryption_key_source         = optional(string)
        key_vault_private_endpoint_id = optional(string)
        tags                          = optional(map(string))
        data_protection_replication = optional(object({
          endpoint_type             = optional(string)
          remote_volume_location    = string
          remote_volume_resource_id = string
          replication_frequency     = string
        }))
        data_protection_snapshot_policy = optional(object({
          snapshot_policy_id = string
        }))
        export_policy_rule = map(object({
          allowed_clients     = string
          nfsv3_enabled       = bool
          nfsv41_enabled      = bool
          root_access_enabled = optional(bool)
          rule_index          = number
          unix_read_only      = optional(bool)
          unix_read_write     = optional(bool)
        }))
      }))
    })), {})
    volume_group_sap_hanas = optional(map(object({
      name                   = optional(string)
      application_identifier = string
      group_description      = string
      volume = map(object({
        capacity_pool_id              = string
        name                          = optional(string)
        protocols                     = list(string)
        security_style                = string
        service_level                 = string
        snapshot_directory_visible    = bool
        storage_quota_in_gb           = number
        subnet_id                     = string
        throughput_in_mibps           = number
        volume_path                   = string
        volume_spec_name              = string
        proximity_placement_group_id  = optional(string)
        zone                          = optional(string)
        network_features              = optional(string)
        encryption_key_source         = optional(string)
        key_vault_private_endpoint_id = optional(string)
        tags                          = optional(map(string))
        data_protection_replication = optional(object({
          endpoint_type             = optional(string)
          remote_volume_location    = string
          remote_volume_resource_id = string
          replication_frequency     = string
        }))
        data_protection_snapshot_policy = optional(object({
          snapshot_policy_id = string
        }))
        export_policy_rule = map(object({
          allowed_clients     = string
          nfsv3_enabled       = bool
          nfsv41_enabled      = bool
          root_access_enabled = optional(bool)
          rule_index          = number
          unix_read_only      = optional(bool)
          unix_read_write     = optional(bool)
        }))
      }))
    })), {})
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_naming"></a> [naming](#input\_naming)

Description: contains naming convention

Type: `map(string)`

Default: `{}`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_account"></a> [account](#output\_account)

Description: contains all exported attributes of the netapp account

### <a name="output_encryption"></a> [encryption](#output\_encryption)

Description: contains all exported attributes of the netapp account encryption

### <a name="output_snapshot_policies"></a> [snapshot\_policies](#output\_snapshot\_policies)

Description: contains all exported attributes of the netapp snapshot policies

### <a name="output_volume_group_oracles"></a> [volume\_group\_oracles](#output\_volume\_group\_oracles)

Description: contains all exported attributes of the netapp volume group oracles

### <a name="output_volume_group_sap_hanas"></a> [volume\_group\_sap\_hanas](#output\_volume\_group\_sap\_hanas)

Description: contains all exported attributes of the netapp volume group sap hanas
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-azure-anf/graphs/contributors).

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-anf/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-anf" />
</a>

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/terraform-azure-anf/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/azure-netapp-files/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/netapp/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/netapp)
