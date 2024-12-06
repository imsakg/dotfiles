# EXPORTS
export BAT_THEME="Visual Studio Dark+"
export BUN_INSTALL="$HOME/.bun"
export CHROME_EXECUTABLE="/Applications/Vivaldi.app/Contents/MacOS/Vivaldi"
export CLICOLOR=1
export COLORTERM=truecolor
export DENO_INSTALL="/Users/msa/.deno"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export EDITOR=nvim
export FZF_DEFAULT_OPTS="--preview 'bat --color=always {}'"
export GIT_EDITOR=nvim
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export SKIM_DEFAULT_OPTIONS="--preview 'bat --color=always {}'"
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export JAVA_HOME=$(/usr/libexec/java_home)
# Prefer US English and use UTF-8
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
# Don’t clear the screen after quitting a manual page
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export RUSTC_WRAPPER=sccache
export shell="$(which zsh)";
export SHELL="$shell";
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export TERM="xterm-256color"
export TERMINAL="wezterm";
export TODOTXT_DEFAULT_ACTION=ls
export VISUAL=nvim
export ZSH="$HOME/.oh-my-zsh"
export ZOXIDE_CMD_OVERRIDE="cd"


zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

setopt APPEND_HISTORY
setopt AUTO_CD
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt BEEP
setopt EXTENDED_GLOB
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt INTERACTIVE_COMMENTS
setopt GLOB_DOTS
setopt MENU_COMPLETE
setopt NOMATCH
setopt SHARE_HISTORY             # Share history between all sessions.
unsetopt BEEP

HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# Alt + Arrow key to move between words
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

list-directories-sk() {
    LBUFFER="${LBUFFER}$(fd --hidden | sk -m --multi --preview "eza -l --icons --octal-permissions --color=always {}")"
    local ret=$?
    zle reset-prompt
    return $ret

}
zle     -N   list-directories-sk
bindkey '^h'  list-directories-sk

# OMZ Plugins
plugins=(
        alias-finder
        aliases
        autopep8
        bun
        colored-man-pages
        colorize
        command-not-found
        copybuffer
        copyfile
        copypath
        direnv
        docker
        dotnet
        encode64
        extract
        eza
        fancy-ctrl-z
        fast-syntax-highlighting
        # fnm
        fzf
        gh
        git
        gitignore
        gnu-utils
        golang
        gpg-agent
        history
        httpie
        isodate
        jump
        lol
        node
        npm
        pep8
        percol
        poetry
        redis-cli
        rsync
        rust
        screen
        ssh
        systemd
        thefuck
        torrent
        urltools
        urltools
        vscode
        zoxide
        fzf-tab
        zsh-autosuggestions
)

# Sources
# MISC
source /etc/profile
[ -f .aliases ] && source .aliases
[ -f .env ] && source .env

# Set homebrew by architecture
if [[ $(uname) == "Darwin" ]]; then
        if [ "$(arch)" = "arm64" ]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
                export FPATH="$(/opt/homebrew/bin/brew --prefix)/share/zsh/site-functions:${FPATH}"
        else
                export FPATH="$(/usr/local/bin/brew --prefix)/share/zsh/site-functions:${FPATH}"
                eval "$(/usr/local/bin/brew shellenv)"
        fi
fi

