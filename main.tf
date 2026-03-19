resource "azurerm_netapp_account" "this" {
  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(
      var.config, "location", null
    ), var.location
  )

  tags = coalesce(
    var.config.tags, var.tags
  )

  name = var.config.name

  dynamic "active_directory" {
    for_each = var.config.active_directory != null ? [var.config.active_directory] : []

    content {
      aes_encryption_enabled            = active_directory.value.aes_encryption_enabled
      dns_servers                       = active_directory.value.dns_servers
      domain                            = active_directory.value.domain
      kerberos_ad_name                  = active_directory.value.kerberos_ad_name
      kerberos_kdc_ip                   = active_directory.value.kerberos_kdc_ip
      ldap_over_tls_enabled             = active_directory.value.ldap_over_tls_enabled
      ldap_signing_enabled              = active_directory.value.ldap_signing_enabled
      local_nfs_users_with_ldap_allowed = active_directory.value.local_nfs_users_with_ldap_allowed
      organizational_unit               = active_directory.value.organizational_unit
      password                          = active_directory.value.password
      server_root_ca_certificate        = active_directory.value.server_root_ca_certificate
      site_name                         = active_directory.value.site_name
      smb_server_name                   = active_directory.value.smb_server_name
      username                          = active_directory.value.username
    }
  }

  dynamic "identity" {
    for_each = var.config.identity != null ? [var.config.identity] : []

    content {
      identity_ids = identity.value.identity_ids
      type         = identity.value.type
    }
  }
}

resource "azurerm_netapp_account_encryption" "this" {
  for_each = var.config.encryption != null ? { "default" = var.config.encryption } : {}

  netapp_account_id                     = azurerm_netapp_account.this.id
  encryption_key                        = each.value.encryption_key
  system_assigned_identity_principal_id = each.value.system_assigned_identity_principal_id
  user_assigned_identity_id             = each.value.user_assigned_identity_id
  federated_client_id                   = each.value.federated_client_id
  cross_tenant_key_vault_resource_id    = each.value.cross_tenant_key_vault_resource_id
}

resource "azurerm_netapp_snapshot_policy" "this" {
  for_each = lookup(
    var.config, "snapshot_policies", {}
  )

  name = coalesce(
    each.value.name, each.key
  )

  resource_group_name = azurerm_netapp_account.this.resource_group_name
  location            = azurerm_netapp_account.this.location
  account_name        = azurerm_netapp_account.this.name
  enabled             = each.value.enabled
  tags                = each.value.tags

  dynamic "daily_schedule" {
    for_each = each.value.daily_schedule != null ? [each.value.daily_schedule] : []

    content {
      hour              = daily_schedule.value.hour
      minute            = daily_schedule.value.minute
      snapshots_to_keep = daily_schedule.value.snapshots_to_keep
    }
  }

  dynamic "hourly_schedule" {
    for_each = each.value.hourly_schedule != null ? [each.value.hourly_schedule] : []

    content {
      minute            = hourly_schedule.value.minute
      snapshots_to_keep = hourly_schedule.value.snapshots_to_keep
    }
  }

  dynamic "monthly_schedule" {
    for_each = each.value.monthly_schedule != null ? [each.value.monthly_schedule] : []

    content {
      days_of_month     = monthly_schedule.value.days_of_month
      hour              = monthly_schedule.value.hour
      minute            = monthly_schedule.value.minute
      snapshots_to_keep = monthly_schedule.value.snapshots_to_keep
    }
  }

  dynamic "weekly_schedule" {
    for_each = each.value.weekly_schedule != null ? [each.value.weekly_schedule] : []

    content {
      days_of_week      = weekly_schedule.value.days_of_week
      hour              = weekly_schedule.value.hour
      minute            = weekly_schedule.value.minute
      snapshots_to_keep = weekly_schedule.value.snapshots_to_keep
    }
  }
}

