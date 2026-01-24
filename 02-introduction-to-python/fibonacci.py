import sys

ABOUT_FIBONACCI = {
    "name": "Leonardo Bonacci",
    "date of birth": "1170",
    "date of death": "1250",
    "summary": """
        Fibonacci was born around 1170 to Guglielmo, an Italian merchant and customs official. Guglielmo directed a trading post in Bugia, Algeria. Fibonacci travelled with him as a young boy, and it was in Bugia where he was educated that he learned about the Hindu–Arabic numeral system.
        Fibonacci travelled around the Mediterranean coast, meeting with many merchants and learning about their systems of doing arithmetic. He soon realised the many advantages of the Hindu-Arabic system, which, unlike the Roman numerals used at the time, allowed easy calculation using a place-value system. In 1202, he completed the Liber Abaci (Book of Abacus or The Book of Calculation), which popularized Hindu–Arabic numerals in Europe.
        Fibonacci was a guest of Emperor Frederick II, who enjoyed mathematics and science. In 1240, the Republic of Pisa honored Fibonacci (referred to as Leonardo Bigollo) by granting him a salary in a decree that recognized him for the services that he had given to the city as an advisor on matters of accounting and instruction to citizens.
        Fibonacci is thought to have died between 1240 and 1250, in Pisa.
    """,
}

class GoldenRatio:
    def estimate_golden_ratio(n=100):
        if n <= 1: 
            raise ValueError("ERROR: n <= 1")
        else: 
            a, b = 0, 1
            for _ in range(2, n): 
                c = a + b 
                a = b 
                b = c 
        return b / a

def print_fibonacci_numbers(nterms=100):
    n1, n2 = 0, 1
    count = 0
    if nterms <= 0:
        sys.exit("ERROR: nterms negative")
    elif nterms == 1:
        print("Fibonacci sequence up to ", nterms,":")
        print(n1)
    else:
        print("Fibonacci sequence: ")
        while count < nterms:
            print(n1)
            nth = n1 + n2
            # update values
            n1 = n2
            n2 = nth
            count += 1