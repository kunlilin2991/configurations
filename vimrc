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
" nmap <Leader>Q :q<CR>
"保存操作
nmap <Leader>w :w<CR>
"保存退出
nmap <Leader>wq :wa<CR>:q<CR>
"不保存退出
" nmap <Leader>Q :q!<CR>
"编辑特权文件的时候，不用sudo vim就可以直接保存
nmap <leader>W :w !sudo tee % > /dev/null<CR>

"关闭当前的缓冲区页
nmap <leader>Q :bd<CR>

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


"设置拼写检查的语言
set spelllang=en_us


"在不同的窗口之间进行切换
"依次遍历 左 右 下 上的窗口
nnoremap wn <C-W><C-W>
nnoremap <Leader>wl <C-W>l
nnoremap <Leader>wr <C-W>h
nnoremap <Leader>wj <C-W>j
nnoremap <Leader>wk <C-W>k

"对于搜索的一些设置
set hlsearch "high light search
set incsearch "实时搜索功能
set ignorecase "忽略大小写
set smartcase "当搜索是大写字母的时候，忽略小写字母的匹配 跟ignorecase一起作用
syntax on "用另外一种颜色显示搜索结果
set showmatch "在成对的符号之间跳转
nmap <leader>/ :let @/=""<CR>   "清除缓冲区
nmap <leader>. :<UP><CR>    "重复上一个命令
nmap <leader>m %        "在结对符之间跳转

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
" set scrolloff=15
set scrolloff =999  " 设定999的目的是编辑行始终在屏幕的中间一行。zz快捷键是手动设定在屏幕的中间。

"折叠行 za是打开或者关闭折叠 zM关闭所有折叠 zR打开所有折叠
"zf是创建折叠，XXzf+ - 分别是对下面或者上面多少行进行这些
"zd是删除折叠的意思
"zD  循环删除 (Delete) 光标下的折叠，即嵌套删除折叠。仅当 'foldmethod' 设为 "manual" 或 "marker" 时有效。
" zE  除去 (Eliminate) 窗口里“所有”的折叠。仅当 'foldmethod' 设为 "manual" 或 "marker" 时有效。

set foldenable
set foldmethod=manual       "手动的折叠
"set foldmethod=syntax       "基于语义的折叠
"set foldmethod=indent       "基于缩进的折叠

"没有格式错乱的粘贴，只是开启按钮
nnoremap <leader>sp :set invpaste paste?<CR>
set pastetoggle=<leader>sp

"允许鼠标
set mouse=a


"让设置立即生效
" autocmd BufWritePost $MYVIMRC source $MYVIMRC

"vim自身命令智能补全
set wildmenu
set showcmd "显示状态栏

"设置ctags自动向上寻找ctags的文件。否则只能在ctags的生成路径下打开文件
set tags=./.tags;,.tags
set autochdir


"插件管理

