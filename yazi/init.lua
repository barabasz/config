-- ~/.config/yazi/init.lua

-- proper date/time display format
function Linemode:mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		return ""
	end
	return os.date("%Y-%m-%d %H:%M", time)
end

function Linemode:btime()
	local time = math.floor(self._file.cha.btime or 0)
	if time == 0 then
		return ""
	end
	return os.date("%Y-%m-%d %H:%M", time)
end

-- full-border plugin: https://github.com/yazi-rs/plugins/tree/main/full-border.yazi
require("full-border"):setup()

-- git.yazi plugin: https://github.com/yazi-rs/plugins/tree/main/git.yazi
require("git"):setup {
	-- Order of status signs showing in the linemode
	order = 1500,
}

-- Owner and group info in status bar
Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ""
	end

	return ui.Line {
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		" ",
	}
end, 500, Status.RIGHT)

-- Link target in status bar
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return ui.Span(" -> " .. tostring(h.link_to)):fg("magenta")
	else
		return ""
	end
end, 3300, Status.LEFT)

-- Extra tab on startup
ya.emit("tab_create", { Url(os.getenv("HOME")) })
ya.emit("tab_swap", { -1 })
ya.emit("tab_switch", { 1 })