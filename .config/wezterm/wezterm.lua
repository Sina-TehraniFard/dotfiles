-- WezTerm Configuration - Modern Style
local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ============================================================
-- ローカル設定の読み込み（機微情報は local.lua に分離）
-- ============================================================
local ok, local_config = pcall(require, 'local')
if not ok then local_config = {} end

-- ============================================================
-- 描画設定
-- ============================================================
config.front_end = "WebGpu"

-- ============================================================
-- カラースキーム - Tokyo Night
-- ============================================================
config.color_scheme = 'Tokyo Night'

-- ============================================================
-- フォント設定 - Monaspace Neon (GitHub製, Nerd Font版)
-- ============================================================
config.font = wezterm.font('MonaspiceNe Nerd Font', { weight = 'Light' })
config.font_size = 12.0

-- 行間を狭く（デフォルトは1.0）
config.line_height = 0.9

-- 文字間を狭く
config.cell_width = 0.9

-- リガチャ（合字）を有効化: => -> != など
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

config.font_rules = {
  {
    intensity = 'Normal',
    italic = false,
    font = wezterm.font_with_fallback({
      { family = 'MonaspiceNe Nerd Font', weight = 'Light' },
      'Hiragino Sans',
    }),
  },
  -- イタリックは筆記体風の Radon スタイルを使用
  {
    intensity = 'Normal',
    italic = true,
    font = wezterm.font('MonaspiceRn Nerd Font', { weight = 'Light', italic = true }),
  },
}

-- ============================================================
-- ウィンドウスタイル - モダン
-- ============================================================
-- 透明度なし
config.window_background_opacity = 1.0
config.macos_window_background_blur = 0

-- ウィンドウ装飾
config.window_decorations = "RESIZE|MACOS_FORCE_ENABLE_SHADOW"

-- パディング（余白を広めに）
config.window_padding = {
  left = 16,
  right = 16,
  top = 16,
  bottom = 16,
}

-- ウィンドウサイズ
config.initial_rows = 45
config.initial_cols = 160

-- ============================================================
-- タブバー - ファンシースタイル
-- ============================================================
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true

