# Introduction to Python II

## The challenge

### Description

I believe the best way to learn how to programme, and in particular, how to programme in Python, is by solving a problem. So the problem (or challenge) is this:

In folder `data/oasis/` you will find several Oasis lyrics. These are `txt` files with a verse per line. Write a Python programme that for each file (song) and extract the follow information:

1. The number of characters, number of verses, number of words, and the number of different words;
2. The most frequent word that is not "a", "the", "than", "in", and its frequency (absolute count);
3. The most frequent verse and its frequency (absolute count);

### Results

Write the output in the `results/` folder in a file named `YYYYMMDD-HHMMSS.json` with a following structure: 

```json
{
    "Champagne supernova": {
        "number of characters": 1234,
        "number of verses": 61,
        "number of words": 300,
        "number of different words": 121,
        "most frequent word": {
            "word": "wonderwall",
            "count": 20,
        },
        "most frequent verse": {
            "verse": "You're gonna be the one that saves me",
            "count": 10,
        }
    },
}
```

## Data

The data can be found in `data/` and initially contains the subfolder `oasis/` with four `txt` files. These files are song lyrics. The name of the files have the structure `ID-SONG_NAME.txt`, where `ID` is a sequencial identifier with the format `DD`, and `SONG_NAME` is the name of the song where spaces are replaced by underscore, all lowercase ASCII characters. These files contain one verse per line.

## Programme features

### Running the programme

The programme should work as a command line utility in the following way:

```shell
$ python main.py -song_dir <input-folder> -out_file <output-file>
```

The programme should send an help message if the user does not use the application correctly. For example, 
if it is missed the input folder. 

### Logging

Logs should:

* In case of an error, report the error with a timestamp, and stop the programme;
* Inform with the timestamp of the progress and state of the work, including the name of current function;
* Write to `stdout` or `stderr`, in case of error, or warning into a log file.
* Log files should have the following file name structure `YYYYMMDD-HHMMSS.log` and should be added to `log/`.

Example of an information logging:

```shell
[INFO] 2021-01-02 14:26:32 : working on '01-wonderwall.txt' : 10 lines of 42 analysed.
```

Example of an error logging:

```shell
[ERROR] 2021-01-03 14:32:55 : Could not read '02-champagne_supernova.txt'.
```

### Academic constraints

Use only built-in packages.

### Helpers

Now that I have tried to scared you. The program is partially done, you just need to finish it. 
Check the program structure (main.py, asong.py and utils.py). There are a few TODOs in the code for you to complete.
There are some interesting packages being used. Give a look at their documentation to understand what the are useful for and how they work. Namely:

* argparse
* os
* logging
* datetime
* sys

Tip: Python Documentation for the argparse package is [here](https://docs.python.org/3.13/library/argparse.html).
