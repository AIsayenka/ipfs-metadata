# NFT Metadata Scraper. Infrastructure
This is IaC configuration for the app

## Prerequisites
- Terraform
- AWS Credentials configured on the machine already

# High Level summary
The general idea is to have the ECS cluster and EC2 ASG at the top level, since we can later add services to them. Ideally they should enclosed into a module for simplicity. But this is more putting everything together quickly. Same goes for RDS and the VPC.

Then we have the `service` module. The module takes care of creating ECR repository for the service Docker images, load balancer creation and ECS service created within the aforementioned ECS cluster.

And the `deployment`. The module configures CodeBuild project, CodeDeploy app and deployment group, S3 bucket for artifacts, CodePipeline configurarion and required IAM Roles and policies. All for a specific service.

Structure:
Root -> `Service` module -> `Deployment` module

Most of the settings are set up through a env tfvars file. In this case it's `./_config/dev.env.tfvars` except for database configuration, which is handled through a shell script (Please, refer to `Step 2` for structure). The idea for the shell script is that we can store the script in some kind of vault like 1Password, so the credentials are not exposed through the ENV tfvars file.

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

### Side Node: ENI Trunking
AWS has the ENI trunking feature ([ref](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/container-instance-eni.html)) which allows to have more ECS tasks deployed onto EC2 instances. You can enable it through setting an account setting (for your root/IAM account) and default setting (for the whole AWS account, if you have enough permissions on the account you are running the CLI commands through). You can do so with the following:
```
aws ecs put-account-setting
--name awsvpcTrunking
--value enabled
--region AWS_REGION

aws ecs put-account-setting-default
--name awsvpcTrunking
--value enabled
--region AWS_REGION
```

## What could've been done better
* Use proper branches and branching strategy where I have each feature in separate branches
* Putting EC2 ASG, ECS cluster and RDS into separate modules. So it would be easier to have multiples if the setup requires it
* Backend on remote with creating the s3 bucket
* more security groups for finer control of the access, rather than 2 ones managed directly from root and passed to the modules (all open and only the VPC), and the ones coming form the referenced modules like ECS Service
* Code structure, could group the parameters better for easier readability
