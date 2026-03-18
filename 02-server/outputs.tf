output "key_pair_private_key" {
  sensitive = true
  value     = tls_private_key.this.private_key_pem
}

# terraform output -raw key_pair_private_key > nsse-production-key-pair.pem