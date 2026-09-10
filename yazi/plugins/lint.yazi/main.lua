--- @since 26.9.1

local M = {}

-- Default linter configuration.
--
-- `M.linters` is keyed by (lowercased) file extension. `M.filenames` is
-- keyed by (lowercased) full file name, and is the fallback used for files
-- that don't carry a meaningful extension — dotfiles (`.zshrc`, `.env`) and
-- extension-less files (`Dockerfile`) both make `url.ext` return `nil`
-- (matching Rust's `Path::extension()`), so extension-based lookup alone
-- can never match them.
--
-- Override or extend either via `require("lint"):setup { linters = {...},
-- filenames = {...} }` in init.lua. User-supplied entries are merged on
-- top of these defaults one key at a time, so the plugin keeps working out
-- of the box and you only need to specify what you want to add or change.
--
-- Each entry (in either table):
--   cmd:   string, the executable to run
--   args:  function(path: string) -> table, argv passed to `cmd`
--   codes: optional table, exit code -> custom notification message,
--          for linters that distinguish "usage/config error" from
--          "found errors" via distinct exit codes
M.linters = {
	bash = { cmd = "shellcheck", args = function(p) return { p } end },
	c    = { cmd = "cppcheck",   args = function(p) return { "--quiet", p } end },
	cjs  = { cmd = "oxlint",     args = function(p) return { p } end },
	cpp  = { cmd = "cppcheck",   args = function(p) return { "--quiet", p } end },
	css  = { cmd = "biome",      args = function(p) return { "lint", p } end },
	csv  = { cmd = "csvclean",   args = function(p) return { "-n", p } end },
	cts  = { cmd = "oxlint",     args = function(p) return { p } end },
	h    = { cmd = "cppcheck",   args = function(p) return { "--quiet", p } end },
	hpp  = { cmd = "cppcheck",   args = function(p) return { "--quiet", p } end },
	htm  = { cmd = "biome",      args = function(p) return { "lint", p } end },
	html = { cmd = "biome",      args = function(p) return { "lint", p } end },
	js   = { cmd = "oxlint",     args = function(p) return { p } end },
	json = { cmd = "jq",         args = function(p) return { "empty", p } end },
	jsx  = { cmd = "oxlint",     args = function(p) return { p } end },
	lua  = { cmd = "luacheck",   args = function(p) return { p } end },
	mjs  = { cmd = "oxlint",     args = function(p) return { p } end },
	mk   = { cmd = "checkmake",  args = function(p) return { p } end },
	mts  = { cmd = "oxlint",     args = function(p) return { p } end },
	py   = { cmd = "ruff",       args = function(p) return { "check", p } end },
	sh   = { cmd = "shellcheck", args = function(p) return { p } end },
	sql  = { cmd = "sqlfluff",   args = function(p) return { "lint", "--dialect", "tsql", p } end },
	toml = { cmd = "taplo",      args = function(p) return { "lint", p } end },
	ts   = { cmd = "oxlint",     args = function(p) return { p } end },
	tsx  = { cmd = "oxlint",     args = function(p) return { p } end },
	xml  = { cmd = "xmllint",    args = function(p) return { "--noout", p } end },
	yaml = { cmd = "yamllint",   args = function(p) return { "-s", p } end },
	yml  = { cmd = "yamllint",   args = function(p) return { "-s", p } end },
	zsh  = { cmd = "zsh",        args = function(p) return { "-n", p } end },
}

M.filenames = {
	["dockerfile"]    = { cmd = "hadolint",      args = function(p) return { p } end },
	["makefile"]      = { cmd = "checkmake",     args = function(p) return { p } end },
	[".env"]          = { cmd = "dotenv-linter", args = function(p) return { p } end },
	[".bash_login"]   = { cmd = "shellcheck",    args = function(p) return { p } end },
	[".bash_logout"]  = { cmd = "shellcheck",    args = function(p) return { p } end },
	[".bash_profile"] = { cmd = "shellcheck",    args = function(p) return { p } end },
	[".bashrc"]       = { cmd = "shellcheck",    args = function(p) return { p } end },
	[".profile"]      = { cmd = "shellcheck",    args = function(p) return { p } end },
	[".zlogin"]       = { cmd = "zsh",           args = function(p) return { "-n", p } end },
	[".zlogout"]      = { cmd = "zsh",           args = function(p) return { "-n", p } end },
	[".zprofile"]     = { cmd = "zsh",           args = function(p) return { "-n", p } end },
	[".zshenv"]       = { cmd = "zsh",           args = function(p) return { "-n", p } end },
	[".zshrc"]        = { cmd = "zsh",           args = function(p) return { "-n", p } end },
}

--- Merge user-supplied linter config into the defaults.
--- Called as `require("lint"):setup { linters = {...}, filenames = {...} }`
--- from init.lua.
function M:setup(opts)
	opts = opts or {}
	for ext, linter in pairs(opts.linters or {}) do
		self.linters[ext:lower()] = linter
	end
	for name, linter in pairs(opts.filenames or {}) do
		self.filenames[name:lower()] = linter
	end
end

-- Sync context to get the hovered file details
local get_hovered = ya.sync(function()
	local h = cx.active.current.hovered
	if not h then
		return nil, nil
	end
	return h.url, h.cha.is_dir
end)

-- Tracks in-flight linter runs by file URL, so re-triggering the same file
-- while it's still being linted doesn't spawn a second, overlapping process.
-- Note: `Command:status()` (used previously) is already fully async under
-- the hood and never blocks Yazi's UI thread — plugin `entry()` bodies run
-- in an async context by default. The one real gap it left was this one:
-- nothing stopped two runs on the same file from overlapping. `spawn()`
-- gives us the `Child` handle *before* the process finishes, which is what
-- lets us guard against that.
local running = {}

-- Main plugin entry point
function M:entry()
	local url, is_dir = get_hovered()
	if not url then
		return ya.notify { title = "Lint", content = "No file hovered", level = "warn", timeout = 3 }
	end
	if is_dir then
		return ya.notify { title = "Lint", content = "Cannot lint a directory", level = "warn", timeout = 3 }
	end

	local ext = url.ext and url.ext:lower() or nil
	local linter = ext and self.linters[ext]
	if not linter and url.name then
		linter = self.filenames[url.name:lower()]
	end
	if not linter then
		local label = ext and ("\"." .. ext .. "\" files") or (url.name and ("\"" .. url.name .. "\"") or "this file")
		return ya.notify {
			title   = "Lint",
			content = "No linter defined for " .. label,
			level   = "warn",
			timeout = 3,
		}
	end

	local key = tostring(url)
	if running[key] then
		return ya.notify { title = "Lint", content = "Already linting this file", level = "warn", timeout = 2 }
	end

	local child, err = Command(linter.cmd):arg(linter.args(tostring(url))):spawn()
	if not child then
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

	running[key] = true
	local status, wait_err = child:wait()
	running[key] = nil

	if not status then
		return ya.notify {
			title   = "Lint",
			content = string.format("Failed to run \"%s\": %s", linter.cmd, tostring(wait_err)),
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
end

return M