# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# zsh-syntax-highlighting from AUR
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES=(
        'alias'           'fg=153,bold'
        'builtin'         'fg=153'
        'function'        'fg=166'
        'command'         'fg=153'
        'precommand'      'fg=153, underline'
        'hashed-commands' 'fg=153'
        'path'            'underline'
        'globbing'        'fg=166'
)

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#  History
# хранить историю в указанном файле
export HISTFILE=~/.zsh_history
# максимальное число команд, хранимых в сеансе
export HISTSIZE=1000
export SAVEHIST=$HISTSIZE
# включить историю команд
setopt APPEND_HISTORY
# убрать повторяющиеся команды, пустые строки и пр.
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# выбирать предлагаемые zsh варианты автодополнения с помощью стрелочек
# setopt menucomplete
# zstyle ':completion:*' menu select=1 _complete _ignored _approximate

#Включить автодополнение 
autoload -U compinit promptinit 
compinit
promptinit
# Для pacman
[[ -a $(whence -p pacman-color) ]] && compdef _pacman pacman-color=pacman
# Корректировка ввода
setopt CORRECT_ALL
# Если в слове есть ошибка, предложить исправить её
SPROMPT="Ошибка! ввести %r вместо %R? ([Y]es/[N]o/[E]dit/[A]bort) "
# Не нужно всегда вводить cd
# просто наберите нужный каталог и окажитесь в нём
setopt autocd
# При совпадении первых букв слова вывести меню выбора
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="Soliah"
# ZSH_THEME="dst"
# ZSH_THEME="fino"
# ZSH_THEME="fishy"
# ZSH_THEME="gallois"
# ZSH_THEME="jispwoso"
# ZSH_THEME="jtriley"
# ZSH_THEME="lukerandall"
# ZSH_THEME="mh"
# ZSH_THEME="minimal"
# ZSH_THEME="obraun"
# ZSH_THEME="philips"
# ZSH_THEME="pmcgee"
# ZSH_THEME="risto"
# ZSH_THEME="sammy"
# funky gnzh jonathan jtriley kolo kphoen mrtazz murilasso philips rkj xiong-chiamiov xiong-chiamiov-plus
ZSH_THEME="xiong-chiamiov"


# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# if [[ $TERMINIX_ID ]]; then
        source /etc/profile.d/vte.sh
# else
	source $ZSH/oh-my-zsh.sh
# fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
