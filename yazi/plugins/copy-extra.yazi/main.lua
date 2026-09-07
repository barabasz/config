-- Copies a hovered file's metadata to the system clipboard.
-- Usage: plugin copy-extra -- <mode>
-- Modes: size, mtime, atime, btime, uid, gid

local get_hovered = ya.sync(function()
	local h = cx.active.current.hovered
	if not h then
		return nil
	end
	return {
		len   = h.cha.len,
		mtime = h.cha.mtime,
		atime = h.cha.atime,
		btime = h.cha.btime,
		uid   = h.cha.uid,
		gid   = h.cha.gid,
	}
end)

local function format_time(t)
	if not t then
		return "N/A"
	end
	-- mtime/atime/btime can arrive as a float with sub-second precision;
	-- os.date requires an integer, so floor it first.
	return os.date("%Y-%m-%d %H:%M:%S", math.floor(t))
end

return {
	entry = function(self, job)

		ya.dbg("copy-extra fired, mode:", job.args[1])

		local cha = get_hovered()
		if not cha then
			return ya.notify { title = "Copy", content = "No file hovered", timeout = 3, level = "warn" }
		end

		local mode = job.args[1]
		local text

		if mode == "size" then
			text = tostring(cha.len)
		elseif mode == "mtime" then
			text = format_time(cha.mtime)
		elseif mode == "atime" then
			text = format_time(cha.atime)
		elseif mode == "btime" then
			text = format_time(cha.btime)
		elseif mode == "uid" then
			text = cha.uid and tostring(cha.uid) or "N/A"
		elseif mode == "gid" then
			text = cha.gid and tostring(cha.gid) or "N/A"
		else
			return ya.err("copy-extra: unknown mode \"" .. tostring(mode) .. "\"")
		end

		ya.clipboard(text)
		ya.notify { title = "Copied", content = text, timeout = 2 }
	end,
}