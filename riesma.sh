#=== RIESMA

#== Add to root shell config file
# export RVA="/Users/richard/.riesh"
# source $RVA/riesma.sh


#== Shell styles for echo prints
RESET="\033[0m"
# BOLD="\033[1m"
# UNBOLD="\033[21m"
# IND="s/^/   /" # Usage: ` | sed ${IND}`

DEFAULT="\033[0;39m"
# BLACK="\033[30m"
# RED="\033[31m"
GREEN="\033[0;32m"
# YELLOW="\033[33m"
# BLUE="\033[34m"
# PURPLE="\033[35m"
CYAN="\033[1;36m"
GREY="\033[0;90m"
WHITE="\033[0;97m"


#== Aliasses
alias by='bundle && yarn'
alias db='bundle exec rails db:migrate'
alias gco='git checkout'
alias gf='git fetch --prune'
alias gfp='git fetch --prune && git pull'
alias gst='git status'
alias loc='bin/locales'
alias pull='git pull'
alias push='git push'
alias rs='bundle exec rails s'
alias ws='bin/webpack-dev-server'
alias wp='bin/webpack'
alias feupd='yarn add eslint postcss postcss-scss prettier stylelint stylelint-config-recess-order stylelint-config-recommended stylelint-config-recommended-scss stylelint-config-standard stylelint-config-standard-scss stylelint-order stylelint-scss'


#== Switch to branch and update everything
setup() {
  if [[ "$1" != "" ]]; then
    branch=$1
  else
    branch=$(getCurrentBranch)
  fi

  cd ~/Sites/traintool/

  echo -e "\n⏳ ${GREEN}◼︎${GREY}◼︎◼︎◼︎◼︎◼︎◼︎${WHITE} Updating ${CYAN}${branch}${WHITE} from remote...${RESET}\n"
  git checkout $1
  git fetch --prune
  git pull
  echo "\n⌛️ Done!\n"

  echo -e "⏳ ${GREEN}◼︎◼︎${GREY}◼︎◼︎◼︎◼︎◼︎${WHITE} Updating ${CYAN}bundles${WHITE}...${RESET}\n"
  bundle install
  echo "\n⌛️ Done!\n"

  echo -e "⏳ ${GREEN}◼︎◼︎◼︎${GREY}◼︎◼︎◼︎◼︎${WHITE} Updating ${CYAN}yarn${WHITE} packages...${RESET}\n"
  yarn install
  echo "\n⌛️ Done!\n"

  echo -e "⏳ ${GREEN}◼︎◼︎◼︎◼︎${GREY}◼︎◼︎◼︎${WHITE} Updating ${CYAN}browserslist${WHITE}...${RESET}\n"
  npx browserslist@latest --update-db
  echo "\n⌛️ Done!\n"

  echo -e "⏳ ${GREEN}◼︎◼︎◼︎◼︎◼︎${GREY}◼︎◼︎${WHITE} Migrating ${CYAN}database${WHITE}...${RESET}\n"
  bundle exec rails db:migrate
  echo "\n⌛️ Done!\n"

  echo -e "⏳ ${GREEN}◼︎◼︎◼︎◼︎◼︎◼︎${GREY}◼︎${WHITE} Cleaning up...${RESET}\n"
  bundle clean --force

  git diff --quiet db/schema.rb; dbs=$?
  if [[ $dbs -eq 1 ]]; then
    echo "Restoring db/schema.rb"
    git restore db/schema.rb
  fi
  echo "\n⌛️ Done!\n"

  git status
  echo -e "\n🌴 ${GREEN}◼︎◼︎◼︎◼︎◼︎◼︎◼︎ Finished!${RESET}\n"
}


#== branch=branch_name cap staging deploy
staging() {
  if [[ "$1" != "" ]]; then
    branch=$1
  else
    branch=$(getCurrentBranch)
  fi

  echo -e "\n⏳ ${WHITE}Deploying ${CYAN}${branch}${WHITE} to staging...${RESET}\n"
  branch=$branch bundle exec cap staging deploy
  echo -e "\n🌴 ${GREEN}Finished!${RESET}\n"
}


getCurrentBranch() {
  local  _branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  echo "$_branch"
}
