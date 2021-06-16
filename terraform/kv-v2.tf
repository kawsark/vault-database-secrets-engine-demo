resource "vault_mount" "tenant_kv" {
  path        = var.kv_mount_path
  type        = var.kv_version
  description = "Key value secrets engine created by terraform"
}

