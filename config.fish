set fish_greeting ""
set fish_color_command 2E64FE

set -x EDITOR vim
set -x LC_LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8

# ls colors
set -Ux LSCOLORS Gxfxcxdxbxegedabagacad

# Vagrant
abbr vag="vagrant"
abbr vagup="vagrant up"
abbr vssh="vagrant ssh"

# git
abbr ga="git add"
abbr gc="git commit"
abbr gp="git push"
abbr gup="git pull --rebase"
abbr gm="git merge"
abbr gco="git checkout"
abbr gb="git branch"
abbr gf="git-flow"
abbr g="git"

# pip
abbr pipi="pip install"
abbr spipi="sudo pip install"

# brew
abbr brewin="brew install"
abbr brewup="brew update; and brew upgrade"

# yaourt
abbr yain="yaourt -S"
abbr yareps="yaourt -Ss"
abbr yaupg="yaourt -Syua"
abbr yarem="yaourt -Rns"

# slash
abbr sr="slash run"

# PushBullet
alias nd='pb push -t (hostname -s) "Process exited: $status"'
alias fgnd='fg ; nd'

# systemd
abbr sc="sudo systemctl"
abbr jc="journalctl"

# apt
abbr ai="sudo apt-get install"
abbr adu="sudo apt-get update; and sudo apt-get dist-upgrade"
abbr aar="sudo apt-get autoremove"
abbr apu="sudo apt-get purge"
abbr acs="apt-cache search"

# autojump
[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish
[ -f /usr/share/autojump/autojump.fish ]; and source /usr/share/autojump/autojump.fish

# pyenv
if test -n "$PYENV_ROOT"
  set --universal fish_user_paths $PYENV_ROOT/shims $fish_user_paths
else if [ -d $HOME/.pyenv ]
  set --universal fish_user_paths $HOME/.pyenv/shims $fish_user_paths
end

# virtualenv
set -g VIRTUAL_ENV_DISABLE_PROMPT 1
alias lenv="source .env/bin/activate.fish"
function activate
   source $argv/bin/activate.fish
end

# prompt
function fish_prompt
	if not set -q -g __fish_robbyrussell_functions_defined
    set -g __fish_robbyrussell_functions_defined
    function _git_branch_name
      echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
    end

    function _hostname
      echo (hostname -s)
    end

    function _is_git_dirty
      echo (git status -s --ignore-submodules=dirty ^/dev/null)
    end
  end

  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  set -l user "$red$USER"
  set -l host
  if test -n "$SSH_CONNECTION"
    set host $yellow (hostname -s)
  else
    set host $green (hostname -s)
  end

  set -l virtualenv
  if test -n "$VIRTUAL_ENV"
    set virtualenv $blue" py:(" $yellow (basename (dirname $VIRTUAL_ENV))/(basename $VIRTUAL_ENV) $blue ")"
  end

  set -l cwd $cyan(basename (prompt_pwd))

  if [ (_git_branch_name) ]
    set -l git_branch $red(_git_branch_name)
    set git_info "$blue git:($git_branch$blue)"

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    end
  end

  echo -n -s $user ' ' $host ' ' $cwd $virtualenv $git_info $normal ' '
end

function fish_right_prompt
  set -l blue (set_color -o blue)
  set -l cwd $blue(pwd)
  echo $cwd
end

[ -e $HOME/.config/fish/config.local.fish ]; and . $HOME/.config/fish/config.local.fish
