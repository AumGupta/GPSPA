import asong as a
import argparse

# This code will only run if this module is executed directly, instead of being imported by another
# module. This is also useful to execute tests
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Song analyser")
    parser.add_argument('--song_dir', required=True, help="Directory where the song files are")
    parser.add_argument('--out_file', required=True, help="The output file (.json)")
    args = parser.parse_args()
    analysis = a.analyse_set(args.song_dir)
    a.save_result(analysis, args.out_file)
