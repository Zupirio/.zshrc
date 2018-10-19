
# Load Homebrew Fix script
source $HOME/.brew_fix.zsh
export PATH=$HOME/.local/bin:$PATH
export PATH="/goinfre/arangari/.brew/opt/sphinx-doc/bin:/goinfre/arangari/.brew/bin/python3:$PATH"

# Example aliases
alias ga="git add *"
alias gc="git commit -m \""
alias gp="git push origin master"
alias kn="kinit arangari@42.FR"
alias ll="ls -la"


BLACK='\033[0;30m'
RED='\033[0;31;1m'
REDBLINK='\033[0;31m'
GREEN='\033[0;32;1m'
BROWN='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
CYANTITLE='\033[0;36;1;4m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

showLoading() {
	loadingText=$1

	echo -ne "${PURPLE}Pushing $loadingText\r "
	while kill -0 $! &>/dev/null; do
		echo -ne "\r\033[K"
		echo -ne "${PURPLE}Pushing: ${WHITE}$loadingText .\r"
		sleep 0.5
		echo -ne "${PURPLE}Pushing: ${WHITE}$loadingText ..\r"
		sleep 0.5
		echo -ne "${PURPLE}Pushing: ${WHITE}$loadingText ...\r"
		sleep 0.5
		echo -ne "\r\033[K"
		echo -ne "${PURPLE}Pushing: ${WHITE}$loadingText \r"
		sleep 0.5
	done
	echo "${WHITE}"
}

push() {
	echo "${CYAN}Auto commit all files?${WHITE}"
	echo "Press: 1 for ${GREEN}YES${WHITE} and 2 for ${RED}NO${WHITE}"
	select yn in "yes" "no"; do
		case $yn in
			yes ) auto=1; break;;
			no ) auto=0; break;;
		esac
	done
	untracked=(`git ls-files --others --modified --exclude-standard`)
	for i in ${untracked[@]} ; do
		if [[ "$auto" == 1 ]]
		then
			git add $i
			git commit --q -m "auto commit"
			(git push --q origin HEAD & showLoading "$i")
		else
			git add $i
			echo "${PURPLE}Please type commit message for${GREEN} $i ${PURPLE}and press enter${WHITE}"
			read commit
			git commit --q -m ${commit}
			(git push --q origin HEAD & showLoading "$i")
		fi
	done
}

gitall() {
	clear
	echo "\n${CYAN}Are you sure you want to push all files?${WHITE}"
	echo "PRESS: 1 for ${GREEN}YES${WHITE} AND 2 for ${RED}NO${WHITE}\n"
	select yn in "yes" "no"; do
		case $yn in
			yes )
				push
				result=(`git status -s`)
				if [[ -z "$result" ]]
				then
					echo "----------------- ALL FILES ADDED! ------------------"
				else
					git status
					echo "--------------- NOT ALL FILES PUSHED! ---------------"
				fi
				break;;
			no )
				echo "${REDBLINK}aborting...\n";;
		esac
		break;
		echo "${WHITE}"
	done
}

export NVM_DIR="/goinfre/arangari/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
