local wezterm = require 'wezterm';

wezterm.on("update-right-status", function(window, pane)
  -- example output: "Wed Mar 3 08:14"
  local date = wezterm.strftime("%a %b %-d %H:%M ");

  local bat = ""
  for _, b in ipairs(wezterm.battery_info()) do
    bat = "🔋 " .. string.format("%.0f%%", b.state_of_charge * 100)
  end

  window:set_right_status(wezterm.format({
    {Text=bat .. "   "..date},
  }));
end)

return {
  enable_wayland = true,
  -- scrollback lines per tab. Yes, I hate losing information. TODO: figure out a sensible amount that won't make me go out of RAM (32 GB)
  scrollback_lines = 368500,
  -- Enable the scrollbar.
  -- It will occupy the right window padding space.
  -- If right padding is set to 0 then it will be increased
  -- to a single cell width
  enable_scroll_bar = true,
}
