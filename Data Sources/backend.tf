terraform {
    backend "s3" {
        bucket = "tf-state-poc1"
        key    = "development/terraform_state"
        region = "us-east-2"
    }
}