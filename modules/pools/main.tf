resource "azurerm_netapp_backup_vault" "this" {
  for_each = lookup(
    var.config, "backup_vaults", {}
  )

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


  name = coalesce(
    each.value.name, each.key
  )

  account_name = var.account_name
  tags         = each.value.tags
}

resource "azurerm_netapp_backup_policy" "this" {
  for_each = merge([
    for vault_key, vault in lookup(var.config, "backup_vaults", {}) : {
      for policy_key, policy in lookup(vault, "backup_policies", {}) :
      "${vault_key}.${policy_key}" => merge(policy, { vault_key = vault_key })
    }
  ]...)

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
    each.value.name, element(split(".", each.key), 1)
  )

  account_name            = var.account_name
  daily_backups_to_keep   = each.value.daily_backups_to_keep
  enabled                 = each.value.enabled
  monthly_backups_to_keep = each.value.monthly_backups_to_keep
  weekly_backups_to_keep  = each.value.weekly_backups_to_keep
  tags                    = each.value.tags
}

resource "azurerm_netapp_pool" "this" {
  for_each = lookup(
    var.config, "pools", {}
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

  account_name            = var.account_name
  service_level           = each.value.service_level
  size_in_tb              = each.value.size_in_tb
  cool_access_enabled     = each.value.cool_access_enabled
  custom_throughput_mibps = each.value.custom_throughput_mibps
  encryption_type         = each.value.encryption_type
  qos_type                = each.value.qos_type
  tags                    = each.value.tags
}

resource "azurerm_netapp_volume" "this" {
  for_each = merge([
    for pool_key, pool in lookup(var.config, "pools", {}) : {
      for volume_key, volume in lookup(pool, "volumes", {}) :
      "${pool_key}.${volume_key}" => merge(volume, { pool_key = pool_key })
    }
  ]...)

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
    each.value.name, element(split(".", each.key), 1)
  )

  account_name                                         = var.account_name
  pool_name                                            = azurerm_netapp_pool.this[each.value.pool_key].name
  volume_path                                          = each.value.volume_path
  service_level                                        = each.value.service_level
  subnet_id                                            = each.value.subnet_id
  storage_quota_in_gb                                  = each.value.storage_quota_in_gb
  protocols                                            = each.value.protocols
  security_style                                       = each.value.security_style
  network_features                                     = each.value.network_features
  zone                                                 = each.value.zone
  snapshot_directory_visible                           = each.value.snapshot_directory_visible
  throughput_in_mibps                                  = each.value.throughput_in_mibps
  encryption_key_source                                = each.value.encryption_key_source
  key_vault_private_endpoint_id                        = each.value.key_vault_private_endpoint_id
  kerberos_enabled                                     = each.value.kerberos_enabled
  large_volume_enabled                                 = each.value.large_volume_enabled
  azure_vmware_data_store_enabled                      = each.value.azure_vmware_data_store_enabled
  create_from_snapshot_resource_id                     = each.value.create_from_snapshot_resource_id
  accept_grow_capacity_pool_for_short_term_clone_split = each.value.accept_grow_capacity_pool_for_short_term_clone_split
  smb3_protocol_encryption_enabled                     = each.value.smb3_protocol_encryption_enabled
  smb_access_based_enumeration_enabled                 = each.value.smb_access_based_enumeration_enabled
  smb_continuous_availability_enabled                  = each.value.smb_continuous_availability_enabled
  smb_non_browsable_enabled                            = each.value.smb_non_browsable_enabled
  tags                                                 = each.value.tags

  dynamic "cool_access" {
    for_each = each.value.cool_access != null ? [each.value.cool_access] : []

    content {
      coolness_period_in_days = cool_access.value.coolness_period_in_days
      retrieval_policy        = cool_access.value.retrieval_policy
      tiering_policy          = cool_access.value.tiering_policy
    }
  }

  dynamic "data_protection_backup_policy" {
    for_each = each.value.data_protection_backup_policy != null ? [each.value.data_protection_backup_policy] : []

    content {
      backup_vault_id  = azurerm_netapp_backup_vault.this[data_protection_backup_policy.value.backup_vault_key].id
      backup_policy_id = azurerm_netapp_backup_policy.this["${data_protection_backup_policy.value.backup_vault_key}.${data_protection_backup_policy.value.backup_policy_key}"].id
      policy_enabled   = data_protection_backup_policy.value.policy_enabled
    }
  }

  dynamic "data_protection_replication" {
    for_each = each.value.data_protection_replication != null ? [each.value.data_protection_replication] : []

    content {
      endpoint_type             = data_protection_replication.value.endpoint_type
      remote_volume_location    = data_protection_replication.value.remote_volume_location
      remote_volume_resource_id = data_protection_replication.value.remote_volume_resource_id
      replication_frequency     = data_protection_replication.value.replication_frequency
    }
  }

  dynamic "data_protection_snapshot_policy" {
    for_each = each.value.data_protection_snapshot_policy != null ? [each.value.data_protection_snapshot_policy] : []

    content {
      snapshot_policy_id = data_protection_snapshot_policy.value.snapshot_policy_id
    }
  }

  dynamic "export_policy_rule" {
    for_each = each.value.export_policy_rule != null ? each.value.export_policy_rule : {}

    content {
      rule_index                     = export_policy_rule.value.rule_index
      allowed_clients                = export_policy_rule.value.allowed_clients
      protocol                       = export_policy_rule.value.protocol
      unix_read_only                 = export_policy_rule.value.unix_read_only
      unix_read_write                = export_policy_rule.value.unix_read_write
      root_access_enabled            = export_policy_rule.value.root_access_enabled
      kerberos_5_read_only_enabled   = export_policy_rule.value.kerberos_5_read_only_enabled
      kerberos_5_read_write_enabled  = export_policy_rule.value.kerberos_5_read_write_enabled
      kerberos_5i_read_only_enabled  = export_policy_rule.value.kerberos_5i_read_only_enabled
      kerberos_5i_read_write_enabled = export_policy_rule.value.kerberos_5i_read_write_enabled
      kerberos_5p_read_only_enabled  = export_policy_rule.value.kerberos_5p_read_only_enabled
      kerberos_5p_read_write_enabled = export_policy_rule.value.kerberos_5p_read_write_enabled
    }
  }
}

