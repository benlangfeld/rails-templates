github_username = ask "What's your github username?"
github_repo_name = ask "What's the github repo name?"

github_repo_url = "git@github.com:#{github_username}/#{github_repo_name}.git"
github_remote_add_command = "add github #{github_repo_url}"
git :remote => github_remote_add_command, :push => "github master"