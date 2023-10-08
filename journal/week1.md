# Terraform Beginner Bootcamp 2023 - Week 1

## Fixing Tags

[How to delete Local and Remote Tags on Git]https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/

Locally delete a tag
```sh
git tag -d <tag_name>
```

Remotely delete a tag

```sh
git push --delete origin tagname
```

Checkout the commit that you want to retag. Grab the sha from you Github history.

```sh
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```

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

## Dealing with Configuration Drift

## What if we lose our state file?

If you lose your statefile, you most likely have to tear down all your cloud infrastructure manually.

You can use Terraform import but it won't work for all cloud resources. You need to check the Terraform prodivers documentation for resources support import.

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration

If some goes and delete or modifies cloud resources manually through ClickOps.

If we run Terraform plan again it will attempt to put our infrastructure back into the expected state fixing Configuration Drift.

## Fix using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommended to place modules in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module.

The module has to declare these Terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources

Using the source we can import the module from various places eg.:
- locally
- Github
- Terraform Registry

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```

[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation or information about Terraform.

It may likely produce older examples that could be deprecated. Often affecting providers.

## Working with files in Terraform

### Fileexist function

This is a built in Terraform function to check the existence of a file.

```tf
condition = fileexists(var.error_html_filepath)
```

https://developer.hashicorp.com/terraform/language/functions/fileexists

### Filemd5

https://developer.hashicorp.com/terraform/language/functions/filemd5

### Path Variable

In Terraform there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module
[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

```tf
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html
}
```
## Terraform Locals

Locals allows us to define local variables.
It can be very useful when we need to transform data into another format and have it referenced as a variable. 
```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```

[Local Values]https://developer.hashicorp.com/terraform/language/values/locals

## Terraform Data Sources

This allows us to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Sources]https://developer.hashicorp.com/terraform/language/data-sources

## Working with JSON

We use the jsonencode to create the json policy inline in the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```
[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

### Changing the Lifecycle of Resources

[Meta Arguments Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

https://developer.hashicorp.com/terraform/language/resources/terraform-data