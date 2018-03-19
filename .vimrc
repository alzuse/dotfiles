" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,}
" }
" Environment {
    " Identify platform {
        set nocompatible        " Must be first line

        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }

    " Arrow Key Fix {
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }

    " The default leader is '\', but many people prefer ',' as it's in a standard
    " location.
    let mapleader = ','
    let maplocalleader = '_'
" }

" Use plug.vim  {
        " The next three lines ensure that the ~/.vim/bundle/ system works
        call plug#begin('~/.vim/bundle')
" }

" Plugins {
    " Deps {
        Plug 'mileszs/ack.vim'
        if executable('ag')
            let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
        elseif executable('ack-grep')
            let g:ackprg="ack-grep -H --nocolor --nogroup --column"
        endif
    " }

    " General {
        Plug 'scrooloose/nerdtree'
        Plug 'jistr/vim-nerdtree-tabs'
        Plug 'Xuyuanp/nerdtree-git-plugin'
        Plug 'yianwillis/vimcdoc'
        Plug 'ctrlpvim/ctrlp.vim'
        Plug 'tacahiroy/ctrlp-funky'
        "" Plug 'terryma/vim-multiple-cursors'
        Plug 'vim-scripts/sessionman.vim'
        Plug 'vim-scripts/matchit.zip'
        if has("python") || has("python3")
            Plug 'vim-airline/vim-airline'
            Plug 'vim-airline/vim-airline-themes'
        endif
        Plug 'bling/vim-bufferline'
        Plug 'easymotion/vim-easymotion'
        Plug 'mbbill/undotree'
        Plug 'mhinz/vim-signify'
    " }

    " General Programming {
        " Pick one of the checksyntax, jslint, or syntastic
        "" Plug 'scrooloose/syntastic'
        "" Plug 'w0rp/ale'
        Plug 'tpope/vim-fugitive'
        Plug 'nathanaelkane/vim-indent-guides'
        Plug 'scrooloose/nerdcommenter'
        Plug 'chrisbra/vim-diff-enhanced'
        Plug 'majutsushi/tagbar'
        "" Plug 'luochen1990/rainbow'
    " }

    " AutoComplete {
        "" Plug 'Valloric/YouCompleteMe'
    " }

    " EDA {
        Plug 'vhda/verilog_systemverilog.vim'
        Plug 'tarikgraba/vim-liberty'
        Plug 'tarikgraba/vim-lefdef'
    " }
    " c/cpp {
        " All clang based completers suck
        "" Plug 'justmao945/vim-clang'
        "" Plug 'Rip-Rip/clang_complete'
    " }
    " Python {
        " Pick either python-mode or pyflakes & pydoc
        "" Plug 'ervandew/supertab'
        "" Plug 'davidhalter/jedi-vim'
        Plug 'anntzer/vim-cython'
    " }
    call plug#end()
" }

