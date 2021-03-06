pid_file = "./pidfile"

vault {
  address = "http://vault_s1:8200"
}

auto_auth {
  method {
    type = "approle"

    config = {
      role_id_file_path = "/vault-agent/role_id"
      secret_id_file_path = "/vault-agent/secret_id"
      remove_secret_id_file_after_reading = false
    }
  }

  sink {
    type = "file"
    config = {
      path = "/vault-agent/token"
    }
  }
}

template {
  source = "/vault-agent/postgres.tpl"
  destination = "/usr/share/nginx/html/index.html"
}

template {
  source = "/vault-agent/kv.tpl"
  destination = "/vault-agent/postgres2kv.sh"
  command = "/vault-agent/kv-cmd.sh"
}