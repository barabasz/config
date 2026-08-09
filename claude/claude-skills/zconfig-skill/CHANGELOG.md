# zconfig-skill - Changelog Korekt

## Zaimplementowane Korekty

### ✅ 1. File Tracking - KRYTYCZNA KOREKTA

**Problem:** SKILL.md sugerował file tracking we wszystkich plikach, w tym w `functions/`.

**Rozwiązanie:**
- Wyraźnie określono że file tracking jest **TYLKO dla sourced files**: `lib/`, `inc/`, `apps/`, `plugins/`
- Dodano ostrzeżenie że `functions/` są **autoloaded**, więc **NIE POWINNY** mieć tracking
- Zaktualizowano wszystkie przykłady dla `functions/` - usunięto shebang i tracking
- Dodano przykład "Bad: File Tracking in functions/"

**Sekcje zaktualizowane:**
- Critical Principles § 4
- Execute the Task - template dla functions/
- Examples - wszystkie przykłady functions/
- Quality Checklist
- Validation checklist

---

### ✅ 2. Clarified fn.zsh Usage

**Problem:** Niejasne "large functions" - kiedy używać fn.zsh?

**Rozwiązanie:**
- Zmieniono z "large functions" na **"ALL functions in functions/"**
- Podkreślono że to user-facing, interactive commands
- Jasno określono że **NIE dotyczy** helperów w `lib/`

**Tekst przed:**
> MANDATORY for large functions in functions/

**Tekst po:**
> MANDATORY for ALL functions in functions/ (user-facing, interactive commands)
> NOT required for helpers in lib/ (internal utility functions - simple, focused tools)

---

### ✅ 3. Plugin Wrappers - Nowa Sekcja

**Problem:** Brak workflow dla plugin wrappers.

**Rozwiązanie:**
- Dodano kompletną sekcję "Task: Create Plugin Wrapper" w Common Tasks
- **MANDATORY:** czytanie `lib/plugins.zsh` lub README.md Plugin section
- Dodano template z pre-load/post-load configuration
- Wymieniono kluczowe funkcje: install_plugin, load_plugin, update_plugin, etc.
- Dodano przykład w sekcji Examples
- Dodano template w Execute the Task

**Nowa sekcja zawiera:**
```zsh
# Template
#!/bin/zsh
zfile_track_start ${0:A}

# Pre-load config
export PLUGIN_VAR=value

load_plugin <plugin-name>

# Post-load config
bindkey '^X' plugin-command

zfile_track_end ${0:A}
```

---

### ✅ 4. Exit Codes - Dodane do Critical Principles

**Problem:** Exit codes były w ZSH.md ale nie w SKILL.md.

**Rozwiązanie:**
- Dodano nową sekcję § 5 "Exit Codes" w Critical Principles
- Tabela z kodami: 0, 1, 2, 127
- Podkreślono: **NIGDY 1 dla invalid usage - użyj 2**
- Dodano do Quality Checklist
- Dodano do Validation checklist
- Dodano do Anti-Patterns (punkt 11)

**Tabela exit codes:**
| Code | Meaning | When to use |
|------|---------|-------------|
| 0 | Success / true | Operation completed successfully |
| 1 | General error / false | Operation failed, or predicate returned false |
| 2 | Invalid usage | Wrong arguments, missing required params |
| 127 | Not found | Command, file, or resource not found |

---

### ✅ 5. Reserved Variable Names - DANGER ZONE

**Problem:** KRYTYCZNY błąd - shadowing `path`, `fpath` powoduje że shell się psuje.

**Rozwiązanie:**
- Dodano nową sekcję § 7 "Reserved Variable Names - DANGER ZONE"
- Tabela z reserved names i efektami shadowing
- **CRITICAL WARNING** na początku
- Przykład katastrofalnego błędu
- Przykład poprawny
- Dodano do Quality Checklist
- Dodano do Anti-Patterns (punkt 9)
- Dodano nowy eval "fix-reserved-variable-name"

**Reserved names:**
- `path` → `PATH` (commands not found!)
- `fpath` → `FPATH` (autoload fails)
- `cdpath` → `CDPATH` (cd breaks)
- `mailpath` → `MAILPATH`
- `manpath` → `MANPATH`

**Cytat z dokumentacji:**
> This is a **subtle, hard-to-diagnose bug** - commands work outside the function but fail inside. You can lose hours debugging this!

---

### ✅ 6. REPLY and reply - Wydajne Przekazywanie Danych

**Problem:** Brak wyjaśnienia REPLY/reply jako standardowego protokołu komunikacji.

**Rozwiązanie:**
- Dodano nową sekcję § 6 "REPLY and reply - Efficient Data Passing"
- Pełne wyjaśnienie z Twojego komentarza o genialności tego rozwiązania
- Porównanie wydajności: subshell vs REPLY
- Przykłady użycia: scalar, array, glob qualifiers
- Dodano przykład "Bad: Subshell Instead of REPLY"
- Dodano do Quality Checklist
- Dodano do Anti-Patterns (punkt 10)
- Dodano do Communication (punkt 4)
- Dodano nowy eval "optimize-reply-usage"

