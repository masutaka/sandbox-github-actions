workflow "issues" {
  on       = "issues"
  resolves = ["Add an issue to project"]
}

# workflow "New workflow2" {
#   on       = "pull_request"
#   resolves = ["Hello World"]
# }

action "Add an issue to project" {
  uses = "./.github/project"

  secrets = ["GITHUB_TOKEN"]

  env = {
    PROJECT_NUMBER      = "2"
    INITIAL_COLUMN_NAME = "To do"
  }

  args = ["hoge", "fuga"]
}
