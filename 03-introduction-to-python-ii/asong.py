import utils as u
import json

from os import listdir
from os.path import isfile, join, abspath, dirname

base_dir = dirname(abspath(__file__))
LOGGER = u.ProcessController("asong", join(base_dir, "log"))
FORBIDDEN_WORDS = ["a", "the", "than", "that", "in", "i"]
# TODO: Add any necessary constants for example pontuation
# and other characters you want to exclude from letter and word counting

def read_file(fname: str) -> dict:
    """Reads a song file

    Args:
        fname (str): the name of the file '/location/name.extension'

    Returns:
        dict: the song
    """
    try:
        # dictionary comprehension
        with open(fname, "r") as f:
            song = {i: line for i, line in enumerate(f)}
        # Get the song name
        # TODO: [REFINE] extract the song name based on fname
        song_name = fname.split('/')[-1].split('.')[-2][3:].replace('_',' ').title()
    except Exception as e:
        LOGGER.error(f"{e}")
    return {
        "song name": song_name,
        "verses": song
    }


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
    return len(s.replace(' ', ''))

def clean(s: str) -> str:
    """
    Removes all the characters from a string that are not alphabets or spaces.
    
    :param s: Description
    :type s: str
    :return: Description
    :rtype: str
    """
    for i in s.lower():
        if i == ' ' or (ord(i) > 96 and ord(i) < 123):
            continue
        s = s.replace(i,'')
    return s

def count_words(s: str) -> int:
    """ Counts the number of words in a string

        Args:
          s [str]: the string

        Returns:
          int: the number of words in s
    """
    return len([x for x in clean(s).split(' ') if x!=''])


def word_frequency(verses: dict) -> dict:
    """ Counts the frequency of most frequent word in the song
    
        Args:
          verses [dict]: the dictionary of verses

        Returns:
          dictionary: frequency of most frequent word
    """
    s = "".join([verses[vix].replace('\n',' ') for vix in verses]) # make this clearer

    list = []
    for vix in verses:
        list.append(verses[vix])

        s=clean(s).lower()
    
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
    """ Counts the frequency of most frequent verse in the song
    
        Args:
          verses [dict]: the dictionary of verses

        Returns:
          dictionary: frequency of most frequent verse
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
        song (dict): a dictionary representing a song

    Returns:
        dict: dictionary describing the song
    """
    num_characters = 0
    num_verses = 0
    num_words = 0
    song_name = song["song name"]
    verses = song["verses"]
    # Accumulative effect
    for idx in verses:
        v = verses[idx]
        num_characters += count_characters(v)
        num_words += count_words(v)
        num_verses += 1
        LOGGER.info(f"working on '{song_name}' : {num_verses} lines of {len(verses)} analysed.")
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
            json.dump(data, fp)
    except Exception as e:
        LOGGER.error(e)

if __name__ == "__main__":
    # Test read_file function
    song = read_file(join(base_dir, "data/oasis/01-wonderwall.txt"))
    print(song)
    # Test error logging
    read_file(join(base_dir, "data/oasis/01-ola.txt"))