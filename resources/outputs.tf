output "vm_admin_password" {
  description = "Administrator password of the Virtual Machine"
  value       = "${format("Pwd1234%s!", random_id.random_password.b64)}"
}