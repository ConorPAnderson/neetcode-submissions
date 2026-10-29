class Animal:
    def __init__(self, name: str):
        self.name = name
    
    def make_sound(self) -> None:
        print("Animal is making a sound")

class Dog(Animal):
    def make_sound(self) -> str:
        print(f"{self.name} says: Woof!")

class Cat(Animal):
    def make_sound(self) -> str:
        print(f"{self.name} says: Meow!")
# TODO: Create the Dog and Cat classes with make_sound method


# TODO: Create a common interface that takes any object of type Animal (or its subclasses) and calls their make_sound method
def make_sound(animal: Animal) -> None:
    animal.make_sound()


# Do not change the code below
animal = Animal("Rabbit")
animal.make_sound()

animal = Dog("Buddy")
animal.make_sound()

animal = Cat("Whiskers")
animal.make_sound()
