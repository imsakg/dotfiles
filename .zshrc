# profiling
# zmodload zsh/zprof

# POWER10K
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#     source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# RPROMPT='[%D{%L:%M:%S}] '$RPROMPT

# OHMYZSH
export ZSH="$HOME/.oh-my-zsh"

# PATHs
# autojump
# [[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh

export PATH="$PATH:$HOME/.local/bin:$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/var/lib/snapd/snap/bin:/usr/lib/jvm/default/bin:$HOME/.local/bin:$HOME/.emacs.d/bin:$HOME/go/bin:$HOME/.dotnet/tools:$HOME/.cargo/bin/:$HOME/.platformio/penv/bin:$HOME/.pub-cache/bin"

# EXPORTS
export ZSH="$HOME/.oh-my-zsh"
export TERM="xterm-256color"                      # getting proper colors
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export EDITOR="nvim"              # $EDITOR use Emacs in terminal
export VISUAL="nvim"           # $VISUAL use Emacs in GUI mode
export BROWSER="brave"           # $BROWSER use Brave as default browser
# export LIBGL_ALWAYS_SOFTWARE=1
# export MESA_GL_VERSION_OVERRIDE=4.6
export CHROME_EXECUTABLE="/usr/bin/brave"
export shell="$(which zsh)";
export SHELL="$shell";
export TERMINAL="alacritty";

export RUSTC_WRAPPER=sccache

export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;
export HISTCONTROL=ignoredups;
# Make some commands not show up in history
export HISTIGNORE=" *:ls:cd:cd -:pwd:exit:date:* --help:* -h:pony:pony add *:pony update *:pony save *:pony ls:pony ls *";

# Prefer US English and use UTF-8
export LANG="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X";
export TODOTXT_DEFAULT_ACTION=ls

# turn on go vendoring experiment
export GO15VENDOREXPERIMENT=1

# rip's grevyard (Trash)
export GRAVEYARD="$HOME/.local/share/Trash/files"
export FZF_DEFAULT_OPTS="--preview 'bat --color=always {}'"

# if it's an ssh session export GPG_TTY
if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    GPG_TTY=$(tty)
    export GPG_TTY
fi

# set xdg data dirs for dmenu to source
export XDG_DATA_DIRS=/usr/share/

GCM_CREDENTIAL_STORE=secretservice
DOTNET_CLI_TELEMETRY_OPTOUT=1

# MISC
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.zplug/init.zsh
source /etc/profile
[ -f .aliases ] && source .aliases
[ -f .env ] && source .env

# ZSHs PLUGINS
plugins=(z fzf history git zsh-syntax-highlighting fast-syntax-highlighting zsh-autosuggestions lol colored-man-pages systemd colorize gitignore aliases alias-finder archlinux autopep8 command-not-found copybuffer copyfile copypath dotnet encode64 gh gnu-utils golang httpie jump isodate node pep8 percol poetry ripgrep redis-cli rsync screen thefuck torrent urltools vscode npm gpg-agent docker autojump rust)

source $ZSH/oh-my-zsh.sh
# FUNCTIONS

function preexec() {
  timer=$(($(date +%s%0N)/1000000))
}

function precmd() {
  if [ $timer ]; then
    now=$(($(date +%s%0N)/1000000))
    elapsed=$(($now-$timer))

    export RPROMPT="%F{cyan}${elapsed}ms %{$reset_color%}"
    unset timer
  fi
}

# EXTRACT
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

function extract {
    if [ -z "$1" ]; then
        # display usage if no parameters given
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    else
        for n in "$@"
        do
            if [ -f "$n" ] ; then
                case "${n%,}" in
                    *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                        tar xvf "$n"       ;;
                    *.lzma)      unlzma ./"$n"      ;;
                    *.bz2)       bunzip2 ./"$n"     ;;
                    *.cbr|*.rar)       unrar x -ad ./"$n" ;;
                    *.gz)        gunzip ./"$n"      ;;
                    *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
                    *.z)         uncompress ./"$n"  ;;
                    *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                        7z x ./"$n"        ;;
                    *.xz)        unxz ./"$n"        ;;
                    *.exe)       cabextract ./"$n"  ;;
                    *.cpio)      cpio -id < ./"$n"  ;;
                    *.cba|*.ace)      unace x ./"$n"      ;;
                    *)
                        echo "extract: '$n' - unknown archive method"
                        return 1
                        ;;
                esac
            else
                echo "'$n' - file does not exist"
                return 1
            fi
        done
    fi
}

