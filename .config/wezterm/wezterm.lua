-- WezTerm Configuration
local wezterm = require 'wezterm'
local action = wezterm.action
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- ローカル設定（SSH・起動コマンド等の環境固有情報は local.lua に分離）
local local_config_loaded, local_config = pcall(require, 'local')
if not local_config_loaded then local_config = {} end

-- ============================================================
-- カラーパレット - Tokyo Night
-- ============================================================
local palette = {
  scheme_name  = 'Tokyo Night',
  bg           = '#1a1b26',
  bg_dark      = '#16161e',
  bg_highlight = '#24283b',
  bg_hover     = '#3b4261',
  blue         = '#7aa2f7',
  purple       = '#bb9af7',
  purple_dim   = '#2e2546',
  fg           = '#c0caf5',
  comment      = '#565f89',
}

-- ============================================================
-- カラースキーム（ターミナル全体の配色）
-- ============================================================
config.color_scheme = palette.scheme_name

-- ============================================================
-- フォント
-- ============================================================
local font = {
  main       = 'MonaspiceNe Nerd Font',
  italic     = 'MonaspiceRn Nerd Font',
  fallback   = 'Hiragino Sans',
  weight     = 'Light',
  tab_weight = 'Medium',
  size       = 12.0,
  tab_size   = 11.0,
}

config.front_end = 'WebGpu'
config.font = wezterm.font(font.main, { weight = font.weight })
config.font_size = font.size
config.line_height = 0.9
config.cell_width = 0.9
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

config.font_rules = {
  {
    intensity = 'Normal',
    italic = false,
    font = wezterm.font_with_fallback({
      { family = font.main, weight = font.weight },
      font.fallback,
    }),
  },
  {
    intensity = 'Normal',
    italic = true,
    font = wezterm.font(font.italic, { weight = font.weight, italic = true }),
  },
}

-- ============================================================
-- ウィンドウ外観
-- ============================================================
local window_pad = 16

config.window_background_opacity = 1.0
config.macos_window_background_blur = 0
config.window_decorations = 'RESIZE|MACOS_FORCE_ENABLE_SHADOW'
config.window_padding = { left = window_pad, right = window_pad, top = window_pad, bottom = window_pad }
config.initial_rows = 45
config.initial_cols = 160

-- ============================================================
-- タブバー
-- ============================================================
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true

config.window_frame = {
  font = wezterm.font({ family = font.main, weight = font.tab_weight }),
  font_size = font.tab_size,
  active_titlebar_bg = palette.bg,
  inactive_titlebar_bg = palette.bg_dark,
}

config.colors = {
  tab_bar = {
    background = palette.bg,
    active_tab = {
      bg_color = palette.blue,
      fg_color = palette.bg,
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = palette.bg_highlight,
      fg_color = palette.comment,
    },
    inactive_tab_hover = {
      bg_color = palette.bg_hover,
      fg_color = palette.fg,
    },
    new_tab = {
      bg_color = palette.bg,
      fg_color = palette.blue,
    },
    new_tab_hover = {
      bg_color = palette.blue,
      fg_color = palette.bg,
    },
  },
}

-- タブタイトル: 番号 + ディレクトリ名（SSH時は紫で区別）

local local_hostname = wezterm.hostname()

--- cwd_uri からディレクトリ名とリモート判定を返す
local function parse_cwd(cwd_uri)
  if not cwd_uri then return '', false end
  local uri = tostring(cwd_uri)
  local host = uri:match('^file://([^/]*)')
  local is_remote = host and host ~= '' and host ~= 'localhost' and host ~= local_hostname
  local path = uri:gsub('^file://[^/]*', '')
  path = path:gsub('%%(%x%x)', function(hex_code) return string.char(tonumber(hex_code, 16)) end)
  local home = os.getenv('HOME') or ''
  if not is_remote and home ~= '' and path:sub(1, #home) == home then
    path = '~' .. path:sub(#home + 1)
  end
  path = path:gsub('/$', '')
  local dirname = path:match('[^/]+$') or path
  return dirname, is_remote
end

--- リモートタブ用の色付きスタイルを返す
local function remote_tab_style(is_active, title)
  local bg = is_active and palette.purple     or palette.purple_dim
  local fg = is_active and palette.bg         or palette.purple
  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = title },
  }
