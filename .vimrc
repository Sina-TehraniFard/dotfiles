" ======================================================================
" 基本設定
" ======================================================================

" --- シンタックスハイライトを有効化 ---
syntax on

" --- ファイルタイプ検出とプラグイン/インデント設定 ---
filetype plugin indent on

" --- 行番号表示 ---
set number

" --- タブをスペースに変換 ---
set expandtab

" --- タブ幅を4に設定 ---
set tabstop=4
set shiftwidth=4

" --- 検索結果をハイライト ---
set hlsearch

" --- インクリメンタルサーチ（入力中に結果を表示） ---
set incsearch

" --- 暗い背景用のカラースキーム調整 ---
set background=dark

" --- UTF-8を明示 ---
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis

" --- ファイル変更の自動再読込 ---
set autoread

" --- カーソル行を強調表示 ---
set cursorline

" --- クリップボード連携（macOSシステムと共有） ---
set clipboard=unnamedplus

" --- コマンド履歴の強化 ---
set history=1000

" --- ステータスライン常時表示 ---
set laststatus=2

" ======================================================================
" プラグイン管理（vim-plug）
" ======================================================================

" プラグインを保存するディレクトリを指定
call plug#begin('~/.vim/plugged')

" --- LSP補完 ---
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" --- カラースキーム ---
Plug 'morhetz/gruvbox'

" --- ファイル操作 ---
Plug 'preservim/nerdtree'                    " ファイルツリー
Plug 'Xuyuanp/nerdtree-git-plugin'           " NERDTreeにGitステータス表示
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                      " ファジーファインダー

" --- Git連携 ---
Plug 'tpope/vim-fugitive'                    " Gitコマンド統合
Plug 'airblade/vim-gitgutter'                " 差分表示（行番号横）

" --- 編集効率化 ---
Plug 'tpope/vim-commentary'                  " コメントアウト (gcc)
Plug 'tpope/vim-surround'                    " 括弧・引用符操作
Plug 'jiangmiao/auto-pairs'                  " 括弧自動補完

" --- ステータスライン ---
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" ======================================================================
" coc.nvim 設定（LSP補完）
" ======================================================================

" 補完メニューの設定
set updatetime=300
set shortmess+=c
set signcolumn=yes

" --- <Tab>で補完候補を選択 ---
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" --- 定義ジャンプ・参照検索 ---
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" --- エラー間移動 ---
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" --- リネーム ---
nmap <silent> <leader>rn <Plug>(coc-rename)

" --- コードアクション ---
nmap <silent> <leader>a <Plug>(coc-codeaction-cursor)

" --- マニュアル補完トリガー ---
inoremap <silent><expr> <C-Space> coc#refresh()

" --- 関数ヘルプを表示 ---
nmap <silent> K :call CocActionAsync('doHover')<CR>

" --- 診断メッセージを一覧表示 ---
nmap <silent> <leader>d :CocDiagnostics<CR>

" --- コードフォーマット ---
nmap <silent> <leader>f :call CocAction('format')<CR>

" --- 自動補完設定 ---
autocmd FileType php,kotlin setlocal omnifunc=coc#complete

" --- 保存時に自動フォーマット ---
autocmd BufWritePre *.php,*.kt,*.kts :call CocAction('format')

" ======================================================================
" 外観・操作性の微調整
" ======================================================================

" カラースキーム
colorscheme gruvbox

" タイトルバーにファイル名を表示
set title

" スクロールオフ（カーソルの上下余白）
set scrolloff=5

" マウス操作を有効化（必要なら無効にしても可）
set mouse=a

" ======================================================================
" NERDTree（ファイルツリー）
" ======================================================================
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFind<CR>
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$', '\.DS_Store', '__pycache__', '\.pyc$']
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" --- NERDTree Git ステータス表示 ---
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ 'Modified'  :'✹',
    \ 'Staged'    :'✚',
    \ 'Untracked' :'✭',
    \ 'Renamed'   :'➜',
    \ 'Unmerged'  :'═',
    \ 'Deleted'   :'✖',
    \ 'Dirty'     :'✗',
    \ 'Ignored'   :'☒',
    \ 'Clean'     :'✔︎',
    \ 'Unknown'   :'?',
    \ }
" 親ディレクトリにもステータスを表示（変更があるファイルを含むフォルダが目立つ）
let g:NERDTreeGitStatusShowIgnored = 0
let g:NERDTreeGitStatusUntrackedFilesMode = 'all'

" ======================================================================
" fzf（ファジーファインダー）
" ======================================================================
" Gitリポジトリならルートから、それ以外はカレントディレクトリから検索
nnoremap <C-p> :GFiles --cached --others --exclude-standard<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>h :History<CR>

" ======================================================================
" Git連携
" ======================================================================
" vim-fugitive
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gd :Gdiffsplit<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gl :Git log --oneline<CR>

" vim-gitgutter
set updatetime=100
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" ======================================================================
" vim-airline（ステータスライン）
" ======================================================================
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#coc#enabled = 1

" ======================================================================
" 言語サーバ（PHP + Kotlin）
" ======================================================================
" coc-settings.json で設定済み