" General {
    ""set background=dark         " Assume a dark background

    " Allow to trigger background
    function! ToggleBG()
        let s:tbg = &background
        " Inversion
        if s:tbg == "dark"
            set background=light
        else
            set background=dark
        endif
    endfunction
    noremap <leader>tb :call ToggleBG()<CR>

    " Allow to trigger helplang
    function! ToggleHelpLang()
        let s:thl = &helplang
        "Inversion
        if s:thl == "cn"
            set helplang=en
        else
            if isdirectory(expand("~/.vim/bundle/vimcdoc"))
                set helplang=cn
            endif
        endif
    endfunction
    noremap <leader>th :call ToggleHelpLang()<CR>

    " if !has('gui')
        "set term=$TERM          " Make arrow and other keys work
    " endif
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    " set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened;
    " Always switch to the current file directory
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore,block            " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    "" set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc.before.local file:
    let g:my_restore_cursor = 1
    if exists('g:my_no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                silent! normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif

    " Setting up the directories {
    " Persistent backups are sick
    "" set backup                  " Backups are nice ...
    "" if has('persistent_undo')
    ""     set undofile                " So is persistent undo ...
    ""     set undolevels=1000         " Maximum number of changes that can be undone
    ""     set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    "" endif
    " }

" }

" Vim UI {
    "" set tabpagemax=15               " Only show 15 tabs
    set noshowmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        if !exists('g:override_my_bundles')
            set statusline+=%{fugitive#statusline()} " Git Hotness
        endif
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    "" set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    "" set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=1                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
    set diffopt+=vertical
    set t_BE=
    set completeopt-=preview
    set completeopt=menu,menuone
" }

" Formatting {
    "" set nowrap                      " Do not wrap long lines
    set wrap
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    let g:my_keep_trailing_whitespace = 0
    autocmd FileType c,cpp,python,pyrex,puppet,xml,yaml,perl,sql autocmd BufWritePre <buffer> if !exists('g:my_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd FileType puppet,xml,yaml,html setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.

    "Special file type
    autocmd BufnewFile,BufRead spec.conf set filetype=yaml
    autocmd BufnewFile,BufRead *.ds set filetype=rst
    autocmd BufnewFile,BufRead .sage set filetype=python
" }

" Key (re)Mappings {


    " Wrapped lines goes down/up to next row, rather than next line in file.
    " Silly when using macro, so these two mappings are disabled
    "" noremap j gj
    "" noremap k gk

    " The following two lines conflict with moving to top and
    " bottom of the screen
    map <S-H> gT
    map <S-L> gt

    " Stupid shift key fixes
    if !exists('g:my_no_keyfixes')
        if has("user_commands")
            command! -bang -nargs=* -complete=file E e<bang> <args>
            command! -bang -nargs=* -complete=file W w<bang> <args>
            command! -bang -nargs=* -complete=file Wq wq<bang> <args>
            command! -bang -nargs=* -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang Qa qa<bang>
            command! -bang QA qa<bang>
        endif

        cmap Tabe tabe
    endif

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Most prefer to toggle search highlighting rather than clear the current
    " search results. To clear search highlighting rather than toggle it on
    " and off, add the following
    "   let g:my_clear_search_highlight = 1
    if exists('g:my_clear_search_highlight')
        nmap <silent> <leader>/ :nohlsearch<CR>
    else
        nmap <silent> <leader>/ :set invhlsearch<CR>
    endif

    " Find merge conflict markers
    map <leader>cf /\v^[<\|=>]{7}( .*\|$)<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ee :tabe %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map gf :tabedit <cfile><CR>

    " Adjust viewports to the same size
    map <leader>= <C-w>=

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Easier motion
    inoremap <C-e> <C-x><C-e>
    inoremap <C-y> <C-x><C-y>

" }

" Plugins {
    " Misc {
        if isdirectory(expand("~/.vim/bundle/matchit.zip"))
            let b:match_ignorecase = 1
        endif

        if isdirectory(expand("~/.vim/bundle/ack.vim"))
            cnoreabbrev Ack Ack!
            nnoremap <leader>a :Ack!<Space>
        endif

        if isdirectory(expand("~/.vim/bundle/vim-easymotion"))
            map <leader><leader>j <Plug>(easymotion-j)
            map <leader><leader>k <Plug>(easymotion-k)
            map <leader><leader>h <Plug>(easymotion-linebackward)
            map <leader><leader>l <Plug>(easymotion-lineforward)
            map <leader><leader>. <Plug>(easymotion-repeat)
        endif
    " }

    " Ctags {
        set tags=./tags;/,~/.vimtags

        let g:tagbar_ctags_bin = '/usr/bin/ctags'

        " Make tags placed in .git/tags file available in all levels of a repository
        let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
        if gitroot != ''
            let &tags = &tags . ',' . gitroot . '/.git/tags'
        endif
    " }

    " NerdTree {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            nmap <leader>fl :NERDTreeTabsToggle<CR>
            nmap <leader>ff :NERDTreeFind<CR>

            let g:NERDShutUp=1

            let g:NERDTreeDirArrowExpandable = '▸'
            let g:NERDTreeDirArrowCollapsible = '▾'
            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
            let g:nerdtree_tabs_open_on_gui_startup=0
            let g:NERDTreeIndicatorMapCustom = {
                \ "Modified"  : "✹",
                \ "Staged"    : "✚",
                \ "Untracked" : "✭",
                \ "Renamed"   : "➜",
                \ "Unmerged"  : "═",
                \ "Deleted"   : "✖",
                \ "Dirty"     : "✗",
                \ "Clean"     : "✔︎",
                \ 'Ignored'   : '☒',
                \ "Unknown"   : "?"
                \ }
        endif
    " }

    " Session List {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        if isdirectory(expand("~/.vim/bundle/sessionman.vim/"))
            nmap <leader>sl :SessionList<CR>
            nmap <leader>ss :SessionSave<CR>
            nmap <leader>sc :SessionClose<CR>
        endif
    " }

    " Ale {
        if isdirectory(expand('~/.vim/bundle/ale'))
            let g:ale_sign_error = 'EE'
            let g:ale_sign_warning = 'WW'
            let g:ale_sign_column_always = 1
            let g:ale_echo_msg_error_str = 'E'
            let g:ale_echo_msg_warning_str = 'W'
            let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
            let g:ale_linters = {
            \   'python': ['flake8'],
            \   'perl': ['perlcritic'],
            \   'csh': ['shell'],
            \   'text': [],
            \   'help': [],
            \}
            let g:airline#extensions#ale#enabled = 1
        endif
    " }
    " EnhanceDiff {
        if &diff && executable('git') && isdirectory(expand('~/.vim/vim-diff-enhanced'))
            let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
        endif
    " }

    " Tagbar {
        if isdirectory(expand('~/.vim/bundle/tagbar'))
            nmap <leader>tt :TagbarToggle<CR>
        endif

    " }
    " c/cpp {
         if isdirectory(expand('~/.vim/bundle/clang_complete')) && 0
             "let g:clang_library_path='/path/to/libclang.so'
         endif
    " }
    " Jedi {
        if 0
            " show signature in commad-line
            let g:jedi#goto_command = "<leader>jd"
            let g:jedi#goto_assignments_command = "<leader>jg"
            let g:jedi#goto_definitions_command = "<leader>jd"
            let g:jedi#documentation_command = "K"
            let g:jedi#usages_command = "<leader>jn"
            let g:jedi#completions_command = "<C-N>"
            let g:jedi#rename_command = "<leader>jr"
            let g:jedi#show_call_signatures = '2'
        endif
    " }

    " PyMode {
        " Disable if python support not present
        if !has('python') && !has('python3')
            let g:pymode = 0
        else
            if isdirectory(expand('~/.vim/bundle/python-mode')) && 0
                let g:pymode = 1
                " let g:pymode_lint = 1
                let g:pymode_lint_on_fly = 0
                let g:pymode_lint_checkers = ['pep8']
                let g:pymode_lint_cwindow = 1
                let g:pymode_trim_whitespaces = 0
                let g:pymode_options = 1
                let g:pymode_folding = 0
                let g:pymode_run = 1
                let g:pymode_run_bind = '<leader>r'
                let g:pymode_rope = 1
                let g:pymode_rope_completion = 1
                let g:pymode_rope_complete_on_dot = 1
                let g:pymode_rope_show_doc_bind = '<C-c>d'
            endif
        endif
    " }

    " ctrlp {
        if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
            let g:ctrlp_working_path_mode = 'ra'
            let g:ctrlp_custom_ignore = {
                \ 'dir':  '\v[\/]\.(git|hg|svn)$',
                \ 'file': '\v\.(exe|so|dll|pyc)$' }

            if executable('ag')
                let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
            elseif executable('ack-grep')
                let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
            elseif executable('ack')
                let s:ctrlp_fallback = 'ack %s --nocolor -f'
            " On Windows use "dir" as fallback command.
            elseif WINDOWS()
                let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
            else
                let s:ctrlp_fallback = 'find %s -type f'
            endif
            if exists("g:ctrlp_user_command")
                unlet g:ctrlp_user_command
            endif
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
            \ }

            if isdirectory(expand("~/.vim/bundle/ctrlp-funky/"))
                " CtrlP extensions
                let g:ctrlp_extensions = ['funky']

                "funky
                nnoremap <leader>fu :CtrlPFunky<Cr>
            endif
        endif
    "}

    " Rainbow {
        if isdirectory(expand("~/.vim/bundle/rainbow/"))
            let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
        endif
    "}

    " Fugitive {
        if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
            nnoremap <silent> <leader>gs :Gstatus<CR>
            nnoremap <silent> <leader>gd :Gdiff<CR>
            nnoremap <silent> <leader>gc :Gcommit<CR>
            nnoremap <silent> <leader>gb :Gblame<CR>
            nnoremap <silent> <leader>gl :Glog<CR>
            nnoremap <silent> <leader>gp :Git push<CR>
            nnoremap <silent> <leader>gr :Gread<CR>
            nnoremap <silent> <leader>gw :Gwrite<CR>
            nnoremap <silent> <leader>ge :Gedit<CR>
            " Mnemonic _i_nteractive
            nnoremap <silent> <leader>gi :Git add -p %<CR>
            nnoremap <silent> <leader>gg :SignifyToggle<CR>
        endif
    "}

    " YouCompleteMe {
        if 0
            let g:ycm_add_preview_to_completeopt = 0
            let g:ycm_show_diagnostics_ui = 0
            let g:ycm_server_log_level = 'info'
            let g:ycm_min_num_identifier_candidate_chars = 2
            let g:ycm_collect_identifiers_from_comments_and_strings = 1
            let g:ycm_complete_in_strings=1
            let g:ycm_key_invoke_completion = '<c-z>'
            set completeopt=menu,menuone

            noremap <c-z> <NOP>

            let g:ycm_semantic_triggers =  {
                        \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
                        \ 'cs,lua,javascript': ['re!\w{2}'],
                        \ }

            " Disable the neosnippet preview candidate window
            " When enabled, there can be too much visual noise
            " especially when splits are used.
        endif
    " }

    " UndoTree {
        if isdirectory(expand("~/.vim/bundle/undotree/"))
            nnoremap <leader>ut :UndotreeToggle<CR>
            " If undotree is opened, it is likely one wants to interact with it.
            let g:undotree_SetFocusWhenToggle=1
        endif
    " }

    " indent_guides {
        if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
            let g:indent_guides_start_level = 1
            let g:indent_guides_guide_size = 0
            let g:indent_guides_enable_on_vim_startup = 0
        endif
    " }

    " vim-airline {
        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.
        " To use the symbols , , , , , , ␊, Ξ, and .in the statusline
        " segments add the following:
        "   let g:airline_powerline_fonts=1
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
        if isdirectory(expand("~/.vim/bundle/vim-airline/"))
            let g:airline_powerline_fonts = 1
            if has('gui_running')
                let g:airline#extensions#tabline#enabled = 0
            else
                let g:airline#extensions#tabline#enabled = 1
                let g:airline#extensions#tabline#formatter = 'unique_tail'
            endif

            if !exists('g:airline_powerline_fonts')
                " Use the default set of separators with a few customizations
                if !exists('g:airline_symbols')
                    let g:airline_symbols = {}
                endif

                " unicode symbols
                let g:airline_left_sep=''
                let g:airline_right_sep=''
                let g:airline_symbols.linenr = '␊'
                let g:airline_symbols.branch = ''
                let g:airline_symbols.paste = 'ρ'
                let g:airline_symbols.whitespace = 'Ξ'
                let g:airline_symbols.readonly = ''
                "" let g:airline_left_sep = '»'
                "" let g:airline_left_sep = '▶'
                "" let g:airline_left_sep = '>'
                "" let g:airline_right_sep = '«'
                "" let g:airline_right_sep = '◀'
                "" let g:airline_right_sep = '<'
                "" let g:airline_symbols.linenr = '␤'
                "" let g:airline_symbols.linenr = '¶'
                "" let g:airline_symbols.branch = '⎇'
                "" let g:airline_symbols.paste = 'Þ'
                "" let g:airline_symbols.paste = '∥'
                "" let g:airline_symbols.readonly = '⭤'

            else
                if LINUX() && has("gui_running")
                    set guifont=Dejavu\ Sans\ Mono\ for\ Powerline\ 12
                elseif OSX() && has("gui_running")
                    set guifont=Source_Code_Pro_for_Powerline:h12
                elseif WINDOWS() && has("gui_running")
                    set guifont=Liberation_Mono_for_Powerline:h12
                endif
            endif

            if isdirectory(expand("~/.vim/bundle/vim-airline-themes/"))
                " let g:airline_theme = 'light'
            endif
        endif
    " }



" }

" GUI Settings {

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        "" set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
    else
        if &term == 'xterm' || &term == 'screen'
            "" let g:airline_powerline_fonts = 0
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

" }

" Functions {

    " Initialize directories {
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        " your .vimrc.before.local file:
        "   let g:my_consolidated_directory = <full path to desired directory>
        "   eg: let g:my_consolidated_directory = $HOME . '/.vim/'
        if exists('g:my_consolidated_directory')
            let common_dir = g:my_consolidated_directory . prefix
        else
            let common_dir = parent . '/.' . prefix
        endif

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    " we don't need a centralized backup/undo dir...
    "" call InitializeDirectories()
    " }

    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }

    " Shell command {
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }


    function! s:ExpandFilenameAndExecute(command, file)
        execute a:command . " " . expand(a:file, ":p")
    endfunction

    function! s:EditmyConfig()
        call <SID>ExpandFilenameAndExecute("tabedit", "~/.vimrc")
        call <SID>ExpandFilenameAndExecute("vsplit", "~/.vimrc.bundles")
    endfunction

    function! LookupInSdcv()
        let liscword = expand("<cword>")
        if liscword !~ '^[a-zA-Z]\+$'
            let liscword = input("Enter word or phrase: ")
        endif
        let liscword = "\'" . liscword . "\'"
        new
        set buftype=nofile nonumber
        exe "%!sdcv " . liscword
    endfunction

    map <leader>q :call LookupInSdcv()<CR>

" }


