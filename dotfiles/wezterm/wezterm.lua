-- ~/.config/wezterm/wezterm.lua
-- Identical on Linux and macOS. This file moves to the MacBook untouched.

local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- ── appearance ───────────────────────────────────────────────────────────────
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font_with_fallback({
  { family = "FiraCode Nerd Font", weight = "Medium" },
  { family = "Fira Code" },
  "JetBrains Mono",
  "Symbols Nerd Font Mono",
})
config.font_size = 12.5
config.line_height = 1.05
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" } -- ligatures on

config.window_background_opacity = 0.94
config.macos_window_background_blur = 24 -- ignored on linux, used next year
config.window_decorations = "RESIZE"
config.window_padding = { left = 12, right = 12, top = 10, bottom = 6 }
config.inactive_pane_hsb = { saturation = 0.85, brightness = 0.70 }

config.scrollback_lines = 20000
config.enable_scroll_bar = false
config.audible_bell = "Disabled"
config.default_cursor_style = "BlinkingBar"

-- Tab bar: minimal, shows the active process so agent panes are identifiable
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.tab_max_width = 28

-- ── performance ──────────────────────────────────────────────────────────────
config.front_end = "WebGpu"
config.webgpu_power_preference = "LowPower" -- laptop battery; flip to HighPerformance on desktop
config.max_fps = 120

-- ── keys ─────────────────────────────────────────────────────────────────────
-- Leader is Ctrl-a, matching tmux, so muscle memory is shared.
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

local mod = "CTRL|SHIFT"
config.keys = {
  -- panes
  { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "-", mods = "LEADER",       action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "h", mods = "LEADER",       action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER",       action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER",       action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER",       action = act.ActivatePaneDirection("Right") },
  { key = "z", mods = "LEADER",       action = act.TogglePaneZoomState },
  { key = "x", mods = "LEADER",       action = act.CloseCurrentPane({ confirm = true }) },

  -- tabs
  { key = "t", mods = mod, action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = mod, action = act.CloseCurrentTab({ confirm = true }) },
  { key = "[", mods = mod, action = act.ActivateTabRelative(-1) },
  { key = "]", mods = mod, action = act.ActivateTabRelative(1) },

  -- search / copy mode
  { key = "f", mods = mod, action = act.Search({ CaseInSensitiveString = "" }) },
  { key = "/", mods = "LEADER", action = act.ActivateCopyMode },

  -- font size
  { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
  { key = "0", mods = "CTRL", action = act.ResetFontSize },

  -- quick-launch the agent workspace
  { key = "c", mods = "LEADER", action = act.SpawnCommandInNewTab({ args = { "crew" } }) },
}

-- ── status bar: git branch + time, right-aligned ─────────────────────────────
wezterm.on("update-right-status", function(window, pane)
  local cwd = pane:get_current_working_dir()
  local dir = cwd and cwd.file_path and cwd.file_path:gsub(os.getenv("HOME") or "", "~") or ""
  window:set_right_status(wezterm.format({
    { Foreground = { Color = "#7f849c" } },
    { Text = dir .. "   " .. wezterm.strftime("%H:%M") .. " " },
  }))
end)

-- ── links: make file paths and URLs clickable ────────────────────────────────
config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
  regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
  format = "https://www.github.com/$1/$3",
})

return config
