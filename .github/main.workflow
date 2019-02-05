# For issues

workflow "issues" {
  on       = "issues"
  resolves = ["Add an issue to project"]
}

action "Add an issue to project" {
  uses    = "docker://masutaka/github-actions-all-in-one-project"
  secrets = ["GITHUB_TOKEN"]
  args    = ["issue"]

  env = {
    PROJECT_NUMBER      = "2"
    INITIAL_COLUMN_NAME = "To do"
  }
}

# For pull requests

workflow "pull_requests" {
  on       = "pull_request"
  resolves = ["Add a pull_request to project"]
}

action "Add a pull_request to project" {
  uses    = "docker://masutaka/github-actions-all-in-one-project"
  secrets = ["GITHUB_TOKEN"]
  args    = ["pull_request"]

  env = {
    PROJECT_NUMBER      = "2"
    INITIAL_COLUMN_NAME = "To do"
  }
}