set nocompatible "required 
filetype off	"required
set  rtp+=~/.vim/bundle/Vundle.vim
"插件在begin和end之间
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-scripts/fcitx.vim'      "状态跟编辑时输入法单独设置
" Plugin 'altercation/vim-colors-solarized'   "solarized配色方案
Plugin 'raphamorim/lucario'                 "lucario配色方案
" Plugin 'tomasr/molokai'     "molokai配色方案
Plugin 'flazz/vim-colorschemes'   "使用一个插件管理所有的配色方案。
Plugin 'vim-scripts/a.vim'      "在头文件跟文件之间进行切换
Plugin 'vim-airline/vim-airline'        "底部状态栏
Plugin 'vim-airline/vim-airline-themes'     "airline的主题
"Plugin 'edkolev/tmuxline.vim'       "底部状态栏，但是vim必须运行在tmux
Plugin 'easymotion/vim-easymotion'      "类似于vimium中的F键的功能
Plugin 'vim-scripts/The-NERD-tree'      "打开文件所在路径的文件树
Plugin 'asins/vimcdoc'      "vim中文帮助文档
Plugin 'Valloric/YouCompleteMe'         "智能补全
Plugin 'rdnetto/YCM-Generator'  "自动为YoucompleteMe生成.ycm_extra_conf.py文件
" Plugin 'kien/rainbow_parentheses.vim' "括号等的配对颜色
Plugin 'luochen1990/rainbow'    "括号等的配对颜色
Plugin 'Sirver/ultisnips'       "智能补全，输入提示
Plugin 'kien/ctrlp.vim'     "查找文件 在全部的文件系统中 而不是在文件中查找
" Plugin 'nathanaelkane/vim-indent-guides'    "可视的显示缩进
" Plugin 'scrooloose/syntastic'    "显示错误信息
Plugin 'w0rp/ale'   "新的错误信息
Plugin 'majutsushi/tagbar'      "查看结构体自定义快捷键是leader tb
Plugin 'vim-scripts/TaskList.vim'       "通过fixme tudo等去快速跳转
Plugin 'junegunn/vim-easy-align'        "各种缩进等
Plugin 'thinca/vim-quickrun'            "在vim中直接运行一个小程序
Plugin 'sjl/gundo.vim'              "类似与git的功能，本地的版本控制
Plugin 'chusiang/vim-sdcv'          "在vim中使用sdcv
Plugin 'scrooloose/nerdcommenter'       "快速注释
Plugin  'honza/vim-snippets'        "与ultisnips组合的代码补全工具 使用的是这个工具中的引擎。其定义了各种操作
Plugin 'mbbill/fencview'        "解决vim编码问题，例如打开txt乱码等问题。使用方法是命令行输入FencAutoDetect一般输入FencA就Tab就可以了
Plugin 'vim-scripts/DrawIt' " ASCII art风格的注释格式 使用方法见下面具体配置
Plugin 'derekwyatt/vim-fswitch' "实现在头文件声明和定义再见跳转
Plugin 'vim-scripts/gtags.vim'  "gtags
Plugin 'ludovicchabant/vim-gutentags'  "manages your tag files
Plugin 'vim-scripts/DfrankUtil' "实现周期性的更新ctags
Plugin 'vim-scripts/vimprj'     "实现周期性的更新ctags 上面的这两个是前提条件，真正的实现是下面的这个
Plugin 'vim-scripts/indexer.tar.gz' "周期性的更新ctags文件，依赖上面的两个文件
Plugin 'octol/vim-cpp-enhanced-highlight'   "C++ syntax highlight
" Plugin 'lervag/vimtex'        " latex for vim plugin
" Plugin 'xuhdev/vim-latex-live-preview' "实时输出vim编写的LaTeX的文档的效果
Plugin 'JamshedVesuna/vim-markdown-preview'  "markdown preview
" 


call vundle#end()
filetype plugin indent on



"[fcitx.vim] (plugin) (effect)
set ttimeoutlen=10
"[fcitx.vim] $


"配色方案
"[vim-colorschemes](Plugin) (effect)
syntax enable
" let g:solarized_termcolors=256
set background=dark
colorscheme solarized
" colorscheme lucario
" colorscheme molokai

"[a.vim](Plugin) (effect)
"a.vim在头文件跟文件之间进行快速切换
nmap <leader>a :A<CR>
"[a.vim]$


"[airline] (Plugin) (effect)
"底部状态栏
 let g:airline_powerline_fonts = 1
 let g:airline_detect_modified=1
 let g:airline_detect_iminsert=1
 let g:airline_detect_paste=1
 let g:airline#extensions#whitespace#show_message = 0 " 不显示末尾空行
 " let g:airline_section_c = '%t'     "只显示文件名，不显示路径
" 在同一个vim使用buffer打开多个文件设置
let g:airline#extensions#tabline#enabled = 1 " 显增加buffer ，在同一个窗口打开多个vim
set hidden "避免必须保存修改才能跳转buffer
let g:airline_left_sep = '>'
let g:airline_right_sep = '<'
nnoremap [b :bp<CR>
nnoremap ]b :bn<CR>
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
" let g:airline_section_gutter='%{getcwd()}'
"let g:airline_section_error = '%{strftime("%c")}'   "显示时间
"let g:airline_colorscheme='solarized_light'
" let g:airline_section_z = 'BN: %{bufnr("%")}'

"airline主题，在对应文件夹里边有很多 对应查找
let g:airline_theme='base16_colors'
"[airline.vim] <Plugin> <effect>


"[easymotion.vim] <Plugin> <effect>
"<leader><leader>w触发对world的easymotion，就是所有的字母前面变一个符号，输入相对应的符号就跳转到对应的单词处
"<leader><leader>f触发查找命令，再输入一个字母就显示含有这个字母的地方
"[easymotion.vim] <Plugin> <effect>


