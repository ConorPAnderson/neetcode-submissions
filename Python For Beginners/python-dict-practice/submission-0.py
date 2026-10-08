from typing import Dict # this adds type hinting for Dict

def count_characters(word: str) -> Dict[str, int]:
    occurence_dict = {}
    for char in word:
        if char not in occurence_dict:
            occurence_dict[char] = 1
        else:
            occurence_dict[char] += 1
    return occurence_dict




# don't modify below this line
print(count_characters("hello"))
print(count_characters("world"))
print(count_characters("hello world"))
print(count_characters("this is a longer sentence"))
