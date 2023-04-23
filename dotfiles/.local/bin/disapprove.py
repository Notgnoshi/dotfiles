#!/usr/bin/env python3
"""Disapproves with ever-increasing fervor."""
import argparse


def parse_args():
    """Disapprovingly parse arguments."""
    VERSION = "0.2"

    parser = argparse.ArgumentParser(description=__doc__)

    parser.add_argument("--version", action="version", version=VERSION)
    parser.add_argument("-v", "--verbose", action="count", help="Increase verbosity e.g.: -vvvv")

    return parser.parse_args()


def main(args):
    """Disapproves with ever-increasing fervor."""
    if args.verbose is None:
        print(u"ಠ_ಠ")
    elif args.verbose == 1:
        print(u"ಠ益ಠ")
    elif args.verbose == 2:
        print(u"( ͡ಠ ʖ̯ ͡ಠ)")
    elif args.verbose == 3:
        print(u"(ノಠ益ಠ)ノ")
    elif args.verbose == 4:
        print(u"(╯°□°）╯︵ ┻━┻")
    else:
        print(u"(ノಠ益ಠ)ノ彡┻━┻")


if __name__ == "__main__":
    main(parse_args())
