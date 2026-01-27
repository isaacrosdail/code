from datetime import datetime

# Start with commands that map cleanly to OS concepts: 
# cat (file I/O, buffering), 
# ls (stat, permissions, globbing), and 
# pwd (process working directory). 
# Then add cd to understand why it must be a shell builtin and how child processes differ. 
# After that, try cp/mv (atomicity, overwrite semantics) and grep (streaming, regex performance). Keep each tool small

# abstract syntax tree -> parses Python into a tree structure (w/o executing it)
import ast
import regex as re
import argparse # Stdlib tool for defining and parsing cmdline args in a structured way

# Are all ANSI codes:
# start with \x1b[
# followed by the code/command for the color/effect
# \1xb -> ESC ?
GREEN = "\x1b[32m"
CYAN = "\x1b[36m"
ANSI_RESET = "\x1b[0m"  # clear text color

# ANSI "controls"?
CLEAR = "\x1b[2J"       # 
ANSI_HOME = "\x1b[H"    # moves cursor to home pos (r1, c1)
ANSI_TO = "\x1b["

def cursor_to(row: int, col: int) -> None:
    ANSI_TO_BASE = "\1xb["
    ansi_to = f"{ANSI_TO_BASE}{str(row)};{str(col)}"
    print(f"{ansi_to}")

def parse_input(user_input: str):
    try:
        return ast.literal_eval(user_input) # literal_eval raises appropriate syntax errs
    except (ValueError, SyntaxError):
        # not a literal, treat as command string
        return user_input.strip()

# Check similarity index to known commands?
COMMANDS = ['q', 'time', 'clear']

def similarity_index(inp: str):
    # toss len first, cheap & prob hits a good portion?
    
    for s in inp:
        



def main() -> None:
    TERMINAL_COLOR = CYAN
    argpsr = argparse.ArgumentParser()

    # Core input loop
    print(f"\n{GREEN}Welcome to the Matrix: Reloaded. Enter 'q' to quit{ANSI_RESET}\n")
    while True:
        line = parse_input(input(f'{TERMINAL_COLOR}>>{ANSI_RESET} '))
        match line:
            case 'q':
                break
            case 'time':
                hh_mm = f"{datetime.now().strftime('%I:%M %p')}"
                print(f"Current time is {hh_mm}")
            case 'clear' | 'cl':
                print(f"{CLEAR}{ANSI_HOME}")
            case s if isinstance(s, str) and re.fullmatch(r"\s*\d+\s*,\s*\d+\s*", s):
                print("MATCH")
            case [1, 2, *rest]:
                print(type(rest))
                print(rest)


if __name__ == '__main__':
    main()