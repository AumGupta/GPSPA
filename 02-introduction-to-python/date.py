

class Date:
    # This is class level data
    # This variable does not exist outside the class
    # All UPPERCASE is a way to inform programmers that the variable is a constant.
    MONTHS_NAME = {
        1: "Jan",
        2: "Feb",
        3: "Mar",
        4: "Apr",
        5: "May",
        6: "Jun",
        7: "Jul",
        8: "Ago",
        9: "Sep",
        10: "Oct",
        11: "Nov",
        12: "Dec",
    }

    def __init__(self, day, month, year):
        if not Date.__validate__(day, month, year):
            raise ValueError("ERROR: invalid date")
        # if the script got here, the date elements are OK
        self.day = day
        self.month = month
        self.year = year

    def date_str(self, sep="-", style="European"):
        """Converts a date into a string

        Args:
            sep (str, optional): date seperator. Defaults to "-".
            style (str, optional): date style. Defaults to "European".

        Returns:
            str: stringifyed date
        
        Raises:
            ValueError if style is not recognized
        """
        if style == "European":
            return f"{self.day:02d}{sep}{self.month:02d}{sep}{self.year:04d}"
        if style == "American":
            return f"{self.month:02d}{sep}{self.day:02d}{sep}{self.year:04d}"
        if style == "Verbal":
            month = Date.MONTHS_NAME[self.month]
            day = f"{self.day}{self.__get_day_ending__()}"
            return f"{month}, {day} {self.year}"
        # unrecognized style error
        raise ValueError(f"ERROR: invalid style '{style}'")

    def __get_day_ending__(self):
        """Returns the ending of the day number

        Returns:
            str: the day ending
        """
        if self.day == 1:
            return "st"
        if self.day == 2:
            return "nd"
        if self.day == 3:
            return "rd"
        return "th"

    def __is_leap__(year):
        """Class internal function: checks if a year is leap

        Returns:
            bool: True if and only if year is leap
        """
        return year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)

    def __validate__(day, month, year):
        """Class internal function: validates a date.

        Args:
            day (int): the day
            month (int): the month
            year (int): the year

        Returns:
            bool: True if and only if date is valid
        """
        if day <= 0 or day > 31:
            return False
        if month <=0 or month > 12:
            return False
        if year < 0:
            return False
        if month == 2:
            if Date.__is_leap__(year):
                return day <= 29
            return day <= 28
        return True

# This condition tests if python is running this module directly or 
# as an import to another module
# This is useful to run some tests to make sure the module is working properply
# before we use it somewhere else.
if __name__ == "__main__":
    print("####################################")
    d0 = Date(1, 6, 2021)
    print(d0.date_str(sep="-", style="European"))
    print(d0.date_str(sep="/", style="American"))
    print(d0.date_str(style="Verbal"))

    print("####################################")
    d1 = Date(15, 6, 2021)
    print(d1.date_str(sep="-", style="European"))
    print(d1.date_str(sep="/", style="American"))
    print(d1.date_str(style="Verbal"))