# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

Our root module structure is as follows:

```
PROJECT_ROOT
|
├── main.tf                 # everything else
├── variables.tf            # stores the structure of input variables
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defines required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables

In Terraform we can set two kind of variables:
- Environment Variables - those that you would set in your bash terminal eg. AWS credentials
- Terraform Variables - those that you would normally set in your tfvars file

We can set Terraform Cloud variables to be sensitive so they are not shown visibly in the UI.

### Loading Terraform Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag

We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_uiid="my-user_id"`

### var-file flag

This flag can be used to pass input variable values into Terraform `plan` and `apply` commands, using the file that contains these values. We can save input variable values in a file with a `.tfvars` extension and then this can be checked into source control for our variable environments we need to deploy to / manage. Multiple `-var-file` flags can be used on the same Terraform command to pass in multiple `.tfplans` if necessary.

### terraform.tfvars

This is the default file to load in Terraform variables in bulk.

### auto.tfvars

Terraform has the ability to automatically pull in `.tfvars` files. This funcionality is based on the following file names and pattern:

- Files named exactly `terraform.tfvars` or `terraform.tfvars.json`
- Any files with names ending in `.auto.tfvars` or `.auto.tfvars.json`

### Order of Terraform variables

The order of precedence for variable sources is as follows with later sources taking precedence over earlier ones:

1. Environment variables (TF_VAR_variable_name)

2. The terraform.tfvars file, if present.

3. The terraform.tfvars.json file, if present.

4. Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.

5. Any -var and -var-file options on the command line, in the order they are provided.