resource "azurerm_netapp_snapshot" "this" {
  for_each = merge([
    for pool_key, pool in lookup(var.config, "pools", {}) : merge([
      for volume_key, volume in lookup(pool, "volumes", {}) : {
        for snapshot_key, snapshot in lookup(volume, "snapshots", {}) :
        "${pool_key}.${volume_key}.${snapshot_key}" => merge(snapshot, {
          pool_key   = pool_key
          volume_key = "${pool_key}.${volume_key}"
        })
      }
    ]...)
  ]...)

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
    each.value.name, element(split(".", each.key), 2)
  )

  account_name = var.account_name
  pool_name    = azurerm_netapp_pool.this[each.value.pool_key].name
  volume_name  = azurerm_netapp_volume.this[each.value.volume_key].name
}

resource "azurerm_netapp_volume_quota_rule" "this" {
  for_each = merge([
    for pool_key, pool in lookup(var.config, "pools", {}) : merge([
      for volume_key, volume in lookup(pool, "volumes", {}) : {
        for rule_key, rule in lookup(volume, "quota_rules", {}) :
        "${pool_key}.${volume_key}.${rule_key}" => merge(rule, {
          volume_key = "${pool_key}.${volume_key}"
        })
      }
    ]...)
  ]...)

  location = coalesce(
    lookup(
      each.value, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.name, element(split(".", each.key), 2)
  )

  volume_id         = azurerm_netapp_volume.this[each.value.volume_key].id
  quota_size_in_kib = each.value.quota_size_in_kib
  quota_type        = each.value.quota_type
  quota_target      = each.value.quota_target
}
