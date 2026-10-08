def divide_numbers(a: str, b: str) -> None:
    try:
        num_a = int(a)
        num_b = int(b)
        result = num_a / num_b
        print(result)
    except ValueError:
        print("Error: Invalid value!")
    except ZeroDivisionError:
        print("Error: Division by zero!")
    except Exception as error:
        print(f"An error occurred: {error}")



# do not modify below this line
divide_numbers("10", "2")
divide_numbers("12", "0")
divide_numbers("2", "not a number")
