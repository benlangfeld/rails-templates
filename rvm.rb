# This depends on the RVM gem...
#
#    gem install rvm
#
# Note that you do not have to install RVM itself via the gem,
# the gem just needs to be present so it can be used here.
#
# Note also that you MUST be using 1.9.2 already on the command
# line when generating your Rails app...
#
#     rvm use 1.9.2

# TODO: check prerequisites
unless Gem.available?("rspec", ">= 2.0.0")
  run "gem install rvm --no-rdoc --no-ri"

  Gem.refresh
  Gem.activate("rvm")
end

require 'rvm'

create_file ".rvmrc" do
<<-END
#!/usr/bin/env bash

ruby_string="ruby-1.9.2"
gemset_name="#{app_name}"

if rvm list strings | grep -q "${ruby_string}" ; then

  # Load or create the specified environment
  if [[ -d "${rvm_path:-$HOME/.rvm}/environments" \
    && -s "${rvm_path:-$HOME/.rvm}/environments/${ruby_string}@${gemset_name}" ]] ; then
    \. "${rvm_path:-$HOME/.rvm}/environments/${ruby_string}@${gemset_name}"
  else
    rvm --create  "${ruby_string}@${gemset_name}"
  fi

  (
    # Ensure that Bundler is installed, install it if it is not.
    if ! command -v bundle ; then
      gem install bundler
    fi

    # Bundle while redcing excess noise.
    bundle | grep -v 'Using' | grep -v 'complete' | sed '/^$/d'
  )&

else

  # Notify the user to install the desired interpreter before proceeding.
  echo "${ruby_string} was not found, please run 'rvm install ${ruby_string}' and then cd back into the project directory."

fi
END
end

run "rvm rvmrc trust"
run "rvm use 1.9.2@#{app_name} --create"
run "rvm 1.9.2@#{app_name}"
run "rvm gemset load #{app_name}"

RVM.gemset_use! app_name
