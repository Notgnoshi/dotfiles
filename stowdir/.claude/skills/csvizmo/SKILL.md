---
name: csvizmo
description: Use when plotting, concatenating, or computing statistics or inter-row deltas on CSV files, or when parsing CAN bus logs (candump, NMEA 2000, ISO 11783 transport protocol) into CSV or QGIS projects.
---

# csvizmo

csvizmo is a collection of small single-purpose CLI tools for working with CSV files and CAN logs,
from https://github.com/Notgnoshi/csvizmo. Every tool reads stdin when no input is given, writes to
stdout, and puts logs and warnings on stderr, so they chain with pipes.

## Using these tools

These tools are typically installed to the user's `$PATH`. Use the right tool for the job: one of
these, another purpose-built tool such as csvtool, qsv, miller, sed, awk, etc., or a script when
nothing fits. When another tool fits better, say why. If a change to these tools would make the task
easier, suggest it to the user.

Run `command -v csvstats` before the first use in a session. If it is missing, tell the user and
suggest installing from https://github.com/Notgnoshi/csvizmo with `./install --prefix ~/.local`.

## Which tool

| Task                                                                                | Tool                                    |
| ----------------------------------------------------------------------------------- | --------------------------------------- |
| Summary statistics (count, quartiles, mean, stddev) or a histogram of CSV columns   | `csvstats`                              |
| Line, scatter, or time-series plot of CSV columns                                   | `csvplot`                               |
| Concatenate CSV files with the same header                                          | `csvcat`                                |
| Inter-row deltas of a column (time between events), or centering a column           | `csvdelta`                              |
| Parse a candump into CSV with the 29-bit ID split into priority, src, dst, pgn      | `can2csv`                               |
| Reconstruct NMEA 2000 Fast Packet or ISO 11783-3 Transport Protocol sessions        | `canstruct`, or `can2csv --reconstruct` |
| Extract NMEA 2000 GPS positions from a candump                                      | `can2k`                                 |
| Annotate transport protocol control frames in a candump for reading                 | `annotate-tp`                           |
| Build a QGIS project from CSVs with a WKT `geometry` column (needs the qgis module) | `qgsdir`                                |
| Generate random CAN traffic (needs a CAN interface and cangen)                      | `canspam`                               |

## Idioms

Columns are selected by header name or zero-based index.

```sh
# Time between consecutive CAN frames, then the distribution of those deltas
can2csv candump.log | csvdelta -c timestamp | csvstats -c timestamp-deltas --histogram -o deltas.png

# can2csv output is plain CSV, so standard tools apply after it
can2csv candump.log | cut -d, -f6 | sort | uniq -c | sort -rn | head

# Several columns at once. Plots go to a file with -o, or to a gnuplot window without it.
csvstats -c dlc,priority frames.csv
csvplot -x timestamp -y latitude_deg,longitude_deg -o track.svg gps.csv

# qgsdir needs WKT geometry, which can2k only emits with --wkt
can2k --wkt candump.log gps.csv && qgsdir gps.csv
```

## Flags

Run `<tool> --help` for options. Do not guess flags.
