-- ~/.config/yazi/plugins/lint.yazi/main.lua
-- Runs an extension-appropriate linter on the hovered file.

local LINTERS = {
	json = { cmd = "jq",       args = function(p) return { "empty", p } end },
	toml = { cmd = "taplo",    args = function(p) return { "lint", p } end },
	yaml = { cmd = "yamllint", args = function(p) return { "-s", p } end },
	yml  = { cmd = "yamllint", args = function(p) return { "-s", p } end },
	xml  = { cmd = "xmllint",  args = function(p) return { "--noout", p } end },
	py   = { cmd = "ruff",     args = function(p) return { "check", p } end },
	js   = { cmd = "oxlint",   args = function(p) return { p } end },
}

local get_hovered_url = ya.sync(function()
	local h = cx.active.current.hovered
	return h and h.url or nil
end)

return {
	entry = function()
		local url = get_hovered_url()
		if not url then
			return ya.notify { title = "Lint", content = "No file hovered", level = "warn", timeout = 3 }
		end

		local ext = url.ext and url.ext:lower() or nil
		local linter = ext and LINTERS[ext]
		if not linter then
			return ya.notify {
				title   = "Lint",
				content = string.format("No linter defined for \".%s\" files", ext or "?"),
				level   = "warn",
				timeout = 3,
			}
		end

		local status, err = Command(linter.cmd):arg(linter.args(tostring(url))):status()

		if not status then
			if err and err.kind == "NotFound" then
				return ya.notify {
					title   = "Lint",
					content = string.format("Cannot lint: \"%s\" is not installed", linter.cmd),
					level   = "warn",
					timeout = 4,
				}
			end
			return ya.notify {
				title   = "Lint",
				content = string.format("Failed to run \"%s\": %s", linter.cmd, tostring(err)),
				level   = "error",
				timeout = 4,
			}
		end

		if status.success then
			return ya.notify { title = "Lint", content = "File OK", level = "info", timeout = 2 }
		end

		local special = linter.codes and linter.codes[status.code]
		ya.notify {
			title   = "Lint",
			content = special or "File has errors",
			level   = special and "error" or "warn",
			timeout = 4,
		}
	end,
}