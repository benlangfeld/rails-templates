github_username = ask "What's your github username?"
github_repo_name = ask "What's the github repo name?"

git :remote => "add github git@github.com:#{github_username}/#{github_repo_name}.git", :push => "github master"