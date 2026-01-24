class Fraction:
    def __init__(self, numerator, denominator):
        if denominator == 0:
            raise ValueError("ERROR: denominator cannot be zero")
        numerator = int(numerator)
        denominator = int(denominator)
        self.numerator, self.denominator = Fraction.__reduce__(numerator, denominator)
    
    def __add__(self, other):
        numerator = self.numerator * other.denominator + self.denominator * other.numerator
        denominator = self.denominator * other.denominator
        return Fraction(numerator, denominator)
    
    def __sub__(self, other):
        numerator = self.numerator * other.denominator - self.denominator * other.numerator
        denominator = self.denominator * other.denominator
        return Fraction(numerator, denominator)
    
    def __mul__(self, other):
        numerator = self.numerator * other.numerator
        denominator = self.denominator * other.denominator
        return Fraction(numerator, denominator)
    
    def __truediv__(self, other):
        numerator = self.numerator * other.denominator
        denominator = self.denominator * other.numerator
        return Fraction(numerator, denominator)
    
    def __reduce__(numerator, denominator):
        # This is a class method
        # Find greatest common divisor
        a = numerator
        b = denominator
        while b != 0:
            t = b
            b = a % b
            a = t
        return numerator // a, denominator // a
    
    def __repr__(self):
        if self.denominator == 1:
            return f"{self.numerator}"
        return f"{self.numerator}/{self.denominator}"

    def __pow__(self, other):
        numerator = self.numerator ** (other.numerator / other.denominator)
        denominator = self.denominator ** (other.numerator / other.denominator)
        # scale the numerator and denominator for getting a more accurate fraction
        numerator *= 1000000
        denominator *= 1000000
        return Fraction(numerator, denominator)
            