"[the nerd tree] (Plugin) (effect)
"打开文件目录
map <leader>n :NERDTreeToggle<CR>

let NERDTreeHighlightCursorline=1
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.obj$', '\.o$', '\.so$', '\.egg$', '^\.git$', '^\.svn$', '^\.hg$' ]
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | end
"[The-NERD-Tree] $


"[vimcdoc] (Plugin) (effect)
"中文文档
set helplang=cn
"[vimcdoc] $


"[vim-cpp-enhanced-highlight] (Plugin) (effect)
let g:cpp_class_scope_highlight = 1 "highlight class scope 
let g:cpp_member_variable_highlight = 1  "Highlighting of member variables 
let g:cpp_class_decl_highlight = 1   "Highlighting of class names in declarations
let g:cpp_experimental_simple_template_highlight = 1    "hightlight template functions
" let g:cpp_experimental_simple_template_highlight = 1    "hightlight template functions quick but error in some templete, only one is actived
" let g:cpp_no_function_highlight = 1     "Highlighting of user defined functions is disabled by this setting
"[vim-cpp-enhanced-highlight]$


" [YouCompleteMe](plugin)(complete)(effect)
" 添加配置文件，这里是网上的添加了C++的文件的py文件。这个文件在下载的ycm中没有，需要自己去配置，当前文件下载于https://github.com/JDevlieghere/dotfiles/blob/master/.vim/.ycm_extra_conf.py
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'

" 显示开启vim时检查ycm_extra_conf文件的信息  
let g:ycm_confirm_extra_conf=0
set completeopt=longest,menu	"让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"	"回车即选中当前项
"与ultisnips不冲突
let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
" 开启基于tag的补全，可以在这之后添加需要的标签路径  
let g:ycm_collect_identifiers_from_tags_files=1
"注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_comments_and_strings = 0
" 开启语义补全
let g:ycm_seed_identifiers_with_syntax=1	
"在注释输入中也能补全
let g:ycm_complete_in_comments = 1
"在字符串输入中也能补全
let g:ycm_complete_in_strings = 1

let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
" 从第一个键入字符就开始罗列匹配项
let g:ycm_min_num_of_chars_for_completion=1

" 修改对C函数的补全快捷键，默认是CTRL + space，修改为ALT + ;
" YCM 集成 OmniCppComplete 补全引擎，设置其快捷键
inoremap <leader>; <C-x><C-o>

let g:ycm_key_invoke_completion = '<M-;>'

" 设置在下面几种格式的文件上屏蔽ycm
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'nerdtree' : 1,
      \}

" 利用YCM实现函数定义的跳转
nnoremap <leader>jc :YcmCompleter GoToDeclaration<CR>
" 只能是 #include 或已打开的文件
nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
" [YouCompleteMe]$


" [YCM-Generator] (Plugin) (effect)
" nnoremap <leader>gcm :YcmGenerateConfig<CR> "在当前目录生成.ycm_extra_conf.py
" 在.vim/bundle/YCM-Generator目录下运行./genarator.py + build
" directory就可以生成对应的目录
" [YCM-Generator] $


" [ultisnips](plugin)(effect)
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"
" let g:UltiSnipsSnippetDirectories=["mysnippets","bundle/ultisnips/mysnippets"]
"[ultisnips] $


" [RainbowParentheses](plugin)(color)(effect)
" 给配对的括号着色
" let g:rbpt_colorpairs = [
"     \ ['brown',       'RoyalBlue3'],
"     \ ['Darkblue',    'SeaGreen3'],
"     \ ['darkgray',    'DarkOrchid3'],
"     \ ['darkgreen',   'firebrick3'],
"     \ ['darkcyan',    'RoyalBlue3'],
"     \ ['darkred',     'SeaGreen3'],
"     \ ['darkmagenta', 'DarkOrchid3'],
"     \ ['brown',       'firebrick3'],
"     \ ['gray',        'RoyalBlue3'],
"     \ ['darkmagenta', 'DarkOrchid3'],
"     \ ['Darkblue',    'firebrick3'],
"     \ ['darkgreen',   'RoyalBlue3'],
"     \ ['darkcyan',    'SeaGreen3'],
"     \ ['darkred',     'DarkOrchid3'],
"     \ ['red',         'firebrick3'],
    " \ ]