# Load OMZ
[ -f $ZSH/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh

source /Users/msa/.config/broot/launcher/bash/br
[[ $- == *i* ]] && source "/opt/homebrew/opt/sk/share/zsh/site-functions/completion.zsh" 2> /dev/null
source "/opt/homebrew/opt/sk/share/zsh/site-functions/key-bindings.zsh"

# Prompt
eval "$(starship init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
# eval "$(fnm env --use-on-cd)"
eval "$(ngrok completion)"
eval "$(procs --gen-completion-out zsh)"
eval "$(sqlx completions zsh)"
eval "$(wezterm shell-completion --shell zsh)"

# ALIAS
alias c='clear'
alias e='exit'

alias calc="numbat"

# broot
alias br='broot -dhp --sizes'

# Colorize grep output (good for log files)
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# sk, rg, fd
alias skvi='f(){ x="$(sk --bind "ctrl-p:toggle-preview" --ansi --preview-window=up:50%:hidden)"; [[ $? -eq 0 ]] && nvim "$x" || true }; f'
alias rgvi='f(){ x="$(sk --bind "ctrl-p:toggle-preview" --ansi -i -c "rg --color=always --line-number \"{}\"" --preview="preview.sh -v {}" --preview-window=up:50%:hidden)"; [[ $? -eq 0 ]] && nvim "$(echo $x|cut -d: -f1)" "+$(echo $x|cut -d: -f2)" || true }; f'

# diffing
alias gitdiff="git difftool --no-symlinks --dir-diff"

# docker
# docker interact
alias dri="docker run --rm -i -t --env TERM=xterm-color "

# |======  LS replaement  ======|
alias la='eza -a --icons --git --octal-permissions --color=always --no-permissions --group-directories-first'  # all files and dirs
alias ll='eza --total-size -l --icons --git --octal-permissions --color=always --no-permissions --group-directories-first'  # long format
alias lt='eza -aT --icons --git --octal-permissions --color=always --no-permissions --group-directories-first' # tree listing
alias l.='eza -a --icons --git --octal-permissions | egrep "^\."'
alias ls='eza -l --icons --git --octal-permissions --color=always --no-permissions --group-directories-first' # my preferred listing

alias df="duf"
alias du="dust"
alias imgcat="wezterm imgcat"
alias ping="gping"

# |======  Bat for man pages  ======|
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
# alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'

alias cat='bat -n -p'

# |======  Zellij  ======|
alias j='z'
alias zel="zellij"
alias zeldev="zellij --layout ~/.config/zellij/layouts/dev.kdl"

# esp idf
alias get_idf='. $HOME/esp/esp-idf/export.sh'

# gpg encryption
# verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

# git
alias addall='git add .'
alias addup='git add -u'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'
alias ghrw="gh repo view --web"
alias aigc='OPENAI_BASE_URL=http://localhost:11434/v1 OPENAI_API_KEY=ollama aicommit -m qwen2.5-coder:7b'
alias aigcr='OPENAI_BASE_URL=http://localhost:11434/v1 OPENAI_API_KEY=ollama aicommit -m qwen2.5-coder:7b -a'

# kitty
alias d="kitty +kitten diff"

# Binary Tools
alias ldd="otool -L"
alias nm="otool -tV"
alias strings="strings -"

# parallel
alias webp2png="parallel dwebp {} -o {.}.png ::: *.webp"

# termbin
alias pastebin="nc termbin.com 9999"

# List Embedded Devices
alias probes="probe-rs info"

# youtube-dl -> yt-dlp
alias yta-aac="yt-dlp --extract-audio --audio-format aac"
alias yta-best="yt-dlp --extract-audio --audio-format best"
alias yta-flac="yt-dlp --extract-audio --audio-format flac"
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3"
alias yta-wav="yt-dlp --extract-audio --audio-format wav"
alias ytv-best="yt-dlp -f bestvideo+bestaudio"

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias dirs='dirs -v'

# other aliases
alias bunrd="bun run dev"
alias bunrdo="bun run dev -- --open"
alias cargo-update-bin='cargo install --locked $(cargo install --list | egrep "^[a-z0-9_-]+ v[0-9.]+:$" | cut -f1 -d" ")'
alias cg='cargo'
alias nv="nvim ."
alias n=nvim
alias sql="sqlite3"
alias python=python3
alias uvpip='uv pip'
alias uvv='uv venv && source venv/bin/activate'
alias venv="source .venv/bin/activate"

# get top process eating cpu ##
alias pscpu='ps aux | sort -nr -k 3'
alias pscpu10='ps aux | sort -nr -k 3 | head -10'

## get top process eating memory
alias psmem='ps aux | sort -nr -k 4'
alias psmem10='ps aux | sort -nr -k 4 | head -10'

# wheather
alias wheather="curl -Ss  --ipv4 'https://wttr.in'"

# Remove unwanted aliases
unalias tldr
unalias yolo

# FUNCTIONS
docker-ip() {
  docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}

execute_every() {
    # call: execute_every <interval> <command>
    while true; do
        "${@:2}";
        sleep $1;
    done
}

# helix theme switcher
hx-choose-theme () {
  chosen_theme=$(/usr/bin/ls ~/.config/helix/themes | grep -v "chosen_theme.toml" | fzf --height=~15% --border=double)

  cp ~/.config/helix/themes/$chosen_theme ~/.config/helix/themes/chosen_theme.toml > /dev/null 2>&1
}

mcd() {
  mkdir -p "$1" && cd "$1"
}

set_java_version() {
    if [[ -z "$1" ]]; then
        echo "Usage: set_java_version <version>"
        return 1
    fi

    if [[ "$1" == "-l" ]]; then
        /usr/libexec/java_home -V
        return 0
    fi

    if [[ "$1" == "-h" ]]; then
        echo "Usage: set_java_version <version>"
        echo "List installed versions: set_java_version -l"
        return 0
    fi

    JAVA_VERSION="$1"
    export JAVA_HOME=$(/usr/libexec/java_home -v "$JAVA_VERSION")
    
    if [[ -z "$JAVA_HOME" ]]; then
        echo "Java version $JAVA_VERSION not found."
        return 1
    fi

    java -version
}

export PATH="$HOME/.local/bin:\
$BUN_INSTALL/bin:\
$HOME/go/bin:\
$DENO_INSTALL/bin:\
$HOME/.dotnet/tools:\
$HOME/.cargo/bin:\
/opt/homebrew/opt/qt@5/bin:\
/opt/homebrew/opt/qt@6/bin:\
/opt/homebrew/opt/ruby/bin:\
/opt/homebrew/opt/binutils/bin:\
/opt/homebrew/opt/bison/bin:\
/opt/homebrew/opt/gawk/libexec/gnubin:\
/opt/homebrew/opt/gnu-getopt/bin:\
/opt/homebrew/opt/gnu-tar/libexec/gnubin:\
/opt/homebrew/opt/gnu-sed/libexec/gnubin:\
/opt/homebrew/opt/make/libexec/gnubin:\
/opt/homebrew/opt/texinfo/bin:\
/usr/local/bin:\
/usr/bin:\
/usr/local/sbin:\
$PATH"


