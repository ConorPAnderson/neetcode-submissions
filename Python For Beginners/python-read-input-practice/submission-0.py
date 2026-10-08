def add_two_numbers() -> int:
    string_input = input().split(",")
    int_input = []
    for i in string_input:
        int_input.append(int(i))
    return sum(int_input)

    



# do not modify below this line
print(add_two_numbers())
print(add_two_numbers())
print(add_two_numbers())
print(add_two_numbers())
