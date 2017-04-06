# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"
 ZSH_THEME="muse"

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
 
plugins=(git jump colored-man-pages command-not-found copydir cp)

#对于上述插件的说明
#jump 是通过mark来标记第一个文件夹，然后jump Foo就可以跳转到对应的文件夹，Foo是你标记的文件，unmark是消除这个mark，marks是列出所有的marks。
#colored-man-pages  对man页码进行配色。
#command-not-found  这个在bash中实现了，当输入一个命令没有存在的时候，会搜索包，查看是否有对应的命令，然后提示对应的安装。
#copydir 命令是将当前的目录复制到系统粘贴板上，在使用的时候，必须安装xclip或者xsel，我自己安装的是xclip，我自己将cp这个文件修改了，将原命令copydir修改为cpdir
#cp 这个命令是显示cp的进度，有一个cpbar

source $ZSH/oh-my-zsh.sh

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

export EDITOR='vim'

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
# 
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'            #将#去掉了
    alias vdir='vdir --color=auto'          #将#去掉了

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# my own alias
alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'
alias lll='ls -alhF |less'
alias llm='ls -alhF --color=always|more'
alias lal='ls -A|less'
alias lam='ls -a --color=always |more'
alias llt='ls -alhFt'    # 按照事件来排序 列出所有的文件
alias lspwd='ls | sed "s:^:`pwd`/:"' # 列出文件的绝对路径
alias lsf='ls -AF | grep /$'  # 只显示目录下的文件夹
alias lswc='ls|wc -l' # 统计目前文件夹下文件的多少
alias cdf='cd $(dirname $(find ' # 后面是find命令 需要最后加两个括号

alias cls='clear'
alias nautilusd='nautilus ./'
alias psU='ps -U root -u root u'       #显示以root用户运行的程序
alias psA='ps -A'       #显示所有运行的进程
alias cpi='cp -i'        #询问是否覆盖同名文件
alias cpf='cp -rf'     #复制整个文件夹
alias rmf='rm -rf'      #递归删除文件夹
alias du='du -h'
alias dua='du -sh'     #显示文件夹的使用情况，合计大小 以合适的单位显示 分别是sh两个参数 
# alias rm='rm -i'
alias dic='sdcv'
# alias pdf='FoxitReader'  # 用foxitreader打开文件
alias pdf='apvlv'        # 使用vim风格的pdf阅读器

#some alias for vim
alias vi="vim"
alias vimR='vim -R' # 以只读模式打开vim 但是可以强制的修改
alias vimM='vim -M' # 以只读模式打开vim 同时不能强制修改 也就是关闭了modify的功能
alias vime='vim +' # 从文件的末尾开始打开文件，直接跳转到文件最后

#将tmux缓冲区的内容复制到系统粘贴板，这样的好处在tmux选择东西，不用鼠标了，可以直接使用
#使用方法是在tmux中使用C+B [进入到tmux的上下移动的文本模式，然后到要复制的地方，按空格进入选择模式，然后按回车将选择的文本进行复制，最后执行下面的命令tyy实现将选择的内容复制到系统粘贴板中。
alias tyy='tmux show-buffer |xclip -selection clipboard'


#添加默认启动tmux
# If not running interactively, do not do anything
[[ $- != *i* ]] && return
[[ -z "$TMUX" ]] && exec tmux


