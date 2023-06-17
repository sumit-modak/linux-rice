
HISTFILE=$XDG_CONFIG_HOME/zsh/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '.zshrc'

# beeping is annoying
unsetopt BEEP

autoload -Uz compinit
compinit

# End of lines added by compinstall
# ==================================================================== #
# ----------------------------- plugins ------------------------------ #
# ==================================================================== #

function zsh_add_file() {
    [ -f "$ZDOTDIR/$1" ] && source "$ZDOTDIR/$1"
}

function zsh_add_plugin() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then 
        # For plugins
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    else
        git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
    fi
}

function zsh_add_completion() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then 
        # For completions
		completion_file_path=$(ls $ZDOTDIR/plugins/$PLUGIN_NAME/_*)
		fpath+="$(dirname "${completion_file_path}")"
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
    else
        git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
		fpath+=$(ls $ZDOTDIR/plugins/$PLUGIN_NAME/_*)
		rm $ZDOTDIR/.zccompdump
    fi
	completion_file="$(basename "${completion_file_path}")"
	if [ "$2" = true ] && compinit "${completion_file:1}"
}

zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "zsh-users/zsh-completions"


# =================================================================== #
# ----------------------------- prompt ------------------------------ #
# =================================================================== #

# for more info visit https://arjanvandergaag.nl/blog/customize-zsh-prompt-with-vcs-info.html

autoload -U colors && colors
PROMPT="[%{$fg[cyan]%}%~%{$reset_color%}]%(?:%{$fg_bold[green]%} $:%{$fg_bold[red]%} $) "


# ==================================================================== #
# ----------------------------- aliases ------------------------------ #
# ==================================================================== #

alias zsh-update-plugins="find "$ZDOTDIR/plugins" -type d -exec test -e '{}/.git' ';' -print0 | xargs -I {} -0 git -C {} pull -q"
alias imgcat="kitty +kitten icat"
alias lfcd="~/.config/lf/lfcd.sh"
alias ls="ls -lAGhv --color --group-directories-first"
alias pipes="~/.local/bin/pipes"
alias chat-gpt="cd ~/.local/bin && python3 ~/.local/bin/chat-gpt.py && cd $OLDPWD"
