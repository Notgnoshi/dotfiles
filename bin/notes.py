#!/usr/bin/env python3
import argparse
import os
from datetime import datetime
from pathlib import Path
from subprocess import call

import parsedatetime


def parse_args():
    """
        Defines and parses commandline arguments for note-taking script.
    """
    DESCRIPTION = "A small script to facilitate taking, searching, and organizing notes."
    VERSION = "0.2"

    parser = argparse.ArgumentParser(description=DESCRIPTION)
    group = parser.add_mutually_exclusive_group()

    parser.add_argument('--version', action='version', version=VERSION)
    group.add_argument('--todo',
                       action='store_true',
                       default=False,
                       help='Open the TODO list.')
    group.add_argument('-r', '--relative',
                       nargs='+',
                       help='Open the note from a relative time. E.g. "yesterday" or "3 days ago"')

    # TODO: Add argument to sync notes with server?
    # parser.add_argument('--sync', action='store_true', help='Sync notes with master copies')

    return parser.parse_args()


def main():
    """
        Opens the note file, etc.
    """
    args = parse_args()

    # Try to use the default editor, or just insist on Vim.
    EDITOR = os.environ.get('EDITOR', 'vim')
    # Save the notes in a reasonable directory.
    NOTES_PATH = f'{Path.home()}/Documents/notes/'
    # E.g., '# Friday May 04 at 14:35:52', with an important newline.
    HEADER = f'# {datetime.now().strftime("%A %B %d at %X")}\n'

    if args.todo:
        FILENAME = 'todo.md'
    elif args.relative:
        args.relative = ' '.join(args.relative)
        cal = parsedatetime.Calendar()
        time, status = cal.parse(args.relative)

        if not status:
            print('Failed to parse relative time:', args.relative)
            exit(1)

        FILENAME = f'{datetime(*time[:6]).strftime("%Y-%m-%d")}.md'
    else:
        # E.g., '2018-05-04.md'.
        FILENAME = f'{datetime.now().strftime("%Y-%m-%d")}.md'

    path = Path(NOTES_PATH)
    if not path.exists():
        path.mkdir(parents=True)

    note = Path(NOTES_PATH + FILENAME)
    # Append the markdown header to file. Also creates the file if it doesn't exist.
    with open(note, 'a') as f:
        f.write(HEADER)

    # Ensure the file is read/writeable only by user, but only after the file is saved.
    os.chmod(note, 0o600)
    # Finally, open the file with the editor.
    call([EDITOR, note])


if __name__ == '__main__':
    main()
