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

" --- LSP補完の中核（VSCode級の補完を実現） ---
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" --- カラースキーム（好みに応じて） ---
Plug 'morhetz/gruvbox'

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
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" --- 定義ジャンプ・参照検索など ---
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

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
" 言語サーバ関連（PHP + Kotlin）
" ======================================================================

" PHP: intelephense を利用
" Kotlin: kotlin-language-server を利用
" これらは coc.nvim の拡張として別途インストールする:
"   :CocInstall coc-php
"   :CocInstall coc-kotlin
"
" これにより以下が有効になる:
" - 自動補完（$this-> / val / fun）
" - 定義ジャンプ（gd）
" - ドキュメント表示（K）
" - 診断・警告表示（左側のsigncolumn）

" ======================================================================
" 終了
" ======================================================================
