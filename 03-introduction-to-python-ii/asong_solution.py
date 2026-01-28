import utils as u
import json

from os import listdir
from os.path import isfile, join

LOGGER = u.ProcessController("asong_solution", "./log")
FORBIDDEN_WORDS = ["a", "the", "than", "that", "in"]
# TODO: Add any necessary constants
SPECIAL_CHAR = '(),?;:'


def read_file(fname: str) -> dict:
    """Reads a song file

    Args:
        fname (str): the name of the file

    Returns:
        dict: the song
    """
    try:
        # dictionary comprehension
        with open(fname, "r") as f:
            song = {i: line for i, line in enumerate(f)}
        # Get the song name
        # TODO: extract the song name
        # 'c:/users/testing/gps/.../oasis/01-champagne_supernova.txt'
        song_name = fname.split("/")[-1]
        song_name = song_name.split(".")[0]
        song_name = song_name.split("-")[1]
        song_name = song_name.replace("_", " ")

    except Exception as e:
        LOGGER.error(f"{e}")
    return {
        "song name": song_name,
        "verses": song
    }


# TODO: Implement me!
def count_characters(s: str) -> int:
    """Counts the non-space characters in a string

       Args:
          s [str]: the string

       Returns:
          The number of non-space characters in s

       Examples:
          >> count_characters("12 34")
          4
    """
    return len(s) - s.count(" ") - s.count("\n") 


def count_words(s: str) -> int:
    """ Counts the number of words in a string

        Args:
          s [str]: the string

        Returns:
          int: the number of words in s
    """
    l = s.split(" ")

    return len([c for c in l if c != ''])

    # In the above line the code inside len() is called a list compreention
    # It's a one line code for writing something like this:
    #words = []
    #for c in l:
    #    if c != '':
    #        words.append(w)



def word_frequency(verses: dict) -> dict:
    """ Identify and Count the word frequency

        Args:
          s [dict]: a dictionary containing verses

        Returns:
          dict: a dictionary containg the most repeated word and its count
    """

    # TODO: What is this line doing?
    s = " ".join([verses[vix] for vix in verses])

    # TODO: remove unnecessary characters from s
    # and convert to lower-case

    for i in SPECIAL_CHAR:
        s  = s.replace(i, "")
    s = s.lower()


    # Break the string into words
    words = s.split(" ")
    word_set = set(words)
    max_count = 0
    max_word = ""
    for w in word_set:
        if w not in FORBIDDEN_WORDS:
            count = 0
            for ww in words:
                if ww == w:
                    count += 1
            if count > max_count:
                max_count = count
                max_word = w
    return {
        "word": max_word,
        "count": max_count,
    }


def verse_frequency(verses: dict) -> dict:
    # TODO: write docstring
    """ Identify and Count the verse frequency

        Args:
          s [dict]: a dictionary containing verses

        Returns:
          dict: a dictionary containing the most repeated verse and its count
    """
    verse_list = [verses[vix].lower().replace("\n", "")
                  for vix in verses]
    verse_set = set(verse_list)
    max_count = 0
    max_verse = ""
    for v in verse_set:
        count = 0
        for vv in verse_list:
            if vv == v:
                count += 1
        if count > max_count:
            max_count = count
            max_verse = v
    return {
        "verse": max_verse,
        "count": max_count,
    }


def song_analyser(song: dict) -> dict:
    """Analyses a song

    Args:
        song (dict): a dictionary represenging a song

    Returns:
        dict: dictionary describing the song
    """
    num_characters = 0
    num_verses = 0
    num_words = 0
    song_name = song["song name"]
    verses = song["verses"]
    # TODO: Use te logger to inform the user of what is as suggested in the README.md file
    LOGGER.info(f'Analysing the "{song_name}" song.')
    # Accumulative effect
    for idx in verses:
        v = verses[idx]
        num_characters += count_characters(v)
        num_words += count_words(v)
        num_verses += 1
        # TODO: Use te logger to inform the user of what is as suggested in the README.md file
        LOGGER.info(f'{num_verses} / {len(verses)} rows processed')
    return {
        "song name": song_name,
        "stats": {
            "number of characters": num_characters,
            "number of words": num_words,
            "number of verses": num_verses,
            "most frequent word": word_frequency(verses),
            "most frequent verses": verse_frequency(verses),
        }
    }


def get_folder_content(dir: str) -> list:
    """ Returns a list of the files in the directory

    Args:
        dir (str): the path to the directory

    Returns:
        list: the list of files in the directory
    """
    return [f for f in listdir(dir) if isfile(join(dir, f))]


def analyse_set(dir: str) -> dict:
    """ Analyse a set of songs

    Args:
        dir (str): the directory where songs are

    Returns:
        dict: a dictionary with the analysis of each song
    """
    res = {}
    song_files = get_folder_content(dir)
    for file in song_files:
        song = read_file(f"{dir}/{file}")
        out = song_analyser(song)
        res[out["song name"]] = out["stats"]
    return res


def save_result(data: dict, outfile: str) -> None:
    """ Saves a dictionary in JSON file

    Args:
        data (dict): the data to save
        outfile (str): the name of the file (.json)
    """
    try:
        with open(outfile, 'w') as fp:
            json.dump(data, fp, indent=4)
    except Exception as e:
        LOGGER.error(e)

# This piece of code only runs if this module is run directly, instead of imported by another
# It's very useful for testing a debugging your functions without the need to run the full program
if __name__ == "__main__":
    count = count_words('This is a test')
    print(count)
