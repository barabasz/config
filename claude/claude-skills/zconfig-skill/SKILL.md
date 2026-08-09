---
name: zconfig-skill
description: Expert assistant for working with zconfig - a modern, modular, performance-optimized zsh configuration. Ensures strict adherence to zsh-native coding standards, documentation guidelines, and the fn.zsh function library. Use when creating/modifying zsh functions, app integrations, plugins, or documentation for zconfig.
---

# zconfig Skill

Expert assistant for working with [zconfig](https://github.com/barabasz/zconfig) - a modern, modular, performance-optimized zsh configuration focused on maintainability and fast startup times.

## Core Responsibilities

This skill ensures strict adherence to zconfig's standards when:

1. **Writing zsh code** - Functions, helpers, app integrations, plugin wrappers
2. **Creating documentation** - README updates, new documentation files
3. **Code review** - Validating existing code against standards
4. **Optimization** - Improving code to leverage 100% of zsh capabilities

## Critical Principles

### 1. Always Read Documentation First

**MANDATORY for every task:**
- Read `/mnt/user-data/uploads/README.md` first to understand the architecture

**Read based on task type:**
- Writing zsh code → `/mnt/user-data/uploads/ZSH.md` (MANDATORY)
- Creating functions for `functions/` → `/mnt/user-data/uploads/FN.md` (MANDATORY)
- Creating helpers for `lib/` → `/mnt/user-data/uploads/ZSH.md` only
- App integrations → `/mnt/user-data/uploads/STRUCTURE.md`, `/mnt/user-data/uploads/EXAMPLES.md`
- Plugin wrappers → README.md plugins section OR `lib/plugins.zsh` documentation (MANDATORY)
- Naming conventions → `/mnt/user-data/uploads/NAMING.md`
- Best practices and guidelines → `/mnt/user-data/uploads/GUIDELINES.md`

### 2. 100% Zsh-Native Code

**CRITICAL:** Code must use zsh-specific features exclusively. NO bash compatibility.

From ZSH.md - forbidden patterns:
- ❌ `$#` → ✅ `ARGC`
- ❌ `$?` → ✅ `status`
- ❌ `-lt`, `-gt`, `-eq`, `-ne`, `-le`, `-ge` → ✅ `(( ))` with `<`, `>`, `==`, `!=`, `<=`, `>=`
- ❌ `echo` → ✅ `print`
- ❌ `basename`, `dirname` → ✅ `:t`, `:h` modifiers
- ❌ `[ ]` → ✅ `[[ ]]` for strings/files, `(( ))` for numbers

### 3. Function Library (fn.zsh)

**MANDATORY for ALL functions in `functions/`** (user-facing, interactive commands):
- Use `_fn` metadata array for help, version, author
- Use `_fn_args` for positional arguments with validation
- Use `_fn_opts` for options with `zparseopts`
- Use `_fn_examples` for usage examples
- Call `_fn_init "$@" || return $REPLY`

**NOT required for helpers in `lib/`** (internal utility functions - simple, focused tools).

### 4. File Tracking

**MANDATORY in sourced files ONLY** (`lib/`, `inc/`, `apps/`, `plugins/`):
```zsh
#!/bin/zsh
zfile_track_start ${0:A}

# ... code here ...

zfile_track_end ${0:A}
```

**NOT for autoloaded functions** (`functions/`):
- Functions in `functions/` are autoloaded, not sourced
- They should NOT have file tracking
- Start directly with function code

### 5. Exit Codes

Use standard exit codes consistently:

| Code | Meaning | When to use |
|------|---------|-------------|
| 0 | Success / true | Operation completed successfully |
| 1 | General error / false | Operation failed, or predicate returned false |
| 2 | Invalid usage | Wrong arguments, missing required params |
| 127 | Not found | Command, file, or resource not found |

**Critical:** Never use `1` for invalid usage - use `2`. This allows callers to distinguish between "operation failed" and "function called incorrectly".

### 6. Version and Date Updates

**MANDATORY when modifying any file that contains version/date metadata.**

When editing a function or file that has `[version]` and `[modified]` in `_fn` metadata:
- **Always update `[modified]`** to today's date (YYYY-MM-DD format)
- **Always increment the patch version** (last segment), e.g., `0.4.3` → `0.4.4`
- **Never bump minor/major version** unless explicitly requested by the user
- Version format is always three segments: `major.minor.patch`

```zsh
# Before edit
local -A _fn=(
    [version]="0.4.3"
    [modified]="2026-01-15"
)

# After edit (today is 2026-02-15)
local -A _fn=(
    [version]="0.4.4"
    [modified]="2026-02-15"
)
```

### 7. REPLY and reply - Efficient Data Passing

**CRITICAL:** Use `$REPLY` (scalar) and `$reply` (array) for returning values instead of subshells.

The genius of `$REPLY` and `$reply` in Zsh lies in their role as a standard communication protocol between the shell and user functions. Unlike other shells that force you to use `echo` commands and capture output through `$()` (creating costly new processes/subshells), Zsh allows functions to simply assign results to these variables. This makes data passing instantaneous and extremely efficient because it happens within the same process, preserving data structure integrity.

**Why this matters:**
- **Performance:** No subshell overhead - execution stays in the same process
- **Data integrity:** Arrays remain arrays, no word splitting issues
- **Idiomatic Zsh:** Works with completion system, glob qualifiers like `*(+function)`
- **No escaping headaches:** Raw array elements, not formatted text

```zsh
# ❌ Slow - subshell
get_basename() {
    local name="${1:t:r}"
    print "$name"
}
result=$(get_basename "/path/to/file.txt")

# ✅ Fast - REPLY
get_basename() {
    REPLY="${1:t:r}"
}
get_basename "/path/to/file.txt"
print "$REPLY"  # â†' file

# ✅ Arrays - reply
get_files() {
    reply=( *.txt(.) )  # Only regular .txt files
}
get_files
print -l "$reply[@]"
```

**Advanced usage with glob qualifiers:**
```zsh
# Function for glob qualifier
is_large() {
    [[ $(stat -f%z "$1" 2>/dev/null || stat -c%s "$1" 2>/dev/null) -gt 1048576 ]]
}

# Use in glob - Zsh calls is_large and checks exit code
large_files=( *(+is_large) )  # Files > 1MB
```

### 8. Reserved Variable Names - DANGER ZONE

**CRITICAL WARNING:** Never use these names for local variables - they are tied to environment variables:

| Variable | Tied to | Effect if shadowed |
|----------|---------|-------------------|
| `path` | `PATH` | Commands not found - shell breaks! |
| `fpath` | `FPATH` | Autoload functions fail |
| `cdpath` | `CDPATH` | `cd` behavior breaks |
| `mailpath` | `MAILPATH` | Mail checks fail |
| `manpath` | `MANPATH` | `man` can't find pages |

```zsh
# ❌ CATASTROPHIC - shadows PATH!
my_function() {
    local path="/some/path"        # PATH is now EMPTY!
    whence -p brew                 # FAILS - no PATH
}

# ✅ CORRECT - use different name
my_function() {
    local file_path="/some/path"   # Safe
    local target_path=""           # Safe
    local dir_path=""              # Safe
}
```

This is a **subtle, hard-to-diagnose bug** - commands work outside the function but fail inside. You can lose hours debugging this!

## Workflow

### Step 1: Understand the Task

Analyze what the user wants:
- New function for `functions/`? → Read README.md, ZSH.md, FN.md
- Helper for `lib/`? → Read README.md, ZSH.md, NAMING.md
- App integration? → Read README.md, ZSH.md, STRUCTURE.md, EXAMPLES.md
- Plugin wrapper? → Read README.md, ZSH.md, `lib/plugins.zsh` (MANDATORY)
- Documentation update? → Read README.md, GUIDELINES.md
- Code review/optimization? → Read README.md, ZSH.md

### Step 2: Read Required Documentation

Based on task type, read the appropriate documentation files from `/mnt/user-data/uploads/`.

**Always read README.md first**, then task-specific files.

### Step 3: Execute the Task

Apply the guidelines strictly:

#### For `functions/` (User Functions)
```zsh
# NO shebang, NO file tracking
# Autoloaded functions start directly with code

# Template with fn.zsh
local -A _fn=(
    [info]="Brief description"
    [desc]="Detailed description"
    [version]="1.0.0"
    [author]="Author Name"
)

local -a _fn_args=(
    "arg1|Description|r|type"
)

local -a _fn_opts=(
    "verbose|v|Enable verbose output"
)

local -a _fn_examples=(
    "functionname arg1|Example description"
)

local -A opts=() args=()
_fn_init "$@" || return $REPLY

# Implementation using zsh-native constructs
```

#### For `lib/` (Helpers)
```zsh
#!/bin/zsh
zfile_track_start ${0:A}

# Simple, focused utilities
# Use zsh-native constructs
# No fn.zsh library needed
# Follow ZSH.md guidelines

zfile_track_end ${0:A}
```

#### For `apps/` (App Integrations)
```zsh
#!/bin/zsh
zfile_track_start ${0:A}

if is_installed toolname; then
    # Configuration here
fi

zfile_track_end ${0:A}
```

#### For `plugins/` (Plugin Wrappers)
```zsh
#!/bin/zsh
zfile_track_start ${0:A}

# Pre-load configuration (optional)
export PLUGIN_OPTION=value

# Load plugin (handles sourcing + compilation)
load_plugin plugin-name

# Post-load configuration (optional)
bindkey '^X' plugin-command

zfile_track_end ${0:A}
```

### Step 4: Validate Against Standards

Before presenting code, verify:

**ZSH.md compliance:**
- ✅ Using `ARGC` not `$#`
- ✅ Using `status` not `$?`
- ✅ Using `(( ))` for all numeric operations
- ✅ Using `[[ ]]` only for strings/files
- ✅ Using `print` not `echo`
- ✅ Using path modifiers (`:t`, `:h`, `:A`)
- ✅ Using expansion flags instead of pipes
- ✅ Using `REPLY`/`reply` instead of subshells for return values
- ✅ No POSIX/bash compatibility code
- ✅ No reserved variable names (`path`, `fpath`, `cdpath`, etc.)
- ✅ Correct exit codes (0/1/2/127)

**FN.md compliance (for `functions/` only):**
- ✅ `_fn` metadata defined
- ✅ Arguments in `_fn_args` with types
- ✅ Options in `_fn_opts`
- ✅ Examples in `_fn_examples`
- ✅ `_fn_init "$@" || return $REPLY` called
- ✅ NO file tracking (functions are autoloaded)

**General compliance:**
- ✅ File tracking present ONLY in sourced files (`lib/`, `inc/`, `apps/`, `plugins/`)
- ✅ File tracking ABSENT from `functions/` (autoloaded)
- ✅ Tool availability checked (`is_installed`)
- ✅ Naming conventions followed
- ✅ Code commented appropriately

## Common Tasks

### Task: Write New Function for `functions/`

1. Read: README.md, ZSH.md, FN.md
2. Create function with fn.zsh wrapper
3. Use zsh-native constructs throughout
4. Validate all options and arguments
5. Include examples and help

### Task: Write Helper for `lib/`

1. Read: README.md, ZSH.md, NAMING.md
2. Create simple, focused function
3. Add file tracking
4. Use zsh-native constructs
5. Follow naming conventions

### Task: Review/Optimize Code

1. Read: README.md, ZSH.md
2. Check for bash-isms (replace with zsh-native)
3. Verify numeric comparisons use `(( ))`
4. Verify string/file tests use `[[ ]]`
5. Check for missed optimizations (expansion flags, modifiers)

### Task: Update Documentation

1. Read: README.md, GUIDELINES.md
2. Follow existing structure
3. Update relevant sections
4. Maintain consistent formatting
5. Update examples if needed

### Task: Create Plugin Wrapper

**MANDATORY:** Always read `lib/plugins.zsh` (or README.md Plugin section) to understand plugin system.

1. Read: README.md, `lib/plugins.zsh` (MANDATORY), STRUCTURE.md
2. Create `plugins/<name>.zsh` wrapper file
3. Use `install_plugin <name> <github-user/repo>` or `register_plugin <name> <file>`
4. Configure pre-load settings (optional)
5. Call `load_plugin <name>` to load and auto-compile
6. Configure post-load settings (optional)
7. Add file tracking

**Template:**
```zsh
#!/bin/zsh
zfile_track_start ${0:A}

# Pre-load configuration (optional)
export PLUGIN_VAR=value

# Load plugin (handles cloning, compilation, sourcing)
load_plugin <plugin-name>

# Post-load configuration (optional)
bindkey '^X' plugin-command

zfile_track_end ${0:A}
```

**Key functions in lib/plugins.zsh:**
- `install_plugin <name> <repo>` - Clone plugin from GitHub
- `register_plugin <name> <file>` - Register standalone plugin file
- `load_plugin <name>` - Source and auto-compile plugin
- `update_plugin <name>` - Git pull + recompile
- `update_plugins` - Update all plugins
- `remove_plugin <name>` - Remove plugin completely

## Anti-Patterns to Avoid

1. **Never** use bash compatibility mode
2. **Never** skip reading documentation
3. **Never** use POSIX numeric operators (`-lt`, `-gt`, etc.)
4. **Never** use `echo` instead of `print`
5. **Never** add file tracking to `functions/` (autoloaded, not sourced!)
6. **Never** forget file tracking in sourced files (`lib/`, `inc/`, `apps/`, `plugins/`)
7. **Never** use fn.zsh for simple helpers in `lib/`
8. **Never** assume tools are installed without checking
9. **Never** use reserved variable names (`path`, `fpath`, `cdpath`, `mailpath`, `manpath`)
10. **Never** use subshells `$()` when `REPLY`/`reply` can be used
11. **Never** use exit code `1` for invalid usage (use `2`)

## Quality Checklist

Before presenting any code, verify:

- [ ] Documentation read and understood
- [ ] Zsh-native constructs used (no bash-isms)
- [ ] Numeric operations use `(( ))`
- [ ] String/file tests use `[[ ]]`
- [ ] `print` used instead of `echo`
- [ ] Path modifiers used instead of external commands
- [ ] File tracking present (ONLY for sourced files: lib/, inc/, apps/, plugins/)
- [ ] File tracking ABSENT from functions/ (autoloaded, not sourced)
- [ ] fn.zsh used correctly (for `functions/` only, not `lib/`)
- [ ] REPLY/reply used instead of subshells when returning values
- [ ] Reserved names avoided (path, fpath, cdpath, mailpath, manpath)
- [ ] Exit codes used correctly (0=success, 1=error, 2=invalid usage, 127=not found)
- [ ] Version bumped (patch) and modified date updated when editing files with _fn metadata
- [ ] Naming conventions followed
- [ ] Tool availability checked (is_installed)
- [ ] Code optimized for performance

## Examples

### Good: Function in `functions/` with fn.zsh

```zsh
# functions/speedconv
# NO shebang, NO file tracking - autoloaded functions start directly

local -A _fn=(
    [info]="Convert speed between units"
    [version]="1.0.0"
    [author]="Andrzej Barabasz"
)

local -a _fn_args=(
    "value|Speed value|r|float(0;]"
    "from|Source unit (kmh/mph/ms)|r"
    "to|Target unit (kmh/mph/ms)|r"
)

local -a _fn_opts=(
    "precision|p|Decimal places|n|integer[0;10]"
)

local -a _fn_examples=(
    "speedconv 100 kmh mph|Convert 100 km/h to mph"
    "speedconv -p 2 60 mph ms|Convert 60 mph to m/s with 2 decimals"
)

local -A opts=() args=()
_fn_init "$@" || return $REPLY

# Implementation with zsh-native code
local value=${args[value]}
local from=${args[from]}
local to=${args[to]}
local precision=${opts[precision]:-2}

# ... conversion logic using (( )) for math ...
```

### Good: Helper in `lib/`

```zsh
#!/bin/zsh
zfile_track_start ${0:A}

# is_valid_ip - Check if string is valid IPv4 address
is_valid_ip() {
    (( ARGC == 1 )) || return 2
    [[ $1 =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]
}

zfile_track_end ${0:A}
```

### Good: Plugin Wrapper in `plugins/`

```zsh
#!/bin/zsh
zfile_track_start ${0:A}

# Pre-load configuration
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Load plugin (auto-compiles if needed)
load_plugin zsh-autosuggestions

# Post-load configuration
bindkey '^[[Z' autosuggest-accept  # Shift+Tab to accept

zfile_track_end ${0:A}
```

### Good: App Integration in `apps/`

```zsh
#!/bin/zsh
zfile_track_start ${0:A}

if is_installed rg; then
    alias rga='rg --hidden --glob !.git'
    export RG_COLORS='match:fg:yellow'
fi

zfile_track_end ${0:A}
```

### Bad: Bash-style Code

```zsh
# ❌ Wrong - uses bash-isms
is_valid_ip() {
    if [ $# -eq 1 ]; then              # ❌ Should use (( ARGC == 1 ))
        echo "$1" | grep -E "^([0-9]..."  # ❌ Should use [[ =~ ]]
        return $?                       # ❌ Should just let [[ ]] return
    fi
    return 1
}
```

### Bad: File Tracking in functions/

```zsh
# ❌ WRONG - functions/ are autoloaded, NOT sourced!
#!/bin/zsh
zfile_track_start ${0:A}  # ❌ NO! Functions don't need tracking

local -A _fn=(...)
# ...

zfile_track_end ${0:A}    # ❌ NO!
```

### Bad: Subshell Instead of REPLY

```zsh
# ❌ Slow - creates subshell
get_basename() {
    local filepath="$1"
    local filename=$(basename "$filepath")
    print "${filename%.*}"
}
result=$(get_basename "/path/to/file.txt")  # Another subshell!

# ✅ Fast - uses REPLY, path modifiers, no subshells
get_basename() {
    (( ARGC == 1 )) || return 2
    REPLY="${1:t:r}"  # :t = tail (basename), :r = remove extension
}
get_basename "/path/to/file.txt"
print "$REPLY"  # â†' file
```

### Bad: Reserved Variable Name

```zsh
# ❌ CATASTROPHIC - shadows PATH!
process_files() {
    local path="$1"  # PATH environment is now EMPTY!
    ls "$path"       # Works
    brew --version   # FAILS - command not found!
}

# ✅ CORRECT - different name
process_files() {
    local dir_path="$1"  # Safe
    ls "$dir_path"
    brew --version       # Works
}
```

## Communication

When working with users:

1. **Confirm understanding** of the task
2. **Mention which docs** you're reading (transparency)
3. **Explain key decisions** (why zsh-native, not bash)
4. **Point out optimizations** (expansion flags vs pipes, REPLY vs subshells)
5. **Warn about pitfalls** (reserved names like `path`, file tracking in functions/)
6. **Provide context** from documentation when relevant
7. **Highlight performance gains** (REPLY vs subshell, path modifiers vs external commands)

## Summary

This skill enforces zconfig's high standards:
- Documentation-first approach
- 100% zsh-native code (zero bash compatibility)
- fn.zsh library for user functions
- Strict adherence to coding guidelines
- Performance-optimized solutions

The goal is to maintain a consistent, high-quality, performant zsh configuration that fully leverages zsh's powerful features.
