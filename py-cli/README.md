
## Goals for this project:
1. Have fun and learn lots!

For the "real deal" version:  
1. 5 subcommands max: time (format/utc/tz), grep (regex search), cut (field/char slicing), uniq (dedupe/count), fmt (simple line wrap/trim).
2. Add color as a shared flag (e.g., --color auto/always/never).
3. Non-negotiables: consistent exit codes, stdin/stdout support (pipe-friendly), good help text, and a small test suite that hits parsing + behavior.

Packaging target: pyproject.toml with a console script entry point (so users install and run our command directly), versioning, and a minimal README with examples.
