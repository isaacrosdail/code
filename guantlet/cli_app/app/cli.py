
def main():
    print("Welcome to Guantlet. What would you like to do?")

    while True:
        match name := input('>> '):
            case 'q':
                break
            case 'split;t':
                new = name.split(";")
                print(f"{new}")
            case _:
                print(f"Name was: {name}")

if __name__ == "__main__":
    main()