-- タブタイトルを番号+ディレクトリに（SSH時は色を変える）
local local_hostname = wezterm.hostname()
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local cwd_uri = tab.active_pane.current_working_dir
  local is_remote = false
  local dirname = ''

  if cwd_uri then
    local uri = tostring(cwd_uri)
    -- ホスト名を取得してリモートか判定
    local host = uri:match('^file://([^/]*)')
    if host and host ~= '' and host ~= 'localhost' and host ~= local_hostname then
      is_remote = true
    end
    local path = uri:gsub('^file://[^/]*', '')
    -- URLデコード（%20 → スペース等）
    path = path:gsub('%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    -- ホームディレクトリを ~ に置換
    local home = os.getenv('HOME') or ''
    if not is_remote and home ~= '' and path:sub(1, #home) == home then
      path = '~' .. path:sub(#home + 1)
    end
    -- 末尾のスラッシュを除去
    path = path:gsub('/$', '')
    -- 最後のディレクトリ名だけ取得
    dirname = path:match('[^/]+$') or path
  end

  local title = string.format(' %d: %s ', tab.tab_index + 1, dirname)

  if is_remote then
    if tab.is_active then
      return {
        { Background = { Color = '#bb9af7' } },
        { Foreground = { Color = '#1a1b26' } },
        { Text = title },
      }
    else
      return {
        { Background = { Color = '#2e2546' } },
        { Foreground = { Color = '#bb9af7' } },
        { Text = title },
      }
    end
  end

  return title
end)

-- タブバーの色をカスタマイズ（Tokyo Nightに合わせる）
config.window_frame = {
  font = wezterm.font({ family = 'MonaspiceNe Nerd Font', weight = 'Medium' }),
  font_size = 11.0,
  active_titlebar_bg = '#1a1b26',
  inactive_titlebar_bg = '#16161e',
}

config.colors = {
  tab_bar = {
    background = '#1a1b26',
    active_tab = {
      bg_color = '#7aa2f7',
      fg_color = '#1a1b26',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#24283b',
      fg_color = '#565f89',
    },
    inactive_tab_hover = {
      bg_color = '#3b4261',
      fg_color = '#c0caf5',
    },
    new_tab = {
      bg_color = '#1a1b26',
      fg_color = '#7aa2f7',
    },
    new_tab_hover = {
      bg_color = '#7aa2f7',
      fg_color = '#1a1b26',
    },
  },
}

-- ============================================================
-- SSH接続設定（local.lua から読み込み）
-- ============================================================
config.ssh_domains = local_config.ssh_domains or {}

-- ============================================================
-- キーバインド
-- ============================================================
config.keys = {
  -- ペイン操作
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },

  -- ペイン間移動
  {
    key = 'h',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },

  -- タブ操作
  {
    key = 't',
    mods = 'CMD',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  { key = '1', mods = 'CMD', action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = 'CMD', action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = 'CMD', action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = 'CMD', action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = 'CMD', action = wezterm.action.ActivateTab(4) },

  -- Ctrl + 矢印でタブ切り替え
  {
    key = 'LeftArrow',
    mods = 'CTRL',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'RightArrow',
    mods = 'CTRL',
    action = wezterm.action.ActivateTabRelative(1),
  },

  -- Shift + Option + 矢印でタブ間を切り替え
  {
    key = 'LeftArrow',
    mods = 'SHIFT|OPT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'RightArrow',
    mods = 'SHIFT|OPT',
    action = wezterm.action.ActivateTabRelative(1),
  },

  -- 新タブ（sinaなし）
  {
    key = 'F12',
    action = wezterm.action.SpawnCommandInNewTab {
      args = { '/bin/zsh', '-l' },
    },
  },

  -- ペインサイズ調整
  {
    key = 'LeftArrow',
    mods = 'CMD|OPT',
    action = wezterm.action.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'RightArrow',
    mods = 'CMD|OPT',
    action = wezterm.action.AdjustPaneSize { 'Right', 5 },
  },
  {
    key = 'UpArrow',
    mods = 'CMD|OPT',
    action = wezterm.action.AdjustPaneSize { 'Up', 5 },
  },
  {
    key = 'DownArrow',
    mods = 'CMD|OPT',
    action = wezterm.action.AdjustPaneSize { 'Down', 5 },
  },

  -- フォントサイズ
  {
    key = '+',
    mods = 'CMD|SHIFT',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = '-',
    mods = 'CMD',
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = '0',
    mods = 'CMD',
    action = wezterm.action.ResetFontSize,
  },
}

-- ============================================================
-- 起動時コマンド
-- ============================================================
-- -l オプションでログインシェルとして起動（/etc/pathsを読み込むため）
config.default_prog = { '/bin/zsh', '-lic', 'sina; exec /bin/zsh -l' }

-- ============================================================
-- ペイン設定 - 非アクティブペインのコントラスト
-- ============================================================
-- 非アクティブペイン（操作していない側）を暗くして区別しやすくする
config.inactive_pane_hsb = {
  hue = 1.0,         -- 色相はそのまま
  saturation = 0.5,  -- 彩度を半分に（色がかなり薄くなる）
  brightness = 0.3,  -- 明度を大幅に下げる（かなり暗い）
}

-- ============================================================
-- マウス操作
-- ============================================================
config.mouse_bindings = {
  -- 選択完了時（左クリック離したとき）にクリップボードにコピー
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection',
  },
  -- 右クリックでペースト
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

-- ============================================================
-- その他
-- ============================================================
config.scrollback_lines = 10000
config.audible_bell = "Disabled"
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 500
config.check_for_updates = false
config.window_close_confirmation = 'NeverPrompt'

-- アニメーション・描画設定
config.max_fps = 120           -- 描画の最大フレームレート
config.animation_fps = 60
config.cursor_blink_ease_in = 'EaseIn'
config.cursor_blink_ease_out = 'EaseOut'

return config
