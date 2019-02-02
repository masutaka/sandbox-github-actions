workflow "issues" {
  on       = "issues"
  resolves = ["Add an issue to project"]
}

workflow "pull_requests" {
  on       = "pull_request"
  resolves = ["Hello World"]
}

action "Add an issue to project" {
  uses = "./.github/project"

  secrets = ["GITHUB_TOKEN"]

  env = {
    PROJECT_NUMBER      = "2"
    INITIAL_COLUMN_NAME = "To do"
  }

  args = ["issue"]
}

action "Add a pull_request to project" {
  uses = "./.github/project"

  secrets = ["GITHUB_TOKEN"]

  env = {
    PROJECT_NUMBER      = "2"
    INITIAL_COLUMN_NAME = "To do"
  }

  args = ["pull_request"]
}
