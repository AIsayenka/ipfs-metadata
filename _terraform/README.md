# NFT Metadata Scraper. Infrastructure
This is IaC configuration for the app

## Prerequisites
- Terraform
- AWS Credentials configured on the machine already

## Setup

### Step 1: Initialize terraform
```
terraform init
```

### Step 2: Run shell script
You will need to run a shell script along the lines of
```
export TF_VAR_db_name="postgres"
export TF_VAR_db_username="postgres"
export TF_VAR_db_password="yourpassword"
export TF_VAR_db_port="5432"
export TF_VAR_aws_account_id="AWS_ACCOUNT_ID"
```


### Step 3: Run terraform
Please, note, if you are not using your default AWS profile, please run the following command
```
export AWS_PROFILE="profile_for_ENV_you_are_using_to_deploy_this_infrastructure"
```

Run terraform apply supplying the env variables
```
terraform apply -var-file="./_config/dev.env.tfvars"
```

### Step 4: Connect codestar connection to your github
You need this for the CodePipeline to work, otherwise the source step is not going to work.

* Navigate to AWS Console -> CodePipeline
* On the left side you will see `Settings` -> Connections
* In Conections, you will see a pending connection called `CodeStar-connection`. You will need to click it and then either install an AWS app into your github or select from already created GitHub apps on your account

### Step 5: Run the pipeline
* Navigate to AWS Console -> CodePipeline
* On the left side you will see `Pipeline` -> Pipelines
* Select `ipfs-metadata-codepipeline` (depends on the service name)
* On the right, click `Release Change`
* Wait a couple of minutes for the process to finish