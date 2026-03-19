variable "config" {
  description = "describes netapp account related configuration"
  type = object({
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

  validation {
    condition     = var.config.location != null || var.location != null
    error_message = "location must be provided either in the config object or as a separate variable."
  }

  validation {
    condition     = var.config.resource_group_name != null || var.resource_group_name != null
    error_message = "resource group name must be provided either in the config object or as a separate variable."
  }
}

variable "naming" {
  description = "contains naming convention"
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
