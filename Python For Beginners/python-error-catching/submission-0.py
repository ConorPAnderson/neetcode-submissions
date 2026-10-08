def divide_numbers(a: str, b: str) -> None:
    try:
        int_a = int(a)
        int_b = int(b)
        print(int_a / int_b)
    except Exception as error:
        print(f"An error occurred: {error}")



# do not modify below this line
divide_numbers("10", "2")
divide_numbers("12", "0")
divide_numbers("2", "not a number")
