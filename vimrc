"copyright @kunlynn

"定义leader键
let g:mapleader=";"

"开启文件类型侦测
filetype on
"根据侦测的不同类型加载对应的插件
filetype plugin on

"定义快捷键到行首和行尾 原本小写的le跟lb是到一个单词的开头和结尾
nmap le $
nmap lb 0

"设置快捷键将vim中的内容复制到系统粘贴板上
"同样的反向操作也进行设置
map <leader>y "+y
map <leader>p "+p

"定义快捷键关闭当前分割的窗口
nmap <Leader>q :q<CR>
"保存操作
nmap <Leader>w :w<CR>
"保存退出
nmap <Leader>wq :wa<CR>:q<CR>
"不保存退出
nmap <Leader>Q :q!<CR>
"编辑特权文件的时候，不用sudo vim就可以直接保存
nmap <leader>W :w !sudo tee % > /dev/null<CR>

"设置快捷键遍历子窗口
"一次遍

"设置删除键可以删除已有字符，否则不能删除 兼容vi
set backspace=indent,eol,start

"将tab替换给空格
set ai
set shiftwidth=4
set sw=4
set tabstop=4
set smarttab
set tabstop=4   "tab in file
set softtabstop=4   "tab inserted
set expandtab


"在不同的窗口之间进行切换
"依次遍历 左 右 下 上的窗口
nnoremap nw <C-W><C-W>
nnoremap <Leader>lw <C-W>l
nnoremap <Leader>rw <C-W>h
nnoremap <Leader>jw <C-W>j
nnoremap <Leader>kw <C-W>k

"对于搜索的一些设置
set hlsearch "high light search
set incsearch "实时搜索功能
set ignorecase "忽略大小写
set smartcase "当搜索是大写字母的时候，忽略小写字母的匹配 跟ignorecase一起作用
syntax on "用另外一种颜色显示搜索结果
set showmatch "在成对的符号之间跳转
nmap <leader>/ :let @/=""<CR>   "清除缓冲区
nmap <leader>. :<UP><CR>    "重复上一个命令

"语法高亮
syntax enable

"缩进
set smartindent
set autoindent


"在结对符之间跳转
nmap <Leader>m %

"显示行数，显示相对行数
set number
set relativenumber

"文件编码设置
set encoding=utf-8

"状态栏
set laststatus=2
set ruler   "在状态栏显示光标的信息
set showmode
set ruler   "在状态栏显示光标的位置

"高亮显示当前行和列
set cursorline
set cursorcolumn


"距离底部的空行
set scrolloff=10

"折叠行 za是打开或者关闭折叠 zM关闭所有折叠 zR打开所有折叠
set foldenable
set foldmethod=manual       "手动的折叠
"set foldmethod=syntax       "基于语义的折叠
"set foldmethod=indent       "基于缩进的折叠

"没有格式错乱的粘贴，只是开启按钮
nnoremap <leader>sp :set invpaste paste?<CR>
set pastetoggle=<leader>sp



"让设置立即生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC 

"vim自身命令只能补全
set wildmenu
set showcmd "显示状态栏


"插件管理

set nocompatible "required 
filetype off	"required
set  rtp+=~/.vim/bundle/Vundle.vim
"插件在begin和end之间
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-scripts/fcitx.vim'      "状态跟编辑时输入法单独设置
Plugin 'altercation/vim-colors-solarized'   "solarized配色方案
Plugin 'raphamorim/lucario'                 "lucario配色方案
Plugin 'tomasr/molokai'     "molokai配色方案
Plugin 'vim-scripts/a.vim'      "在头文件跟文件之间进行切换
Plugin 'vim-airline/vim-airline'        "底部状态栏
Plugin 'vim-airline/vim-airline-themes'     "airline的主题
"Plugin 'edkolev/tmuxline.vim'       "底部状态栏，但是vim必须运行在tmux
Plugin 'easymotion/vim-easymotion'      "类似于vimium中的F键的功能
Plugin 'vim-scripts/The-NERD-tree'      "打开文件所在路径的文件树
Plugin 'asins/vimcdoc'      "vim中文帮助文档
"Plugin 'Valloric/YouCompleteMe'         "智能补全
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'Sirver/ultisnips'       "智能补全，输入提示
Plugin 'kien/ctrlp.vim'     "查找文件 在全部的文件系统中 而不是在文件中查找
Plugin 'nathanaelkane/vim-indent-guides'    "可视的显示缩进
Plugin 'scrooloose/syntastic'    "显示错误信息
Plugin 'majutsushi/tagbar'      "查看结构体
Plugin 'vim-scripts/TaskList.vim'       "通过fixme tudo等去快速跳转
Plugin 'junegunn/vim-easy-align'        "各种缩进等
Plugin 'thinca/vim-quickrun'            "在vim中直接运行一个小程序
Plugin 'sjl/gundo.vim'              "类似与git的功能，本地的版本控制
Plugin 'chusiang/vim-sdcv'          "在vim中使用sdcv
Plugin 'scrooloose/nerdcommenter'       "快速注释


call vundle#end()
filetype plugin indent on



"fcitx.vim (plugin)
set ttimeoutlen=10
"fcitx.vim $


