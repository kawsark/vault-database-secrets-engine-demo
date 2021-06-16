resource "vault_egp_policy" "cidr-check" {
  name = "cidr-check"
  paths = ["*"]
  enforcement_level = "hard-mandatory"

  policy = <<EOT
import "sockaddr"
import "strings"

precond = rule {
    request.operation in ["create", "update", "delete", "read"] and
    strings.has_prefix(request.path, "postgres/")
}

# Requests to come only from our private IP range
cidrcheck = rule {
    sockaddr.is_contained(request.connection.remote_addr, "122.22.3.4/32")
}

# Check the precondition before execute the cidrcheck
main = rule when precond {
    cidrcheck
}
EOT
}