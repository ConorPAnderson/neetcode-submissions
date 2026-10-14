class PasswordManager:
    def __init__(self, __password):
        self.__password = __password
    
    # TODO: Implement the verify_password method
    def verify_password(self, password):
        if password == self.__password:
            return True
        else:
            return False


# Don't modify the code below this line
my_password = PasswordManager("secret123")
print(my_password.verify_password("secret123"))  # Should print: True
print(my_password.verify_password("wrong"))      # Should print: False
