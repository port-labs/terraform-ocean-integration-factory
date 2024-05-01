terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.25.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 5.25.0"
    }
  }
}

provider "google-beta" {
  user_project_override = true
}
provider "google" {
  user_project_override = true
}
