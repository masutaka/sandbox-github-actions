workflow "GitHub Project for issues" {
  on       = "issues"
  resolves = ["Move an issue to GitHub Project"]
}

# workflow "New workflow2" {
#   on       = "pull_request"
#   resolves = ["Hello World"]
# }

action "Move an issue to GitHub Project" {
  uses = "./.github/project"

  secrets = ["GITHUB_TOKEN"]

  env = {
    PROJECT_NUMBER      = "2"
    INITIAL_COLUMN_NAME = "To do"
  }

  args = ["hoge", "fuga"]
}