" let g:rbpt_max = 16
" let g:rbpt_loadcmd_toggle = 0
" autocmd VimEnter * RainbowParenthesesActivate
" autocmd Syntax * RainbowParenthesesLoadRound
" autocmd Syntax * RainbowParenthesesLoadSquare
" autocmd Syntax * RainbowParenthesesLoadBraces
" [RainbowParentheses]$



" [rainbow](plugin)(color)(effect)
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

"setting from the offical introduction 
	let g:rainbow_conf = {
	\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
	\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
	\	'operators': '_,_',
	\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\	'separately': {
	\		'*': {},
	\		'tex': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
	\		},
	\		'lisp': {
	\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
	\		},
	\		'vim': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
	\		},
	\		'html': {
	\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
	\		},
	\		'css': 0,
	\	}
	\}

" [rainbow]$


" [ctrlp](plugin)(file)(effect)
"查找文件 在全部的文件系统中 而不是在文件中查找 在新的窗口打开文件是Ctrl + t
let g:ctrlp_map = '<leader>f'
let g:ctrlp_match_window_reversed = 0
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
let g:ctrlp_open_multiple_files = 'v'
" [ctrlp]$


" [vim-indent-guide](plugin)(show)
" 可视的显示缩进
" let g:indent_guides_enable_on_vim_startup=1
" let g:indent_guides_start_level=2
" let g:indent_guides_guide_size=1
" let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']
" [vim-indent-guide] $


" " [syntastic](plugin)(syntax)
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 0
" let g:syntastic_cpp_include_dirs = ['/usr/include/']
" let g:syntastic_cpp_remove_include_errors = 1
" let g:syntastic_cpp_check_header = 1
" let g:syntastic_cpp_compiler = 'clang++'
" let g:syntastic_cpp_compiler_options = '-std=c++1z '
" "set error or warning signs
" let g:syntastic_error_symbol = '✗'
" let g:syntastic_warning_symbol = '⚠'
" ""whether to show balloons
" let g:syntastic_enable_balloons = 1
" nmap <leader>sq :SyntasticReset<CR>
" " [syntastic]$


"[ALE] (plugin)(effect)
let g:ale_linters_explicit = 1
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:airline#extensions#ale#enabled = 1

let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++11'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''

"错误信息linter的样式
let g:ale_sign_error = "\ue009\ue009"
hi! clear SpellBad
hi! clear SpellCap
hi! clear SpellRare
hi! SpellBad gui=undercurl guisp=red
hi! SpellCap gui=undercurl guisp=blue
hi! SpellRare gui=undercurl guisp=magenta


"[ALE] $


"[tagbar](plugin)(effect)
nmap <F9> :TagbarToggle<CR>
nmap <leader>tb :TagbarToggle<CR>

"启动的时候，自动focus
let g:tagbar_autofocus = 1
" 设置 tagbar 子窗口的位置出现在主编辑区的左边 
" let tagbar_left=1
" 设置显示／隐藏标签列表子窗口的快捷键。速记：identifier list by tag
" nnoremap <Leader>ilt :TagbarToggle<CR>
" 设置标签子窗口的宽度 
let tagbar_width=32 
" tagbar 子窗口中不显示冗余帮助信息 
let g:tagbar_compact=1
" 设置 ctags 对哪些代码标识符生成标签
let g:tagbar_type_cpp = {
    \ 'kinds' : [
         \ 'c:classes:0:1',
         \ 'd:macros:0:1',
         \ 'e:enumerators:0:0', 
         \ 'f:functions:0:1',
         \ 'g:enumeration:0:1',
         \ 'l:local:0:1',
         \ 'm:members:0:1',
         \ 'n:namespaces:0:1',
         \ 'p:functions_prototypes:0:1',
         \ 's:structs:0:1',
         \ 't:typedefs:0:1',
         \ 'u:unions:0:1',
         \ 'v:global:0:1',
         \ 'x:external:0:1'
     \ ],
     \ 'sro'        : '::',
     \ 'kind2scope' : {
         \ 'g' : 'enum',
         \ 'n' : 'namespace',
         \ 'c' : 'class',
         \ 's' : 'struct',
         \ 'u' : 'union'
     \ },
     \ 'scope2kind' : {
         \ 'enum'      : 'g',
         \ 'namespace' : 'n',
         \ 'class'     : 'c',
         \ 'struct'    : 's',
         \ 'union'     : 'u'
     \ }
\ }
"查函数结构体等声明
"[tagbar]$


