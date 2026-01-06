# Zsh Configuration - Claude Documentation

## Table of Contents

- [Overview](#overview)
- [Philosophy & Principles](#philosophy--principles)
- [Directory Structure](#directory-structure)
- [Core Components](#core-components)
- [Naming Conventions](#naming-conventions)
- [File Tracking System](#file-tracking-system)
- [Library Compilation](#library-compilation)
- [Development Guidelines](#development-guidelines)
- [Examples & Use Cases](#examples--use-cases)

---

## Overview

This is a modular, performance-optimized zsh configuration focused on maintainability, tracking, and fast startup times. The configuration is split across multiple specialized directories with a clear separation of concerns.

**Key Features:**
- File tracking system with performance monitoring
- Modular library of helper functions
- Lazy loading for heavy applications
- Library compilation for optimal performance
- Autoloaded user functions
- Comprehensive aliasing system

**Version:** Tracked via `$ZSH_CONFIG_VERSION` in `.zshenv`

---

## Philosophy & Principles

### Core Values

1. **Performance First**
   - Track loading times of all sourced files
   - Compile libraries for faster access
   - Lazy load heavy applications
   - Minimize startup time

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
│   ├── zdg.zsh          # XDG Directories
│   ├── variables.zsh    # Environment variables
│   ├── bootstrap.zsh    # Bootstrap functions & colors
│   ├── path.zsh         # Path settings
│   ├── aliases.zsh      # Aliases
│   ├── hashdirs.zsh     # Directory hashes
│   └── locales.zsh      # Locale settings (linux only)
├── lib/              # Helper library (fast utilities)
│   ├── files.zsh        # File/path test functions
│   ├── system.zsh       # OS detection & info
│   ├── strings.zsh      # String manipulation
│   ├── shell.zsh        # Shell info functions
│   ├── varia.zsh        # Miscellaneous helpers
│   └── ...              # Other helpers
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
- Set `$ZDOTDIR` and core variables
- Load  `zfile.zsh` file tracking system
- Load  `xdg.zsh`,  `variables.zsh` , `bootstrap.zsh` and  `path.zsh`  
- Source entire `lib/` directory (helper functions)
- Set locale

**Key Variables:**
```zsh
ZDOTDIR=$HOME/.config/zsh
ZSH_CONFIG_VERSION="20260104v4"
ZSH_DEBUG=0              # Set to 1 for verbose output
ZSH_LOGIN_INFO=1         # Show login info
```

**Flow:**
```
.zshenv
  → inc/zfile.zsh (file tracking setup)
  → inc/zdg.zsh (XDG)
  → inc/variables.zsh (exports)
  → inc/bootstrap.zsh (colors, helpers)
  → lib/*.zsh (all helper functions)
  → inc/path.zsh (path)
  → inc/locales.zsh (locale settings)
```

### 2. `inc/bootstrap.zsh` - Core Functions

**Purpose:** Provide essential functions needed during initialization.

**Exports:**
- ANSI color codes (interactive only): `$r`, `$g`, `$y`, `$b`, etc.
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

### 3. `inc/environment.zsh` - Environment Setup

**Purpose:** Set all environment variables, paths, and directory shortcuts.

**Key Sections:**

**Zsh Directories:**
```zsh
ZCACHEDIR=$ZDOTDIR/cache
ZINCDIR=$ZDOTDIR/inc
ZLIBDIR=$ZDOTDIR/lib
ZAPPDIR=$ZDOTDIR/apps
ZFNCDIR=$ZDOTDIR/functions
```

**XDG Base Directories:**
```zsh
XDG_CONFIG_HOME=$HOME/.config
XDG_CACHE_HOME=$HOME/.local/cache
XDG_DATA_HOME=$HOME/.local/share
# ... etc
```

**Named Directories:**
```zsh
hash -d bin=$BINDIR
hash -d conf=$CONFDIR
hash -d gh=$GHDIR
hash -d zsh=$ZDOTDIR
# Usage: cd ~zsh, ls ~gh
```

**PATH Construction:**
```zsh
PATH=$BINDIR:$BINDIR/common:$BINDIR/install:/usr/local/bin:$HOME/.local/bin:$PATH
```

### 4. `lib/` - Helper Library

**Purpose:** Fast, frequently-used utility functions loaded in `.zshenv`.

**Categories:**

#### `lib/files.zsh` - File System Tests
```zsh
is_file PATH        # True if regular file
is_dir PATH         # True if directory
is_link PATH        # True if symbolic link
# ... etc
```

#### `lib/system.zsh` - OS Detection & Info
```zsh
is_debian           # True if pure Debian
is_ubuntu           # True if Ubuntu
is_macos            # True if macOS
# ... etc
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

### 5. `apps/` - Application Integrations

**Purpose:** Configure external tools and applications. Loaded last in `.zshrc`.

**Naming Convention:** `apps/{tool}.zsh`

**Template Structure:**
```zsh
#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# {Tool Name} configuration
# {Tool Name short description}

if is_installed {tool}; then
    # Configuration here
fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}
```

### 6. `functions/` - Autoloaded Functions

**Purpose:** Complex user functions that are autoloaded on demand.

### 7. `.zshrc` - Interactive Shell

**Purpose:** Set up interactive shell features.

**Responsibilities:**
- Autoload zsh functions (`zmv`, `colors`)
- Autoload user functions from `$ZFNCDIR`
- Source aliases
- Load app configurations

**Flow:**
```
.zshrc
  → autoload zmv, colors
  → autoload functions/*
  → inc/aliases.zsh
  → apps/*.zsh (all apps)
```

### 8. `.zlogin` - Post-Login

**Purpose:** Actions after login shell initialization.

**Responsibilities:**
- Clean up temporary variables
- Display system info (if `ZSH_LOGIN_INFO=1`)
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
- Examples: `etime`, `relib`, `sysinfo`

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

**App Files:** `{tool}.zsh`
- Examples: `brew.zsh`, `fzf.zsh`, `omp.zsh`

**Include Files:** `{purpose}.zsh`
- Examples: `bootstrap.zsh`, `environment.zsh`, `aliases.zsh`

**Functions:** No extension, lowercase
- Examples: `sysinfo`, `logininfo`, `relib`

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
✅ environment.zsh sourced in 2.31ms
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
 2. ✓   environment.zsh     2.31 ms  inc
 3. ✓   bootstrap.zsh       1.89 ms  inc
 4. ✓   files.zsh           0.67 ms  lib
 5. ✓   system.zsh          1.23 ms  lib
 6. ✓   strings.zsh         0.45 ms  lib
 7. ✓   shell.zsh           0.34 ms  lib
 8. ✓   varia.zsh           0.78 ms  lib
 9. ✓   locales.zsh         0.89 ms  inc
10. ✓ .zshrc               8.91 ms
11. ✓   aliases.zsh         2.45 ms  inc
12. ✓   brew.zsh            3.21 ms  apps
13. ✓   omp.zsh            45.67 ms  apps
14. ✓   fzf.zsh            12.34 ms  apps
------------------------------------------
Total loading time:        93.59 ms
```

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
   
   # Bad - multiple responsibilities
   os_check() {
       if [[ $OSTYPE == darwin* ]]; then
           print "macos"
           return 0
       elif [[ $OSTYPE == linux* ]]; then
           print "linux"
           return 0
       else
           print "unknown"
           return 1
       fi
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
   # Test all code paths
   is_file /etc/hosts     # should return 0
   is_file /etc           # should return 1
   is_file /nonexistent   # should return 1
   ```

8. **Document if complex:**
   ```zsh
   # Extract version number from a string
   # Usage: get_version "string containing version"
   # Returns: version number or exits with 1
   get_version() {
       # ... implementation
   }
   ```

9. **Recompile library:**
   ```zsh
   relib
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

3. **Check installation:**
   ```zsh
   if is_installed mytool; then
       # Only configure if available
   fi
   ```

4. **Use helpers:**
   ```zsh
   if is_macos; then
       export TOOL_PATH=/opt/tool
   elif is_linux; then
       export TOOL_PATH=/usr/local/tool
   fi
   ```

5. **Test:**
   ```zsh
   # With tool installed
   source apps/mytool.zsh
   
   # Without tool
   which mytool || source apps/mytool.zsh  # should not error
   ```

### Adding New User Function

1. **Create file:** `functions/{name}` (no extension)

2. **Make executable:**
   ```zsh
   chmod +x functions/{name}
   ```

3. **Use autoload variables:**
   ```zsh
   # Available in autoloaded functions:
   # - All lib/* functions
   # - All environment variables
   # - Color variables (if interactive)
   ```

4. **Example:**
   ```zsh
   # functions/myinfo
   local hostname=$(hostname)
   local os=$(os_name)
   local uptime=$(uptime | awk '{print $3}')
   
   print "Host: $hostname"
   print "OS: $os"
   print "Uptime: $uptime"
   ```

5. **Test:**
   ```zsh
   # In new shell
   myinfo  # should work automatically
   ```

### Adding New Alias

1. **Edit:** `inc/aliases.zsh`

2. **Group logically:**
   ```zsh
   # Global aliases
   alias -g G='| grep'
   
   # Common aliases
   alias cls='clear'
   
   # Application-specific
   if is_installed bat; then
       alias cat='bat'
   fi
   ```

3. **Check dependencies:**
   ```zsh
   if is_installed tool; then
       alias shortcut='tool --with-flags'
   fi
   ```

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
   # Instead of:
   eval "$(slowtool init zsh)"
   
   # Use:
   slowtool() {
       unfunction slowtool
       eval "$(command slowtool init zsh)"
       slowtool "$@"
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
   # In test shell
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
    
    # Load completion if available
    if [[ -f $MYTOOL_PATH/share/completion.zsh ]]; then
        source $MYTOOL_PATH/share/completion.zsh
    fi
fi

zfile_track_end ${0:A}
```

### Example 2: Conditional Feature Loading

```zsh
# lib/varia.zsh - excerpt
try_source() {
    [[ $# -ge 1 ]] || return 1
    
    if [[ -f "$1" ]]; then
        if source "$1"; then
            return 0
        else
            local exit_code=$?
            if is_debug; then
                print "Error: failed to source $1 (exit: $exit_code)" >&2
            fi
            return $exit_code
        fi
    else
        is_debug && print "Warning: missing file: $1" >&2
        return 1
    fi
}

# Usage in .zshenv:
try_source "$HOME/.secrets" "${0:t}"
try_source "$HOME/.local.zsh" "${0:t}"
```

### Example 3: Custom Info Function

```zsh
# functions/devinfo
local python_ver node_ver git_ver
local venv_active=""

python_ver=$(python3 --version 2>&1 | get_version)
node_ver=$(node --version 2>&1 | get_version)
git_ver=$(git --version 2>&1 | get_version)

[[ -n $VIRTUAL_ENV ]] && venv_active=" ${g}(venv)${x}"

print "Development Environment:"
print "  Python: ${y}${python_ver}${x}${venv_active}"
print "  Node.js: ${y}${node_ver}${x}"
print "  Git: ${y}${git_ver}${x}"

# Usage: devinfo
```

### Example 4: Performance Measurement

```zsh
# Measure startup time
$ time zsh -lic "exit"
zsh -lic "exit"  0.08s user 0.04s system 93% cpu 0.134 total

# Detailed breakdown
$ ZSH_DEBUG=1 zsh -lic "exit"
✅ bootstrap.zsh sourced in 1.89ms
✅ environment.zsh sourced in 2.31ms
✅ files.zsh sourced in 0.67ms
...

# View full report
$ zfiles
```

### Example 5: Adding Version Check Function

```zsh
# lib/varia.zsh - add this function

# Check if version meets minimum requirement
# Usage: version_check "1.2.3" "1.2.0"
# Returns: 0 if first >= second, 1 otherwise
version_check() {
    [[ $# -eq 2 ]] || return 1
    
    local ver1=$1 ver2=$2
    local IFS='.'
    local -a v1=($=ver1) v2=($=ver2)
    local i
    
    for i in {1..3}; do
        local n1=${v1[$i]:-0} n2=${v2[$i]:-0}
        if (( n1 > n2 )); then
            return 0
        elif (( n1 < n2 )); then
            return 1
        fi
    done
    
    return 0
}

# Usage in apps:
if is_installed mytool; then
    local ver=$(mytool --version | get_version)
    if version_check "$ver" "2.0.0"; then
        # Use new features
    else
        # Use legacy mode
    fi
fi
```

---

## Best Practices Summary

### Do's ✅

- **Always** use tracking in sourced files
- **Always** check installation before configuring
- **Always** use zsh-native syntax
- **Always** test functions before committing
- **Always** recompile library after changes
- Use `is_installed` before configuring tools
- Use `is_debug` for conditional logging
- Use named directories (`~zsh`, `~gh`, etc.)
- Keep functions small and focused
- Document complex logic
- Use meaningful variable names
- Prefer builtins over external commands

### Don'ts ❌

- **Never** write bash-compatible code
- **Never** use `echo` (use `print`)
- **Never** use `[ ]` (use `[[ ]]`)
- **Never** skip tracking in sourced files
- **Never** assume tools are installed
- **Never** edit `.compiled.zsh` manually
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
2. For `lib/`: run `relib`
3. For `functions/`: check `$fpath`
4. Verify file permissions (functions should be readable)

### Changes Not Applied

1. For `lib/`: run `relib`
2. For other files: `source ~/.zshenv`
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

- Regular `relib` after library changes
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

# Recompile library
relib

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

*Last updated: 2026-01-05*
*Configuration version: 20260104v4*
