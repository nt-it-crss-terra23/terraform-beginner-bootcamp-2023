## Terrahome AWS

```tf
module "home_payday" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.payday_public_path
  assets_path = var.assets_path
}
```

The public directory expects the following:
- index.html
- error html
- assets

All top level files in assets will be copied, but not any subdirectories.