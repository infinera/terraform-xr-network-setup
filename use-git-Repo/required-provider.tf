terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}


provider "xrcm" {
  username = "xxx"
  password = "xxx"
  host     = "https://x.x.x.x:ABC"
}

