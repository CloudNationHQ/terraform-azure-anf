output "backup_vaults" {
  description = "contains all exported attributes of the netapp backup vaults"
  value       = azurerm_netapp_backup_vault.this
}

output "backup_policies" {
  description = "contains all exported attributes of the netapp backup policies"
  value       = azurerm_netapp_backup_policy.this
}

output "pools" {
  description = "contains all exported attributes of the netapp pools"
  value       = azurerm_netapp_pool.this
}

output "volumes" {
  description = "contains all exported attributes of the netapp volumes"
  value       = azurerm_netapp_volume.this
}

output "snapshots" {
  description = "contains all exported attributes of the netapp snapshots"
  value       = azurerm_netapp_snapshot.this
}

output "quota_rules" {
  description = "contains all exported attributes of the netapp volume quota rules"
  value       = azurerm_netapp_volume_quota_rule.this
}
