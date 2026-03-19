output "account" {
  description = "contains all exported attributes of the netapp account"
  value       = azurerm_netapp_account.this
}

output "encryption" {
  description = "contains all exported attributes of the netapp account encryption"
  value       = azurerm_netapp_account_encryption.this
}

output "snapshot_policies" {
  description = "contains all exported attributes of the netapp snapshot policies"
  value       = azurerm_netapp_snapshot_policy.this
}

output "volume_group_oracles" {
  description = "contains all exported attributes of the netapp volume group oracles"
  value       = azurerm_netapp_volume_group_oracle.this
}

output "volume_group_sap_hanas" {
  description = "contains all exported attributes of the netapp volume group sap hanas"
  value       = azurerm_netapp_volume_group_sap_hana.this
}
