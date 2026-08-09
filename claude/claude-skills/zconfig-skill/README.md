# zconfig-skill

Expert assistant for working with [zconfig](https://github.com/barabasz/zconfig) - modern, modular, performance-optimized zsh configuration.

## Overview

This skill enforces strict adherence to zconfig's coding standards and documentation guidelines. It ensures that all zsh code is 100% zsh-native (no bash compatibility) and follows best practices defined in the zconfig documentation.

## What This Skill Does

- **Enforces zsh-native coding** - No bash compatibility, full use of zsh features
- **Applies fn.zsh library** - For user-facing functions in `functions/`
- **Validates against standards** - Checks code against ZSH.md guidelines
- **Documentation-first approach** - Always reads relevant docs before coding
- **Optimizes for performance** - Uses zsh builtins, expansion flags, path modifiers

## Key Principles

### 1. Documentation First

The skill always reads:
- `README.md` - Architecture overview (always)
- `ZSH.md` - Zsh coding style (for any code)
- `FN.md` - Function library (for `functions/` only)
- Other docs as needed (NAMING.md, STRUCTURE.md, etc.)

### 2. 100% Zsh-Native

Code must leverage zsh-specific features:
- ✅ `(( ))` for numeric operations
- ✅ `[[ ]]` for string/file tests
- ✅ `ARGC` instead of `$#`
- ✅ `status` instead of `$?`
- ✅ `print` instead of `echo`
- ✅ Path modifiers (`:t`, `:h`, `:A`) instead of `basename`/`dirname`
- ✅ Expansion flags instead of pipes

### 3. fn.zsh for User Functions

Functions in `functions/` directory must use the fn.zsh library:
- Metadata in `_fn` array
- Arguments in `_fn_args` with type validation
- Options in `_fn_opts`
- Examples in `_fn_examples`
- Call `_fn_init "$@" || return $REPLY`

Helpers in `lib/` do NOT use fn.zsh (simple utilities).

## Directory Structure

```
zconfig-skill/
├── SKILL.md              # Main skill definition
├── README.md             # This file
├── evals/
│   ├── evals.json        # Test cases
│   └── files/            # Documentation files
│       ├── README.md
│       ├── ZSH.md
│       ├── FN.md
│       └── ...
```

## Evaluation Cases

The skill includes 6 test cases:

1. **fix-bash-function** - Fix bash-style code to zsh-native
2. **optimize-zsh-code** - Optimize code using zsh features
3. **write-lib-helper** - Create helper for `lib/` directory
4. **write-user-function-speedconv** - Create function with fn.zsh
5. **app-integration** - Create app integration in `apps/`
6. **fix-numeric-comparisons** - Fix POSIX numeric operators

## Usage

### Running Evaluations

```bash
# Test a single eval
zconfig-skill eval fix-bash-function

# Test with/without skill comparison
zconfig-skill eval optimize-zsh-code --compare

# Run all evals
zconfig-skill eval --all
```

### Improving the Skill

```bash
# Run improvement loop
zconfig-skill improve

# This will:
# 1. Run all evals
# 2. Compare with previous version
# 3. Analyze results
# 4. Suggest improvements
```

## Common Use Cases

### Fix Bash-Style Code

**Input:** Bash-compatible zsh code
**Output:** 100% zsh-native code following ZSH.md

### Create New Function

**For `functions/`:**
- Uses fn.zsh library
- Full argument/option validation
- Type checking
- Help generation

**For `lib/`:**
- Simple, focused helper
- No fn.zsh needed
- Follows naming conventions

### Code Review

Checks against all standards:
- Numeric operations use `(( ))`
- String/file tests use `[[ ]]`
- No external commands where zsh builtins exist
- File tracking present
- Naming conventions followed

## Anti-Patterns Detected

The skill catches common mistakes:

```zsh
# ❌ Wrong
if [ $# -lt 2 ]; then
    echo "Error"
    return $?
fi

# ✅ Correct
(( ARGC < 2 )) && {
    print -u2 "Error"
    return 1
}
```

## Quality Standards

Every output is validated against:
- ZSH.md coding guidelines
- FN.md library usage (when applicable)
- NAMING.md conventions
- STRUCTURE.md organization
- GUIDELINES.md patterns

## Documentation Files

All zconfig documentation is included in `evals/files/`:

- `README.md` - Overview and architecture
- `GUIDELINES.md` - Development guidelines, do's and don'ts
- `EXAMPLES.md` - Code examples
- `FN.md` - Function library guide
- `FUNCTIONS.md` - Available functions
- `GUIDELINES.md` - Development guidelines
- `INSTALL.md` - Installation instructions
- `NAMING.md` - Naming conventions
- `STRUCTURE.md` - Directory structure
- `ZFILES.md` - File tracking system
- `ZSH.md` - Zsh coding style

## Contributing

To add new evaluation cases:

1. Edit `evals/evals.json`
2. Add prompt and expectations
3. Test with: `zconfig-skill eval <eval-id>`

## License

Same as zconfig - check the main repository.
