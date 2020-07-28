creating a sample app shared 

login with azure cli
```
az login
az account set --subscription 'mvd-msdn'
```

deploy resources
```
terraform get
terraform init
terraform apply
```

cleanup resources
```
az group delete --name rg-tb-example1-shared --yes --no-wait
```