"[TaskList](plugin)(effect)
"快速定位到FIXME 和TUDO等，也可以自己定义，实现快速跳转
let g:tlTokenList = ["FIXME", "TODO", "HACK", "NOTE", "WARN", "MODIFY"]
let g:tlWindowPosition = 1
nmap <leader>td <Plug>TaskList
"[TaskList]$


"[EasyAlign](plugin)(effect)
vmap <Enter> <Plug>(EasyAlign)
"对齐方式等
"[EasyAlign]$


"[vim-quickrun](plugin)(effect)
nmap <Leader>r <Plug>(quickrun)
let g:quickrun_config = {}
let g:quickrun_config.cpp = {
            \ 'type': 'cpp/clang++',
            \ 'cmdopt': '-std=c++1z -I ~/include'
            \}
"直接在vim中运行一个小程序，不需要声明等，就直接一个函数就可以了
"[vim-quickrun]$


"[gundo](plugin)(effect)
nmap <leader>su :GndoToggle<CR>
"git 修改情况
"[gundo]$


"[vim-sdcv](plugin)(effect)
"vim-sdcv使用插件在vim中调用sdcv进行查询
nmap <leader>fw :call SearchWord()<CR>
"[vim-sdcv]$


"[nerdcommenter](plugin)(effect)
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


"[gtags](Plugin) (ineffect)
" gtags 使用:cs find g XX可以查找对应的定义 在光标处 使用Ctrl+]查询定义
" 使用Ctrl+t返回查询 需要在系统上安装global
" global -c sds 查询以sds开头的变量
set cscopetag
set cscopeprg='gtags-cscope'
let GtagsCscope_Auto_Load = 1
let CtagsCscope_Auto_Map = 1
let GtagsCscope_Quiet = 1
"[tags]$


"[fencview] (plugin)(effect)
"自动检查编码的的插件，使用方法是FencAutoDetect
"[fencview]$


"[DrawIt](plugin)(effect)
" 常用操作就两个，:Distart，开始绘制，可用方向键绘制线条，空格键绘制或擦除字符；:Distop，停止绘制。
" 具体绘制的内容，如是加号还是什么要自己添加。
" [DrawIt] $


"[vim-fswitch] (plugin)(effect)
"实现在类的声明和定义之间的跳转，例如类的声明在myclass.h定义在myclsss.cpp中，则可以通过这个时间快速跳转
nmap <silent> <Leader>sw :FSHere<cr>
"[vim-fswitch]$


"[indexer.tar.gz] (plugin) (effect)
" 设置插件 indexer 调用 ctags 的参数
" 默认 --c++-kinds=+p+l，重新设置为 --c++-kinds=+p+l+x+c+d+e+f+g+m+n+s+t+u+v
" 默认 --fields=+iaS 不满足 YCM 要求，需改为 --fields=+iaSl
let g:indexer_ctagsCommandLineOptions="--c++-kinds=+p+l+x+c+d+e+f+g+m+n+s+t+u+v --fields=+iaSl --extra=+q"
"[indexer.tar.gz] $


"[tabular] (Plugin) (effect)
"<leader>a= 对=进行对齐
"<leader>a, 对，进行对齐
"[tabular] $


"[vimtex] (Plugin) (ineffect)
"for usage tyep :h vimtex
"[vimtex] $


"[vim-markdown-preview] (plugin) (effect)
let vim_markdown_preview_github=1

"[vim-gutentags]  {Plugin)  (effect) 
"gutentags搜索工程目录标志递归到上面的目录
let g:gutentags_project_root = ['.tags','.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" " 同时开启 ctags 和 gtags 支持：
" let g:gutentags_modules = []
" if executable('ctags')
"     let g:gutentags_modules += ['ctags']
" endif
" if executable('gtags-cscope') && executable('gtags')
"     let g:gutentags_modules += ['gtags_cscope']
" endif

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 如果使用 universal ctags 需要增加下面一行 兼容原本的ctags
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']




" end of vimrc
