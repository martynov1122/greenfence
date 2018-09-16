#!/bin/bash
# Purpose of this file is to make CircleCI fail when a
# Heroku Run command (which does not return a return value) fails and has
# an error code. Clearly, the deployment has failed then.

buffer_file=/tmp/last_heroku_run

heroku run $1 --app $2 | tee $buffer_file

# Heroku adds "heroku-command-exit-status: 0" line at the end of the output.
exit `grep heroku-command-exit-status $buffer_file | cut -d':' -f2`

# Run with heroku_run 'SOME_COMMAND' HEROKU_APP_NAME

