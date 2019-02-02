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
    INITIAL_COLUMN_ID        = "4281951"         # "To do"
    CLOSED_TARGET_COLUMN_IDS = "4281951,4281952" # "To do", "In progress"
    DONE_COLUMN_ID           = "4281953"         # "Done"
  }

  args = ["hoge", "fuga"]
}
