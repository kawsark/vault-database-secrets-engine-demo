{{ with secret "postgres/creds/INFOSEC-dynamic-postgres-app-1234" -}}
vault kv put ${KV_PATH} username={{ .Data.username }} password={{ .Data.password }}
vault kv get ${KV_PATH} >> /usr/share/nginx/html/previous.txt
echo "" >> /usr/share/nginx/html/previous.txt
{{- end }}