**Kluczowe punkty:**
- **Performance:** Brak overhead subshell - wszystko w tym samym procesie
- **Data integrity:** Tablice pozostają tablicami, brak word splitting
- **Idiomatic Zsh:** Współpraca z completion system, glob qualifiers
- **No escaping headaches:** Surowe elementy tablic, nie sformatowany tekst

**Przykład z glob qualifier:**
```zsh
is_large() {
    [[ $(stat -f%z "$1") -gt 1048576 ]]
}
large_files=( *(+is_large) )  # Zsh wywołuje is_large
```

---

## Zaktualizowane Sekcje SKILL.md

### Critical Principles (1-7)
1. Always Read Documentation First
2. 100% Zsh-Native Code
3. Function Library (fn.zsh) - **zaktualizowane**
4. File Tracking - **całkowicie przepisane**
5. Exit Codes - **NOWE**
6. REPLY and reply - **NOWE**
7. Reserved Variable Names - **NOWE**

### Workflow
- Step 1: Understand the Task - **dodano plugin wrappers**
- Step 2: Read Required Documentation - **dodano lib/plugins.zsh**
- Step 3: Execute the Task - **zaktualizowano wszystkie templates**
- Step 4: Validate Against Standards - **rozszerzona lista**

### Common Tasks
- **NOWE:** Task: Create Plugin Wrapper
- Zaktualizowane inne sekcje

### Anti-Patterns (1-11)
- **NOWE:** punkty 9, 10, 11
- Zaktualizowane opisy

### Quality Checklist
- Dodano 5 nowych punktów sprawdzających
- Rozszerzone kryteria walidacji

### Examples
- **Zaktualizowano:** functions/ - bez shebang/tracking
- **NOWE:** Plugin Wrapper
- **NOWE:** App Integration
- **NOWE:** Bad - Subshell Instead of REPLY
- **NOWE:** Bad - Reserved Variable Name

### Communication
- Dodano punkty 4, 5, 6, 7

---

## Zaktualizowane Evaly (evals.json)

### Zmodyfikowane Evaly

**write-lib-helper:**
- Dodano sprawdzenie shebangu
- Podkreślono BRAK echo/print do zwracania
- Dodano "Brak użycia echo lub print do zwracania wartości"

**write-user-function-speedconv:**
- **KRYTYCZNE:** Dodano UWAGĘ w promptcie o braku tracking
- Dodano 3 nowe expectations:
  - BRAK shebangu
  - BRAK file tracking
  - Funkcja zaczyna się bezpośrednio od kodu

### Nowe Evaly

**optimize-reply-usage:**
- Optymalizacja funkcji używając REPLY
- Path modifiers zamiast basename
- Brak subshells
- 8 expectations

**fix-reserved-variable-name:**
- Bug z shadowing `path` variable
- Hint o problemie z nazwą zmiennej
- 6 expectations
- Wyjaśnienie że whence -p przestaje działać

---

## Statystyki

**SKILL.md:**
- Dodano: ~150 linii nowej dokumentacji
- Zaktualizowano: 12 sekcji
- Nowe sekcje: 3 (Exit Codes, REPLY/reply, Reserved Names)
- Nowe przykłady: 4

**evals.json:**
- Dodano: 2 nowe evaly
- Zaktualizowano: 2 istniejące evaly
- Łącznie: 8 evalów

**Pliki:**
- SKILL.md: ~470 linii
- evals.json: 8 przypadków testowych
- README.md: zaktualizowane
- Wszystkie 11 plików dokumentacji w evals/files/

---

## Najważniejsze Zmiany dla Użytkownika

### 🔴 KRYTYCZNE

1. **File tracking TYLKO dla sourced files** - functions/ NIE MAJĄ tracking
2. **Reserved names** - NIGDY `path`, `fpath`, `cdpath`, `mailpath`, `manpath`
3. **Exit codes** - 2 dla invalid usage, NIE 1

### 🟡 WAŻNE

4. **REPLY/reply** - używaj zamiast subshells dla wydajności
5. **fn.zsh** - dla WSZYSTKICH functions/, NIE dla lib/
6. **Plugin wrappers** - czytaj lib/plugins.zsh PRZED tworzeniem

### 🟢 POMOCNE

7. Rozszerzone przykłady we wszystkich kategoriach
8. Więcej evalów testujących edge cases
9. Lepsza komunikacja o pułapkach

---

## Podsumowanie

Wszystkie 6 korekt zostały zaimplementowane z dużym naciskiem na bezpieczeństwo i wydajność:

✅ File tracking jasno określony (sourced vs autoloaded)
✅ fn.zsh wymagane dla WSZYSTKICH functions/
✅ Plugin workflow z mandatory lib/plugins.zsh
✅ Exit codes w Critical Principles
✅ Reserved names z DANGER warning
✅ REPLY/reply z pełnym wyjaśnieniem wydajności

Skill jest teraz znacznie bardziej precyzyjny i bezpieczny!
