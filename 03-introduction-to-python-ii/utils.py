import sys
import logging
import datetime as dt


class ProcessController:
    def __init__(self, name, logdir):
        log_level = logging.INFO
        logging.basicConfig(level=log_level)
        # Create a custom logger
        logger = logging.getLogger(name)
        logger.propagate = False

        logfile = dt.datetime.now().strftime("%Y-%m-%d")
        logfile = f"{logdir}/{logfile}.log"

        # Create handlers
        c_handler = logging.StreamHandler()
        f_handler = logging.FileHandler(logfile)
        c_handler.setLevel(logging.WARNING)
        f_handler.setLevel(logging.INFO)

        # Create formatters and add it to handlers
        c_format = logging.Formatter(fmt='[%(levelname)s] %(asctime)s : %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
        f_format = logging.Formatter(fmt='[%(levelname)s] %(asctime)s : %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
        c_handler.setFormatter(c_format)
        f_handler.setFormatter(f_format)

        # Add handlers to the logger
        logger.addHandler(c_handler)
        logger.addHandler(f_handler)

        self.logger = logger

    def info(self, msg: str) -> None:
        self.logger.info(msg)

    def warning(self, msg: str) -> None:
        self.logger.warning(msg)

    def error(self, msg: str) -> None:
        self.logger.error(msg)
        sys.exit(1)