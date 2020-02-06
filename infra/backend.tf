terraform {
  backend "s3" {
    bucket         = "ohr486.terraform" # SET YOUR BUCKET
    key            = "taa.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "tfstate"
    shared_credentials_file = "credentials"
  }
}
