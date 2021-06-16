{{ with secret "postgres/creds/INFOSEC-dynamic-postgres-app-1234" -}}
<html><head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css" integrity="sha384-B0vP5xmATw1+K9KRQjQERJvTumQW0nPEzvF6L/Z6nronJ3oUOFUFpCjEUQouq2+l" crossorigin="anonymous">
</head><body>
<div class="alert alert-success" role="alert">
<h5 class="alert-heading">Secret path &#58; postgres/creds/INFOSEC-dynamic-postgres-app-1234, Policy &#58; postgres_creds_policy</h5>
    <ul><li><strong>Connection String</strong> &#58; postgresql://{{ .Data.username }}:{{ .Data.password }}@postgres:5432/products</li>
    <li><strong>username</strong> &#58; {{ .Data.username }}</li>
    <li><strong>password</strong> &#58; {{ .Data.password }}</li></ul>
<hr><p class="mb-0">Helpful Vault commands</p>
<pre><code>
vault read postgres/roles/INFOSEC-dynamic-postgres-app-1234
vault read postgres/creds/INFOSEC-dynamic-postgres-app-1234
vault lease renew postgres/creds/INFOSEC-dynamic-postgres-app-1234/lease_id
vault lease revoke postgres/creds/INFOSEC-dynamic-postgres-app-1234/lease_id
vault policy read postgres_creds_policy
</code></pre></div> </body></html>
{{- end }}