"配色方案
syntax enable
"let g:solarized_termcolors=256
set background=dark
colorscheme solarized
"colorscheme lucario
"colorscheme molokai


"[a.vim]<Plugin>
"a.vim在头文件跟文件之间进行快速切换
nmap <leader>a :A<CR>


"[airline.vim] <Plugin>
"底部状态栏
let g:airline_powerline_fonts = 1
let g:airline_detect_modified=1
let g:airline_detect_iminsert=1
let g:airline_detect_paste=1
" let g:airline_section_gutter='%{getcwd()}'
"let g:airline_section_error = '%{strftime("%c")}'   "显示时间
"let g:airline_colorscheme='solarized_light'
"let g:airline_section_z = 'BN: %{bufnr("%")}'
"
"airline主题，在对应文件夹里边有很多 对应查找
let g:airline_theme='base16_colors'


"Tmuxline 底部状态栏但是必须运行在tmux中
"tmuxline.vim <Plugin>
":Tmuxline vim_statusline_2
":Tmuxline airline 
":Tmuxline aireline_visual 
":let g:airline#extensions#tmuxline#enabled = 0
"set term=screen

"[easymotion] <Plugin>
"<leader><leader>w触发对world的easymotion，就是所有的字母前面变一个符号，输入相对应的符号就跳转到对应的单词处
"<leader><leader>f触发查找命令，再输入一个字母就显示含有这个字母的地方

"[the nerd tree]
"打开文件目录
map <leader>n :NERDTreeToggle<CR>

let NERDTreeHighlightCursorline=1
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.obj$', '\.o$', '\.so$', '\.egg$', '^\.git$', '^\.svn$', '^\.hg$' ]
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | end
"The-NERD-Tree $


"[vimcdoc]
"中文文档
set helplang=cn
"[vimcdoc]


" [YouCompleteMe](plugin)(complete)
"let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
"在注释输入中也能补全
"let g:ycm_complete_in_comments = 1
"在字符串输入中也能补全
"let g:ycm_complete_in_strings = 1
"注释和字符串中的文字也会被收入补全
"let g:ycm_collect_identifiers_from_comments_and_strings = 0
"与ultisnips不冲突
"let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
"let g:ycm_confirm_extra_conf = 0
"let g:ycm_add_preview_to_completeopt = 1
"let g:ycm_autoclose_preview_window_after_completion = 1
"let g:ycm_autoclose_preview_window_after_insertion = 1
"let g:ycm_show_diagnostics_ui = 0
"[YouCompleteMe]$


" [ultisnips](plugin)(efficiency)
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"
let g:UltiSnipsSnippetDirectories=["UltiSnips","bundle/ultisnips/UltiSnips"]
"[ultisnips] $


" [RainbowParentheses](plugin)(color)
" 给配对的括号着色
autocmd VimEnter * RainbowParenthesesActivate
autocmd Syntax * RainbowParenthesesLoadRound
autocmd Syntax * RainbowParenthesesLoadSquare
autocmd Syntax * RainbowParenthesesLoadBraces
" [RainbowParentheses]$

" [ctrlp](plugin)(file)
"查找文件 在全部的文件系统中 而不是在文件中查找
let g:ctrlp_map = '<leader>f'
let g:ctrlp_match_window_reversed = 0
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
let g:ctrlp_open_multiple_files = 'v'
" [ctrlp]$


" [vim-indent-guide](plugin)(show)
" 可视的显示缩进
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']


" [syntastic](plugin)(syntax)
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_cpp_include_dirs = ['/usr/include/']
let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = '-std=c++1z '
"set error or warning signs
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
""whether to show balloons
let g:syntastic_enable_balloons = 1
" [syntastic]$

"查函数结构体等声明
"[tagbar](plugin)
nmap <leader>tb :TagbarToggle<CR>
"[tagbar]$



"[TaskList](plugin)
"快速定位到FIXME 和TUDO等，也可以自己定义，实现快速跳转
nmap <leader>td <Plug>TaskList
"[TaskList]$


"对齐方式等
"[EasyAlign](plugin)(efficiency)
vmap <Enter> <Plug>(EasyAlign)
"[EasyAlign]$



"直接在vim中运行一个小程序，不需要声明等，就直接一个函数就可以了
"[vim-quickrun](plugin)(efficiency)
nmap <Leader>r <Plug>(quickrun)
let g:quickrun_config = {}
let g:quickrun_config.cpp = {
            \ 'type': 'cpp/clang++',
            \ 'cmdopt': '-std=c++1z -I ~/include'
            \}
"[vim-quickrun]$
"
"
"git 修改情况
"[gundo](plugin)
nmap <leader>su :GndoToggle<CR>
"[gundo]$

"[vim-sdcv]
"vim-sdcv使用插件在vim中调用sdcv进行查询
nmap <leader>fw :call SearchWord()<CR>
"[vim-sdcv]$

"[nerdcommenter]
"快速注释内容
"用法 
" <leader>cc 快速注释当前行或者使用v选择的行
"<leader>cu取消对应行的注释
"<leader>cn 与cc相同 但是强制嵌套
"<leader>cA 在行尾添加一个注释符，并跳转到注释的地方 
"add spaces after comment delimiters by default 在注释符号之后加一个空格
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code
" indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

"[nerdcommenter]$





