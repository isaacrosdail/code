# guantlet
Practice repo for Python & JS. Will chip away at making my own CLI "swiss army knife" program to try to apply everything I learn, especially since some stuff doesn't fit within my main project Vesper.

## Thinking of doing this kind of setup:
`python/` - Houses practice/drill/annotated files.
`python/app/` - Where the actual CLI program project will be.

## Why a CLI tool?
Great practice structuring "real" software (ie without the guardrails of how stuff like web projects *need* to be laid out.)

## Areas I'd like to emphasize and practice here:
- Filesystem IO – pathlib, os, tempfile, shutil
- Process + system introspection – subprocess, platform, sys
- Error handling & logging – traceback, logging, rich
- Async foundations – reading files concurrently, API calls later
- Configuration – json, .env, simple CLI flags (argparse / typer)

## Topics to Cover:
1. Core
- Variables, types, casting
- Strings (formatting, f-strings, slicing, immutability)
- Lists, tuples, sets, dicts (mutation, comprehension, unpacking)
- Loops (for, while, enumerate, zip)
- Functions (positional/named/default args, args/kwargs, scoping)
- Lambdas & builtins (map, filter, any/all, sorted)

2. Data Handling & IO
- Read/write files (with open, CSV, JSON)
- using pathlib
- CLI args via argsparse
- Basic error handling, custom exceptions
- Datetime & timezone basics
- Simple data manipulations with collections (Counter, defaultdict, namedtuple)

3. Intermediate Constructs (FOCUS)
- List/dict/set comprehensions (plus nested ones)
- Generators & yield
- Iterators & next()
- Decorators (timing, caching, logging)
- Context managers (with + enter/exit dunder methods)
- Typing hints & dataclasses
- Basic enum and NamedTuple use

4. OOP Practice
- Inheritance & super()
- Method overriding
- repr, eq, lt (dunder methods)
- Composition vs inheritance examples
- ABCs (from abc import ABC, abstractmethod)

5. Async
- async def and await basics
- asyncio.gather vs threads
- concurrent.features example