resource "azurerm_netapp_volume_group_oracle" "this" {
  for_each = lookup(
    var.config, "volume_group_oracles", {}
  )

  resource_group_name = coalesce(
    lookup(
      each.value, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(
      each.value, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.name, each.key
  )

  account_name           = azurerm_netapp_account.this.name
  application_identifier = each.value.application_identifier
  group_description      = each.value.group_description

  dynamic "volume" {
    for_each = each.value.volume != null ? each.value.volume : {}

    content {
      capacity_pool_id              = volume.value.capacity_pool_id
      name                          = volume.value.name
      protocols                     = volume.value.protocols
      security_style                = volume.value.security_style
      service_level                 = volume.value.service_level
      snapshot_directory_visible    = volume.value.snapshot_directory_visible
      storage_quota_in_gb           = volume.value.storage_quota_in_gb
      subnet_id                     = volume.value.subnet_id
      throughput_in_mibps           = volume.value.throughput_in_mibps
      volume_path                   = volume.value.volume_path
      volume_spec_name              = volume.value.volume_spec_name
      proximity_placement_group_id  = volume.value.proximity_placement_group_id
      zone                          = volume.value.zone
      network_features              = volume.value.network_features
      encryption_key_source         = volume.value.encryption_key_source
      key_vault_private_endpoint_id = volume.value.key_vault_private_endpoint_id
      tags                          = volume.value.tags

      dynamic "data_protection_replication" {
        for_each = volume.value.data_protection_replication != null ? [volume.value.data_protection_replication] : []

        content {
          endpoint_type             = data_protection_replication.value.endpoint_type
          remote_volume_location    = data_protection_replication.value.remote_volume_location
          remote_volume_resource_id = data_protection_replication.value.remote_volume_resource_id
          replication_frequency     = data_protection_replication.value.replication_frequency
        }
      }

      dynamic "data_protection_snapshot_policy" {
        for_each = volume.value.data_protection_snapshot_policy != null ? [volume.value.data_protection_snapshot_policy] : []

        content {
          snapshot_policy_id = data_protection_snapshot_policy.value.snapshot_policy_id
        }
      }

      dynamic "export_policy_rule" {
        for_each = volume.value.export_policy_rule != null ? volume.value.export_policy_rule : {}

        content {
          allowed_clients     = export_policy_rule.value.allowed_clients
          nfsv3_enabled       = export_policy_rule.value.nfsv3_enabled
          nfsv41_enabled      = export_policy_rule.value.nfsv41_enabled
          root_access_enabled = export_policy_rule.value.root_access_enabled
          rule_index          = export_policy_rule.value.rule_index
          unix_read_only      = export_policy_rule.value.unix_read_only
          unix_read_write     = export_policy_rule.value.unix_read_write
        }
      }
    }
  }

}

resource "azurerm_netapp_volume_group_sap_hana" "this" {
  for_each = lookup(
    var.config, "volume_group_sap_hanas", {}
  )

  resource_group_name = coalesce(
    lookup(
      each.value, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(
      each.value, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.name, each.key
  )

  account_name           = azurerm_netapp_account.this.name
  application_identifier = each.value.application_identifier
  group_description      = each.value.group_description

  dynamic "volume" {
    for_each = each.value.volume != null ? each.value.volume : {}

    content {
      capacity_pool_id              = volume.value.capacity_pool_id
      name                          = volume.value.name
      protocols                     = volume.value.protocols
      security_style                = volume.value.security_style
      service_level                 = volume.value.service_level
      snapshot_directory_visible    = volume.value.snapshot_directory_visible
      storage_quota_in_gb           = volume.value.storage_quota_in_gb
      subnet_id                     = volume.value.subnet_id
      throughput_in_mibps           = volume.value.throughput_in_mibps
      volume_path                   = volume.value.volume_path
      volume_spec_name              = volume.value.volume_spec_name
      proximity_placement_group_id  = volume.value.proximity_placement_group_id
      zone                          = volume.value.zone
      network_features              = volume.value.network_features
      encryption_key_source         = volume.value.encryption_key_source
      key_vault_private_endpoint_id = volume.value.key_vault_private_endpoint_id
      tags                          = volume.value.tags

      dynamic "data_protection_replication" {
        for_each = volume.value.data_protection_replication != null ? [volume.value.data_protection_replication] : []

        content {
          endpoint_type             = data_protection_replication.value.endpoint_type
          remote_volume_location    = data_protection_replication.value.remote_volume_location
          remote_volume_resource_id = data_protection_replication.value.remote_volume_resource_id
          replication_frequency     = data_protection_replication.value.replication_frequency
        }
      }

      dynamic "data_protection_snapshot_policy" {
        for_each = volume.value.data_protection_snapshot_policy != null ? [volume.value.data_protection_snapshot_policy] : []

        content {
          snapshot_policy_id = data_protection_snapshot_policy.value.snapshot_policy_id
        }
      }

      dynamic "export_policy_rule" {
        for_each = volume.value.export_policy_rule != null ? volume.value.export_policy_rule : {}

        content {
          allowed_clients     = export_policy_rule.value.allowed_clients
          nfsv3_enabled       = export_policy_rule.value.nfsv3_enabled
          nfsv41_enabled      = export_policy_rule.value.nfsv41_enabled
          root_access_enabled = export_policy_rule.value.root_access_enabled
          rule_index          = export_policy_rule.value.rule_index
          unix_read_only      = export_policy_rule.value.unix_read_only
          unix_read_write     = export_policy_rule.value.unix_read_write
        }
      }
    }
  }
}
