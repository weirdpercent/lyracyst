# Based on bureau, nebirhos and wezm+
# ➜[ruby-ver@gemset]➜[node-ver]➜[git-branch]➜(yellow ✗ for dirty)                                                        right-aligned working dir

# Get the current ruby version in use with RVM:
if [ -e ~/.rvm/bin/rvm-prompt ]; then
    RUBY_PROMPT_="%{$fg_bold[blue]%}[%{$fg[green]%}\$(~/.rvm/bin/rvm-prompt s i v g)%{$fg_bold[blue]%}]➜%{$reset_color%}"
fi
ZSH_THEME_NVM_PROMPT_PREFIX="%B⬡%b "
ZSH_THEME_NVM_PROMPT_SUFFIX=""
HOST_PROMPT_="%{$fg_bold[blue]%}➜%{$reset_color%}"
NVM_PROMPT_="%{$fg_bold[blue]%}[%{$fg_bold[green]%}$(nvm_prompt_info)%{$fg_bold[blue]%}]➜%{$reset_color%}"
GIT_PROMPT="%{$fg_bold[blue]%}\$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}"
PROMPT="$HOST_PROMPT_$RUBY_PROMPT_$NVM_PROMPT_$GIT_PROMPT"
RPROMPT='%{$fg_bold[cyan]%}%~%{$reset_color%}'
ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}]➜%{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}]➜"
