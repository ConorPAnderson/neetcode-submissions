class BankAccount:
    def __init__(self, balance: int): 
        self.__balance = balance
        
    @property    
    def balance(self) -> int:
        return self.__balance

    @balance.setter    
    def balance(self, value: int) -> None:
        if value >= 0:
            self.__balance = value
        else:
            print("Balance cannot be negative!")


account = BankAccount(1000)
print(account.balance)
account.balance = -100