function rustc_exec() {
    rustc -o /tmp/"$1" "$1" && /tmp/"$1"
}

function gcc_exec() {
    gcc -Wall -O3 -o /tmp/"$1" "$1" && /tmp/"$1"
}

function g++_exec() {
    g++ -Wall -O3 -o /tmp/"$1" "$1" && /tmp/"$1"
}

# EXPANDTEMP

# expandes temp for big-size compiling
expandTemp() {
    sudo mount -o remount,size="$1"G,noatime /tmp
}


IFS=$SAVEIFS

# ALIAS
alias emacs="emacsclient -c --no-wait -a 'emacs'"
alias emac="emacsclient -nw"
alias doomsync="~/.emacs.d/bin/doom sync"
alias doomdoctor="~/.emacs.d/bin/doom doctor"
alias doomupgrade="~/.emacs.d/bin/doom upgrade"
alias doompurge="~/.emacs.d/bin/doom purge"
# bat
# alias cat='bat'

alias ssh-agent-run="eval '$(ssh-agent -s)'"

# alias for new-term here
alias new-term="kitty &"

# evcxr_repl
alias rust-repl='evcxr'

alias afk="i3exit lock"
alias tmux="zellij"

# kvm vfio
alias win10='virsh --connect=qemu:///system start win10; sleep 13; looking-glass-client -F -S -m 97 -f /dev/kvmfr0 spice:audio=no -k;'
alias win11='virsh --connect=qemu:///system start win11-nvme; sleep 13; looking-glass-client -F -S -m 97 -f /dev/kvmfr0 spice:audio=no -k;'

# diffing
alias gitdiff="git difftool --no-symlinks --dir-diff"
alias d="kitty +kitten diff"

# broot
alias br='broot -dhp --sizes'

# docker
alias dri="docker run --rm -i -t --env TERM=xterm-color "
docker-ip() {
  docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}

# Changing "ls" to "eza"
alias ls='eza -al --icons --git --octal-permissions --color=always --no-permissions --group-directories-first' # my preferred listing
alias la='eza -a --icons --git --octal-permissions --color=always --no-permissions --group-directories-first'  # all files and dirs
alias ll='eza -l --icons --git --octal-permissions --color=always --no-permissions --group-directories-first'  # long format
alias lt='eza -aT --icons --git --octal-permissions --color=always --no-permissions --group-directories-first' # tree listing
alias l.='eza -a --icons --git --octal-permissions | egrep "^\."'

# pacman and yay
alias pacsyu='sudo pacman -Syyu'                 # update only standard pkgs
alias yaysua='yay -Sua --noconfirm'              # update only AUR pkgs (yay)
alias yaysyu='yay -Syu --noconfirm'              # update standard pkgs and AUR pkgs (yay)
alias parsua='paru -Sua --noconfirm'             # update only AUR pkgs (paru)
alias parsyu='paru -Syu --noconfirm'             # update standard pkgs and AUR pkgs (paru)

alias cargo-update-bin='cargo install $(cargo install --list | egrep "^[a-z0-9_-]+ v[0-9.]+:$" | cut -f1 -d" ")'
alias unlock='sudo rm /var/lib/pacman/db.lck'    # remove pacman lock
alias cleanup='sudo pacman -Rns $(pacman -Qtdq) && sudo journalctl --vacuum-time=2d' # remove orphaned packages
alias cleanup-pkg='sudo /usr/bin/rm -rf $HOME/.cache/paru/clone/* /var/cache/pacman/pkg/*'

# bluetoothctl
alias blr='bluetoothctl power off && bluetoothctl power on'
alias blc='bluetoothctl connect'

# get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rmfi='/usr/bin/rm -i -rf'
alias rmf='rip'

