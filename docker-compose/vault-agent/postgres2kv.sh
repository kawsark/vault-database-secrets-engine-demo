vault kv put ${KV_PATH} username=v-approle-INFOSEC--iYxBUOuKIwkVRjqVxAN3-1621443169 password=-hNO4umW6bn6sZ-hWE4o
vault kv get ${KV_PATH} >> /usr/share/nginx/html/previous.txt
echo "" >> /usr/share/nginx/html/previous.txt