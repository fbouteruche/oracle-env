Using Azure with Terraform

# Setup

In order to use the current stack and provision an Oracle Linux 7.4 VM, you
should first perform the steps below:

Make sure the following resources exists and if needed, adapt the `provider.tf`
file:

- `storage_account_name` a storage group name for object storage
- `resource_group_name` a resource group name for the whole stack
- `container_name` the container name for the object storage

Once done, you should be able to provision the resource to use with terraform

```bash
# Connect to AZ from the CLI
az login

# Set a storage account Access Key
export ARM_ACCESS_KEY="XXX"

# Initialize the state file:
terraform init
```

# Create/Delete the configuration

Once done, you should be able to create the set of resources with the command
below:

```bash
terraform apply
```

You should be able to delete them by running the following set of commands:

```bash
terraform destroy
```