# adding flags
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias lynx='lynx -cfg=~/.lynx/lynx.cfg -lss=~/.lynx/lynx.lss -vikeys'
alias vifm='./.config/vifm/scripts/vifmrun'
alias ncmpcpp='ncmpcpp ncmpcpp_directory=$HOME/.config/ncmpcpp/'
alias mocp='mocp -M "$XDG_CONFIG_HOME"/moc -O MOCDir="$XDG_CONFIG_HOME"/moc'
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

memtop() {
    ps -eo size,pid,user,command --sort -size | \
        awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' |\
        cut -d "" -f2 | cut -d "-" -f1
}

## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

# git
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# gpg encryption
# verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

# youtube-dl -> yt-dlp
alias yta-aac="yt-dlp --extract-audio --audio-format aac "
alias yta-best="yt-dlp --extract-audio --audio-format best "
alias yta-flac="yt-dlp --extract-audio --audio-format flac "
alias yta-m4a="yt-dlp --extract-audio --audio-format m4a "
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3 "
alias yta-opus="yt-dlp --extract-audio --audio-format opus "
alias yta-vorbis="yt-dlp --extract-audio --audio-format vorbis "
alias yta-wav="yt-dlp --extract-audio --audio-format wav "
alias ytv-best="yt-dlp -f bestvideo+bestaudio "

# parallel
alias webp2png="parallel dwebp {} -o {.}.png ::: *.webp"

# switch between shells
# I do not recommend switching default SHELL from bash.
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"

# bare git repo alias for dotfiles
alias config="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"

# termbin
alias tb="nc termbin.com 9999"

# the terminal rickroll
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

# Unlock LBRY tips
alias tips='lbrynet txo spend --type=support --is_not_my_input --blocking'

# Thinkorswim
alias tos="~/thinkorswim/thinkorswim"

# force all kakoune windows into one session
alias kak="/usr/bin/kak -c mysession"
alias kaks="/usr/bin/kak -s mysession"
alias kakd="/usr/bin/kak -d -s mysession &"

alias vim=nvim
alias nv="nvim ."
alias cd..="cd .."

alias wheather="curl -Ss  --ipv4 'https://wttr.in'"

alias cryptDrive="rclone mount cryptDrive: /home/msa/Drive --daemon --user-agent mydrive --copy-links --no-gzip-encoding --no-check-certificate --vfs-cache-mode full --dir-cache-time 24h --poll-interval 10s --cache-dir=/home/msa/temp/cache/ --drive-pacer-min-sleep 10ms --drive-pacer-burst 1000 --vfs-cache-max-size 1G --vfs-cache-poll-interval 5m --vfs-read-ahead 2G --bwlimit-file 32M --umask 000"

# xClip
alias setclip="xclip -selection c"
alias getclip="xclip -selection c -o"

# Shity ohMyZSH aliases
unalias tldr

function watchme {
    # call: uberwatch <interval> <command>
    while true; do
        "${@:2}";
        sleep $1;
    done
}

# ZPLUG

zplug "dracula/zsh", as:theme
zplug "zsh-users/zsh-history-substring-search"
zplug "plugins/git",   from:oh-my-zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# helix
alias hx="helix"

hx-choose-theme () {
  chosen_theme=$(/usr/bin/ls ~/.config/helix/themes | grep -v "chosen_theme.toml" | fzf --height=~15% --border=double)

  cp ~/.config/helix/themes/$chosen_theme ~/.config/helix/themes/chosen_theme.toml > /dev/null 2>&1
}

# end of helix

# FIXes

# Suckless Terminal Sucks
bindkey "\033[1~" beginning-of-line
bindkey "\033[4~" end-of-line


export QSYS_ROOTDIR="/home/msa/.cache/paru/clone/quartus-free/pkg/quartus-free-quartus/opt/intelFPGA/21.1/quartus/sopc_builder/bin"

source ~/.zsh_completions
# autoload -U +X bashcompinit && bashcompinit

source /home/msa/.config/broot/launcher/bash/br

# carapace
# export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
# zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
# source <(carapace _carapace)
# zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
# end of carapace

# profiling
# zprof
