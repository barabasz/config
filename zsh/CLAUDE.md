# Zsh Configuration - Claude Documentation

## Table of Contents

- [Overview](#overview)
- [Philosophy & Principles](#philosophy--principles)
- [Directory Structure](#directory-structure)
- [Core Components](#core-components)
- [Naming Conventions](#naming-conventions)
- [File Tracking System](#file-tracking-system)
- [Development Guidelines](#development-guidelines)
- [Examples & Use Cases](#examples--use-cases)

---

## Overview

This is a modular, performance-optimized zsh configuration focused on maintainability, tracking, and fast startup times. The configuration is split across multiple specialized directories with a clear separation of concerns.

**Key Features:**
- File tracking system with performance monitoring
- Modular library of helper functions
- Lazy loading for heavy applications
- Dynamic loading of all library and app files
- Autoloaded user functions
- Comprehensive aliasing system

**Version:** Tracked via `$ZSH_CONFIG_VERSION` in `.zshenv`

---

## Philosophy & Principles

### Core Values

1. **Performance First**
   - Track loading times of all sourced files
   - Lazy load heavy applications
   - Minimize startup time
   - Dynamic loading (no compilation)

2. **Modularity**
   - Each component in separate file
   - Clear single responsibility
   - Easy to enable/disable features

3. **Zsh-Native**
   - Write for zsh exclusively (no bash compatibility)
   - Use zsh-specific features: `[[ ]]`, `print`, `whence`, parameter expansion
   - Leverage zsh builtins whenever possible

4. **Explicit Over Implicit**
   - Function names clearly describe purpose
   - Consistent naming conventions
   - Documented behavior

5. **Maintainability**
   - Self-documenting code
   - Clear structure
   - Easy debugging with `ZSH_DEBUG=1`

### Design Decisions

- **No compatibility layers** - zsh only, no sh/bash/ksh support
- **Helper library** - Small, fast functions loaded first in `.zshenv`
- **Application configs** - Loaded last, can depend on helpers
- **Tracking everywhere** - Every file reports loading time
- **Dynamic loading** - All files in `lib/` and `apps/` are sourced dynamically at shell startup

---

## Directory Structure

```
~/.config/zsh/
├── .zshenv           # Main entry point (always sourced)
├── .zprofile         # Login shell initialization
├── .zshrc            # Interactive shell setup
├── .zlogin           # Post-login actions
├── .zlogout          # Logout cleanup
├── .zsh_history      # Command history
├── inc/              # Core includes
│   ├── zfiles.zsh       # Shell files tracking infrastructure
│   ├── xdg.zsh          # XDG Base Directories
│   ├── variables.zsh    # Environment variables
│   ├── bootstrap.zsh    # Bootstrap functions & colors
│   ├── path.zsh         # PATH configuration
│   ├── hashdirs.zsh     # Named directory hashes
│   ├── aliases.zsh      # Aliases
│   └── locales.zsh      # Locale settings
├── lib/              # Helper library (fast utilities)
│   ├── files.zsh        # File/path test functions
│   ├── system.zsh       # OS detection & info
│   ├── strings.zsh      # String manipulation
│   ├── shell.zsh        # Shell info functions
│   └── varia.zsh        # Miscellaneous helpers
├── apps/             # Application integrations
│   ├── _omz.zsh         # Oh-my-zsh (with _ to be loaded first)
│   ├── brew.zsh         # Homebrew
│   ├── omp.zsh          # Oh My Posh (prompt engine)
│   └── ...              # Other apps
├── functions/        # Autoloaded user functions
│   ├── sysinfo          # System information display
│   ├── logininfo        # Login details
│   ├── zfiles           # Show tracked files
│   └── ...              # Other functions
└── cache/            # Runtime cache
    └── sessions/     # Zsh sessions
```

---

## Core Components

### 1. `.zshenv` - Entry Point

**Purpose:** Always sourced first, sets up tracking and loads critical components.

**Responsibilities:**
- Set `$ZDOTDIR` and core zsh directory variables
- Load file tracking system (`zfiles.zsh`)
- Load XDG directories, environment variables, bootstrap functions
- Source entire `lib/` directory (helper functions)
- Configure PATH and locale

**Key Variables:**
```zsh
ZDOTDIR=$HOME/.config/zsh
ZSH_CONFIG_VERSION="20260106v1"
ZSH_DEBUG=0              # Set to 1 for verbose output
ZSH_LOGIN_INFO=1         # Show login info
ZSH_SYS_INFO=0           # Show system info
```

**Flow:**
```
.zshenv
  → inc/zfiles.zsh (file tracking setup)
  → inc/xdg.zsh (XDG directories)
  → inc/variables.zsh (environment exports)
  → inc/bootstrap.zsh (colors, helpers)
  → lib/*.zsh (all helper functions)
  → inc/path.zsh (PATH configuration)
  → inc/locales.zsh (locale settings)
```

### 2. `inc/zfiles.zsh` - File Tracking Infrastructure

**Purpose:** Provides tracking functions for measuring load times of sourced files.

**Exports:**
- `ZFILES` - associative array: filepath → status (0=loading, 1=loaded)
- `ZFILES_TIME` - associative array: filepath → load time in ms
- `ZFILES_START` - associative array: filepath → start time
- `ZFILES_ORDER` - array of filepaths in load order
- `zfile_track_start()` - Start tracking a file
- `zfile_track_end()` - End tracking and calculate time

### 3. `inc/xdg.zsh` - XDG Base Directories

**Purpose:** Set XDG Base Directory Specification variables.

**Exports:**
```zsh
XDG_CONFIG_HOME=$HOME/.config
XDG_CACHE_HOME=$HOME/.local/cache
XDG_BIN_HOME=$HOME/.local/bin
XDG_DATA_HOME=$HOME/.local/share
XDG_STATE_HOME=$HOME/.local/state
XDG_RUNTIME_DIR=$HOME/.xdg
# User directories
XDG_DESKTOP_DIR, XDG_DOCUMENTS_DIR, XDG_DOWNLOAD_DIR, etc.
```

### 4. `inc/variables.zsh` - Environment Variables

**Purpose:** Set general environment variables.

**Key Exports:**
```zsh
# History
HISTFILE, HISTSIZE, SAVEHIST

# Folders
TMP, BINDIR, LIBDIR, DLDIR, DOCDIR, CACHEDIR, VENVDIR

# Editors
EDITOR='nvim', VISUAL='code', PAGER='less'

# Prompt fallback
PS1="[%F{cyan}%n%f@%F{green}%m%f:%F{yellow}%~%f]$ "
```

### 5. `inc/bootstrap.zsh` - Core Functions

**Purpose:** Provide essential functions needed during initialization.

**Exports:**
- ANSI color codes (interactive only): `$r`, `$g`, `$y`, `$b`, `$p`, `$c`, `$w`, `$x` (reset)
- Bright variants: `$br`, `$bg`, `$by`, `$bb`, `$bp`, `$bc`, `$bw`
- `is_debug()` - Check if debug mode enabled
- `source_zsh_dir()` - Source all .zsh files in directory
- `source_time()` - Print source time for file

**Usage:**
```zsh
source_zsh_dir "$ZAPPDIR"  # Load all app configs
if is_debug; then
    print "Debug mode active"
fi
```

### 6. `inc/path.zsh` - PATH Configuration

**Purpose:** Build PATH with platform-specific directories.

**Features:**
- Adds common paths: `$BINDIR`, `~/.local/bin`, `/usr/local/bin`
- macOS-specific: `/opt/homebrew/bin`, VSCode path
- Linux-specific: linuxbrew paths, `/snap/bin`
- Removes duplicates and non-existent directories

### 7. `inc/hashdirs.zsh` - Named Directories

**Purpose:** Create directory shortcuts using zsh hash feature.

**Exports:**
```zsh
hash -d bin=$BINDIR
hash -d conf=$CONFDIR
hash -d gh=$GHDIR
hash -d zsh=$ZDOTDIR
# Usage: cd ~zsh, ls ~gh
```

### 8. `inc/aliases.zsh` - Aliases

**Purpose:** Define command aliases with dependency checks.

**Categories:**
- Global aliases: `alias -g G='| grep'`
- Common aliases: `cls`, `reload`, `myip`, `ds`
- Application-specific (only if installed): bat, brew, eza, git, nvim, zoxide, etc.

### 9. `inc/locales.zsh` - Locale Settings

**Purpose:** Configure language and locale settings.

**Features:**
- English language (`LANG=en_US.UTF-8`)
- Polish locale for formatting (`LC_*=pl_PL.UTF-8`)
- Auto-generation of locales on Debian-based systems

### 10. `lib/` - Helper Library

**Purpose:** Fast, frequently-used utility functions loaded in `.zshenv`.

**Categories:**

#### `lib/files.zsh` - File System Tests
```zsh
is_file PATH        # True if regular file
is_dir PATH         # True if directory
is_link PATH        # True if symbolic link
is_exists PATH      # True if path exists (any type)
is_hardlink PATH    # True if hard link (link count > 1)
is_block_device PATH
is_char_device PATH
is_pipe PATH
is_socket PATH
```

#### `lib/system.zsh` - OS Detection & Info
```zsh
is_debian           # True if pure Debian
is_debian_based     # True if Debian-based (Ubuntu, Mint, etc.)
is_ubuntu           # True if Ubuntu
is_macos            # True if macOS
is_linux            # True if Linux
os_name             # Return OS name string
os_version          # Return OS version
os_codename         # Return codename (Sequoia, Bookworm, etc.)
os_icon             # Return Nerd Font icon
```

#### `lib/strings.zsh` - String Manipulation
```zsh
get_version STRING  # Extract version number from string
                    # Example: get_version "zsh 5.9" → "5.9"
```

#### `lib/shell.zsh` - Shell Info
```zsh
shell_ver           # Get zsh version number
```

#### `lib/varia.zsh` - Miscellaneous Utilities
```zsh
is_debug            # True if ZSH_DEBUG=1 or DEBUG=1
etime CMD [ARGS]    # Measure command execution time
is_installed CMD... # True if all commands exist
try_source FILE [CALLER] # Source file with error handling
```

### 11. `apps/` - Application Integrations

**Purpose:** Configure external tools and applications. Loaded last in `.zshrc`.

**Naming Convention:** 
- `apps/{tool}.zsh` - regular app config
- `apps/_{tool}.zsh` - prefixed with `_` to load first (alphabetical order)

**Current Apps:**
| File | Purpose |
|------|---------|
| `_omz.zsh` | Oh My Zsh (loaded first for OMP hooks) |
| `acme.zsh` | ACME.sh SSL certificates |
| `bat.zsh` | bat (cat replacement) |
| `brew.zsh` | Homebrew |
| `fzf.zsh` | fzf fuzzy finder |
| `git.zsh` | GitHub directories |
| `omp.zsh` | Oh My Posh prompt |
| `python.zsh` | Python virtual environment |
| `rust.zsh` | Rust/Cargo environment |
| `ssh.zsh` | SSH configuration |
| `thefuck.zsh` | thefuck (lazy loaded) |
| `yazi.zsh` | yazi file manager |
| `zoxide.zsh` | zoxide (z command) |

**Template Structure:**
```zsh
#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# {Tool Name} configuration

if is_installed {tool}; then
    # Configuration here
fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}
```

### 12. `functions/` - Autoloaded Functions

**Purpose:** Complex user functions that are autoloaded on demand.

**Current Functions:**
| Function | Purpose |
|----------|---------|
| `htime` | Convert seconds to human-readable time |
| `lanip` | Get local IP address |
| `wanip` | Get public IP address |
| `logininfo` | Display login information |
| `sysinfo` | Display system information |
| `uptimeh` | Get uptime in human format |
| `zfiles` | Show loaded files report |

### 13. `.zshrc` - Interactive Shell

**Purpose:** Set up interactive shell features.

**Flow:**
```
.zshrc
  → autoload zmv, colors
  → autoload functions/*
  → inc/aliases.zsh
  → apps/*.zsh (all apps)
  → inc/hashdirs.zsh
```

### 14. `.zlogin` - Post-Login

**Purpose:** Actions after login shell initialization.

**Responsibilities:**
- Clean up temporary variables
- Display system info (if `ZSH_SYS_INFO=1`)
- Display login info (if `ZSH_LOGIN_INFO=1`)
- Calculate total load time
- Cleanup tracking variables

---

## Naming Conventions

### Function Names

**Test/Check Functions:**
- Prefix: `is_`
- Return: 0 (true) or 1 (false)
- Examples: `is_file`, `is_macos`, `is_installed`

**Info Functions:**
- Suffix: `_name`, `_version`, `_icon`, etc.
- Return: string via `print`
- Examples: `os_name`, `shell_ver`, `os_icon`

**Action Functions:**
- Verb prefix: `get_`, `try_`
- Examples: `get_version`, `try_source`

**Utility Functions:**
- Short, descriptive names
- Examples: `etime`, `sysinfo`

### Variable Names

**Environment Variables:**
- Uppercase
- Descriptive
- Examples: `ZDOTDIR`, `HOMEBREW_PREFIX`, `OMP_THEME`

**Local Variables:**
- Lowercase
- Snake_case for multi-word
- Examples: `filepath`, `file_name`, `start_time`

**Color Variables:**
- Single letter for basic colors: `r`, `g`, `y`, `b`, `p`, `c`, `w`, `x`
- Prefix `b` for bright: `br`, `bg`, `by`, etc.
- Reset: `x`

### File Names

**Library Files:** `{category}.zsh`
- Examples: `files.zsh`, `system.zsh`, `strings.zsh`

**App Files:** `{tool}.zsh` or `_{tool}.zsh` (for priority loading)
- Examples: `brew.zsh`, `fzf.zsh`, `_omz.zsh`

**Include Files:** `{purpose}.zsh`
- Examples: `bootstrap.zsh`, `path.zsh`, `aliases.zsh`

**Functions:** No extension, lowercase
- Examples: `sysinfo`, `logininfo`, `zfiles`

---

## File Tracking System

### Purpose

Track which files are loaded and measure their loading time for performance optimization.

### Global Variables

```zsh
typeset -A ZFILES          # filepath → status (0=loading, 1=loaded)
typeset -A ZFILES_TIME     # filepath → load time in ms
typeset -A ZFILES_START    # filepath → start time (EPOCHREALTIME)
typeset -a ZFILES_ORDER    # array of filepaths in load order
```

### Tracking Functions

```zsh
zfile_track_start ${0:A}   # Start tracking (top of file)
zfile_track_end ${0:A}     # End tracking (bottom of file)
```

### Debug Output

When `ZSH_DEBUG=1`:
```
✅ bootstrap.zsh sourced in 1.89ms
✅ xdg.zsh sourced in 0.45ms
✅ files.zsh sourced in 0.67ms
...
```

### Usage Pattern

**Every sourced file must have:**
```zsh
#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# ... file content ...

# shell files tracking - keep at the end
zfile_track_end ${0:A}
```

**Special case - main files:**
```zsh
# In .zshrc, .zlogin, etc:
zfile_track_start "$ZDOTDIR/.zshrc"
# ... content ...
zfile_track_end "$ZDOTDIR/.zshrc"
```

### Reporting

Use `zfiles` function to see full report:
```zsh
❯ zfiles
Zsh Shell Configuration Load Time Report
=========================================
 1. ✓ .zshenv              12.45 ms
 2. ✓   xdg.zsh             0.45 ms  inc
 3. ✓   variables.zsh       0.32 ms  inc
 4. ✓   bootstrap.zsh       1.89 ms  inc
 5. ✓   files.zsh           0.67 ms  lib
 6. ✓   system.zsh          1.23 ms  lib
 7. ✓   strings.zsh         0.45 ms  lib
 8. ✓   shell.zsh           0.34 ms  lib
 9. ✓   varia.zsh           0.78 ms  lib
10. ✓   path.zsh            0.56 ms  inc
11. ✓   locales.zsh         0.89 ms  inc
12. ✓ .zshrc                8.91 ms
13. ✓   aliases.zsh         2.45 ms  inc
14. ✓   brew.zsh            3.21 ms  apps
15. ✓   omp.zsh            45.67 ms  apps
16. ✓   hashdirs.zsh        0.12 ms  inc
------------------------------------------
Total loading time:        80.39 ms
```

**Color coding:**
- Green: < 1ms
- White: 1-5ms
- Yellow: 5-10ms
- Red: > 10ms

---

## Development Guidelines

### Adding New Helper Functions

1. **Choose appropriate file:**
   - File tests → `lib/files.zsh`
   - OS detection → `lib/system.zsh`
   - String operations → `lib/strings.zsh`
   - Shell info → `lib/shell.zsh`
   - General utilities → `lib/varia.zsh`

2. **Follow naming conventions:**
   - Tests: `is_*` → return 0/1
   - Info: `*_name`, `*_version` → print string
   - Actions: `get_*`, `try_*`

3. **Write zsh-native code:**
   ```zsh
   # Good - zsh native
   is_file() {
       [[ $# -eq 1 && -f "$1" ]]
   }
   
   # Bad - bash-compatible
   is_file() {
       if [ $# -eq 1 ] && [ -f "$1" ]; then
           return 0
       else
           return 1
       fi
   }
   ```

4. **Use zsh features:**
   - `[[ ]]` instead of `[ ]`
   - `print` instead of `echo`
   - `(( ))` for arithmetic
   - Parameter expansion
   - Pattern matching

5. **Keep functions small and focused:**
   ```zsh
   # Good - single responsibility
   is_macos() {
       [[ $OSTYPE == darwin* ]]
   }
   ```

6. **Add tracking:**
   ```zsh
   #!/bin/zsh
   # Shell files tracking - keep at the top
   zfile_track_start ${0:A}
   
   # Your functions here
   
   # shell files tracking - keep at the end
   zfile_track_end ${0:A}
   ```

7. **Test thoroughly:**
   ```zsh
   is_file /etc/hosts     # should return 0
   is_file /etc           # should return 1
   is_file /nonexistent   # should return 1
   ```

### Adding New App Integration

1. **Create file:** `apps/{tool}.zsh`

2. **Use template:**
   ```zsh
   #!/bin/zsh
   # Shell files tracking - keep at the top
   zfile_track_start ${0:A}
   
   # {Tool Name} configuration
   
   if is_installed {tool}; then
       # Configuration here
   fi
   
   # shell files tracking - keep at the end
   zfile_track_end ${0:A}
   ```

3. **For priority loading:** Use `_` prefix (e.g., `_omz.zsh` loads before `omp.zsh`)

4. **Check installation:**
   ```zsh
   if is_installed mytool; then
       # Only configure if available
   fi
   ```

5. **Use lazy loading for slow tools:**
   ```zsh
   # Instead of:
   eval "$(slowtool init zsh)"
   
   # Use:
   slowtool() {
       unfunction slowtool
       eval "$(command slowtool init zsh)"
       slowtool "$@"
   }
   ```

### Adding New User Function

1. **Create file:** `functions/{name}` (no extension)

2. **Write function body directly** (no function declaration needed):
   ```zsh
   # functions/myinfo
   local hostname=$(hostname)
   local os=$(os_name)
   
   print "Host: $hostname"
   print "OS: $os"
   ```

3. **Available in autoloaded functions:**
   - All `lib/*` functions
   - All environment variables
   - Color variables (if interactive)

4. **Test:**
   ```zsh
   # In new shell
   myinfo  # should work automatically
   ```

### Adding New Include File

1. **Create file:** `inc/{purpose}.zsh`

2. **Add tracking:**
   ```zsh
   #!/bin/zsh
   # Shell files tracking - keep at the top
   zfile_track_start ${0:A}
   
   # Content here
   
   # shell files tracking - keep at the end
   zfile_track_end ${0:A}
   ```

3. **Source it** in appropriate location (`.zshenv` or `.zshrc`)

### Performance Optimization

1. **Measure first:**
   ```zsh
   ZSH_DEBUG=1 zsh -lic "exit"
   # or
   zfiles
   ```

2. **Identify slow files:**
   - Look for times > 10ms
   - Check heavy initialization (eval, external commands)

3. **Optimize strategies:**
   - Lazy load heavy apps
   - Cache results
   - Avoid unnecessary forks
   - Use zsh builtins

4. **Lazy loading example:**
   ```zsh
   # See apps/thefuck.zsh for example
   fuck() {
       unfunction fuck
       eval $(thefuck --alias)
       fuck "$@"
   }
   ```

### Debugging

1. **Enable debug mode:**
   ```zsh
   export ZSH_DEBUG=1
   source ~/.zshenv
   ```

2. **Check specific file:**
   ```zsh
   zsh -n lib/files.zsh  # syntax check
   source lib/files.zsh  # test loading
   ```

3. **Test functions:**
   ```zsh
   is_file /etc/hosts && print "OK" || print "FAIL"
   print $(os_name)
   ```

4. **Common issues:**
   - Missing tracking calls
   - Wrong variable scope (local vs global)
   - PATH not set correctly
   - Function name conflicts

---

## Examples & Use Cases

### Example 1: OS-Specific Configuration

```zsh
# apps/mytool.zsh
#!/bin/zsh
zfile_track_start ${0:A}

if is_installed mytool; then
    if is_macos; then
        export MYTOOL_PATH=/opt/homebrew/opt/mytool
    elif is_debian_based; then
        export MYTOOL_PATH=/usr/local/mytool
    fi
    
    export PATH=$MYTOOL_PATH/bin:$PATH
fi

zfile_track_end ${0:A}
```

### Example 2: Conditional Feature Loading

```zsh
# Using try_source for optional files
try_source "$HOME/.secrets" "${0:t}"
try_source "$HOME/.local.zsh" "${0:t}"
```

### Example 3: Custom Info Function

```zsh
# functions/devinfo
local python_ver node_ver git_ver

python_ver=$(python3 --version 2>&1 | get_version)
node_ver=$(node --version 2>&1 | get_version)
git_ver=$(git --version 2>&1 | get_version)

print "Development Environment:"
print "  Python: ${y}${python_ver}${x}"
print "  Node.js: ${y}${node_ver}${x}"
print "  Git: ${y}${git_ver}${x}"
```

### Example 4: Performance Measurement

```zsh
# Measure startup time
$ time zsh -lic "exit"
zsh -lic "exit"  0.08s user 0.04s system 93% cpu 0.134 total

# Detailed breakdown
$ ZSH_DEBUG=1 zsh -lic "exit"
✅ bootstrap.zsh sourced in 1.89ms
✅ xdg.zsh sourced in 0.45ms
...

# View full report
$ zfiles
```

### Example 5: Lazy Loading Pattern

```zsh
# apps/heavytool.zsh
if is_installed heavytool; then
    heavytool() {
        unfunction heavytool
        eval "$(command heavytool init zsh)"
        heavytool "$@"
    }
fi
```

---

## Best Practices Summary

### Do's ✅

- **Always** use tracking in sourced files
- **Always** check installation before configuring
- **Always** use zsh-native syntax
- **Always** test functions before committing
- Use `is_installed` before configuring tools
- Use `is_debug` for conditional logging
- Use named directories (`~zsh`, `~gh`, etc.)
- Keep functions small and focused
- Document complex logic
- Use meaningful variable names
- Prefer builtins over external commands
- Use lazy loading for slow tools

### Don'ts ❌

- **Never** write bash-compatible code
- **Never** use `echo` (use `print`)
- **Never** use `[ ]` (use `[[ ]]`)
- **Never** skip tracking in sourced files
- **Never** assume tools are installed
- Don't use global variables in functions unnecessarily
- Don't create dependencies between lib files
- Don't put heavy operations in `.zshenv`
- Don't use subshells when not needed

### Code Style Checklist

```zsh
#!/bin/zsh
# ✅ Shebang present
# ✅ Tracking calls at top and bottom
zfile_track_start ${0:A}

# ✅ Check tool availability
if is_installed tool; then
    
    # ✅ Use zsh constructs
    [[ -f $file ]] && source "$file"
    
    # ✅ Use print for output
    print "Message"
    
    # ✅ Use (( )) for arithmetic
    (( count++ ))
    
    # ✅ Local variables in functions
    local var="value"
    
fi

# ✅ Tracking at end
zfile_track_end ${0:A}
```

---

## Troubleshooting

### Shell Starts Slowly

1. Check load times: `zfiles`
2. Identify slow files (> 10ms)
3. Consider lazy loading heavy apps
4. Check for unnecessary external commands

### Function Not Found

1. Check if in `lib/` or `functions/`
2. For `functions/`: check `$fpath`
3. Verify file permissions (functions should be readable)
4. Start new shell: `exec zsh`

### Changes Not Applied

1. For `lib/` or `inc/`: `source ~/.zshenv`
2. For `apps/`: `source ~/.zshrc`
3. Or start new shell: `exec zsh`

### Syntax Errors

1. Check syntax: `zsh -n file.zsh`
2. Enable debug: `ZSH_DEBUG=1 source file.zsh`
3. Test in isolation: `source file.zsh`

---

## Future Enhancements

### Planned Features

- [ ] Network detection functions (`is_connected`, `get_gateway`)
- [ ] Package manager abstraction (`pkg_install`, `pkg_update`)
- [ ] Git helper functions (`git_current_branch`, `git_is_dirty`)
- [ ] More string functions (`trim`, `lowercase`, `uppercase`)
- [ ] Math functions (`min`, `max`, `avg`)
- [ ] Array utilities (`array_contains`, `array_unique`)

### Performance Goals

- Total startup time < 100ms
- Library load time < 10ms
- Individual file load < 5ms

### Maintenance Tasks

- Periodic review of `zfiles` output
- Remove unused app configurations
- Archive old functions
- Update documentation

---

## References

### Related Files

- User script library: `~/lib/`
- User binaries: `~/bin/`
- GitHub repositories: `~/GitHub/`
- Project configurations: `~/.config/`

### External Documentation

- Zsh manual: `man zshall`
- Parameter expansion: `man zshexpn`
- Builtin commands: `man zshbuiltins`
- Oh My Posh: https://ohmyposh.dev/

### Useful Commands

```zsh
# Show current configuration version
print $ZSH_CONFIG_VERSION

# Show all loaded files
zfiles

# Show system info
sysinfo

# Show login info
logininfo

# Debug mode
ZSH_DEBUG=1 zsh -lic "exit"

# Measure startup
time zsh -lic "exit"
```

---

*Last updated: 2026-01-06*
*Configuration version: 20260106v1*
