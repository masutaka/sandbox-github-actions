workflow "issues" {
  on       = "issues"
  resolves = ["Add an issue to project"]
}

workflow "pull_requests" {
  on       = "pull_request"
  resolves = ["Add a pull_request to project"]
}

locals {
  env = {
    PROJECT_NUMBER      = "2"
    INITIAL_COLUMN_NAME = "To do"
  }
}

action "Add an issue to project" {
  uses    = "./.github/project"
  secrets = ["GITHUB_TOKEN"]
  env     = "${local.env}"
  args    = ["issue"]
}

action "Add a pull_request to project" {
  uses    = "./.github/project"
  secrets = ["GITHUB_TOKEN"]
  env     = "${local.env}"
  args    = ["pull_request"]
}