end

wezterm.on('format-tab-title', function(tab)
  local dirname, is_remote = parse_cwd(tab.active_pane.current_working_dir)
  local title = string.format(' %d: %s ', tab.tab_index + 1, dirname)
  if is_remote then
    return remote_tab_style(tab.is_active, title)
  end
  return title
end)

-- ============================================================
-- SSH接続（local.lua から読み込み）
-- ============================================================
config.ssh_domains = local_config.ssh_domains or {}

-- ============================================================
-- キーバインド
-- ============================================================
local pane_resize_step = 5
local default_shell = '/bin/zsh'
local tab_activate_count = 5

config.keys = {
  -- ペイン: 分割・閉じる
  { key = 'd', mods = 'CMD',       action = action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CMD|SHIFT', action = action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'w', mods = 'CMD',       action = action.CloseCurrentPane { confirm = false } },

  -- ペイン: フォーカス移動
  { key = 'h', mods = 'CMD|SHIFT', action = action.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'CMD|SHIFT', action = action.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'CMD|SHIFT', action = action.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'CMD|SHIFT', action = action.ActivatePaneDirection 'Down' },

  -- ペイン: サイズ調整
  { key = 'LeftArrow',  mods = 'CMD|OPT', action = action.AdjustPaneSize { 'Left',  pane_resize_step } },
  { key = 'RightArrow', mods = 'CMD|OPT', action = action.AdjustPaneSize { 'Right', pane_resize_step } },
  { key = 'UpArrow',    mods = 'CMD|OPT', action = action.AdjustPaneSize { 'Up',    pane_resize_step } },
  { key = 'DownArrow',  mods = 'CMD|OPT', action = action.AdjustPaneSize { 'Down',  pane_resize_step } },

  -- タブ: 新規作成
  { key = 't', mods = 'CMD', action = action.SpawnTab 'CurrentPaneDomain' },

  -- タブ: 切り替え（2系統のショートカットを提供）
  { key = 'LeftArrow',  mods = 'CTRL',      action = action.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CTRL',      action = action.ActivateTabRelative(1) },
  { key = 'LeftArrow',  mods = 'SHIFT|OPT', action = action.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'SHIFT|OPT', action = action.ActivateTabRelative(1) },

  -- タブ: 並び替え
  { key = 'LeftArrow',  mods = 'CMD|SHIFT', action = action.MoveTabRelative(-1) },
  { key = 'RightArrow', mods = 'CMD|SHIFT', action = action.MoveTabRelative(1) },

  -- タブ: 起動コマンドなしで新規作成
  { key = 'F12', action = action.SpawnCommandInNewTab { args = { default_shell, '-l' } } },

  -- フォントサイズ
  { key = '+', mods = 'CMD|SHIFT', action = action.IncreaseFontSize },
  { key = '-', mods = 'CMD',       action = action.DecreaseFontSize },
  { key = '0', mods = 'CMD',       action = action.ResetFontSize },
}

-- タブ: CMD + 数字キーで番号指定（1〜tab_activate_count）
for i = 1, tab_activate_count do
  table.insert(config.keys,
    { key = tostring(i), mods = 'CMD', action = action.ActivateTab(i - 1) }
  )
end

-- ============================================================
-- マウス操作
-- ============================================================
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = action.CompleteSelection 'ClipboardAndPrimarySelection',
  },
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = action.PasteFrom 'Clipboard',
  },
}

-- ============================================================
-- ペインの視認性
-- ============================================================
config.inactive_pane_hsb = {
  hue = 1.0,
  saturation = 0.5,
  brightness = 0.3,
}

-- ============================================================
-- 起動コマンド（環境固有の起動シーケンスは local.lua で上書き可能）
-- ============================================================
config.default_prog = local_config.default_prog or { default_shell, '-l' }

-- ============================================================
-- カーソル
-- ============================================================
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = 'EaseIn'
config.cursor_blink_ease_out = 'EaseOut'

-- ============================================================
-- 描画パフォーマンス
-- ============================================================
config.max_fps = 120
config.animation_fps = 60

-- ============================================================
-- 動作設定
-- ============================================================
config.scrollback_lines = 10000
config.audible_bell = 'Disabled'
config.check_for_updates = false
config.window_close_confirmation = 'NeverPrompt'

return config
