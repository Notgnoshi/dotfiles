---
name: gitlab-jobstats
description: Use when analyzing GitLab CI/CD job history for flaky jobs or tests, failure rates by job name or branch, job durations and queue times, downloading job logs, or visualizing pipeline and job-log-section timing in Perfetto.
---

# gitlab-jobstats

The gitlab-jobstats project is a set of Python scripts for GitLab CI job statistics, from
https://github.com/Notgnoshi/gitlab-jobstats. They are not installed on PATH. Run them by full path
from `~/src/gitlab-jobstats/`. The scripts import each other, so always run them by path rather than
copying one elsewhere.

## Using these tools

These tools are available alongside whatever else is installed. Use the right tool for the job: one
of these, another purpose-built tool such as glab, or a script only when nothing fits. When another
tool fits better, say why. If a change to these tools would make the task easier, suggest it to the
user.

Check that `~/src/gitlab-jobstats/jobstats.py` exists before the first use in a session. If it does
not, tell the user and suggest
`git clone https://github.com/Notgnoshi/gitlab-jobstats ~/src/gitlab-jobstats`.

## Which tool

| Task                                                                                 | Script             |
| ------------------------------------------------------------------------------------ | ------------------ |
| Download a CSV of jobs from the API, filtered by branch, job name glob, status, date | `jobstats.py`      |
| Success and failure counts per job, and failure or duration plots, from that CSV     | `jobplot.py`       |
| Download job logs for the failed (or other status) jobs in that CSV                  | `joboutput.py`     |
| Rank failing test names across downloaded logs (GTest, cargo test, cargo nextest)    | `teststats.py`     |
| Convert one job log's collapsible sections into a Perfetto trace                     | `jobtrace.py`      |
| Merge several job traces into one                                                    | `mergetrace.py`    |
| Fetch and trace every job in a pipeline in one step                                  | `pipelinetrace.py` |

## Idioms

```sh
J=~/src/gitlab-jobstats

# Which jobs fail most on a branch, then which tests inside them
$J/jobstats.py --token-file ~/.gitlab-pat.txt --domain gitlab.example.com \
    --branch master --since 2026-06-01 my-group/my-project jobs.csv
$J/jobplot.py jobs.csv --jobs 'test*'
$J/joboutput.py --token-file ~/.gitlab-pat.txt --jobs 'test*' --output logs/ jobs.csv
$J/teststats.py logs/*.txt

# Where the time goes in one pipeline, for Perfetto
$J/pipelinetrace.py --token-file ~/.gitlab-pat.txt --domain gitlab.example.com <pipeline URL>
```

## Quirks

* Authentication is a GitLab personal access token passed with `--token-file`. Ask the user which
  file holds it. Never pass a token with `--token` on the command line, and never read or print the
  file.
* `--domain` defaults to one specific self-hosted instance. Always pass it explicitly.
* `jobstats.py` appends to an existing output CSV instead of overwriting it.
* The text output of `jobplot.py` has no dependencies. Its `--plot-failures` and `--plot-durations`
  need matplotlib and seaborn, which for interactive display need a desktop display manager.
* `teststats.py --pattern` takes a Python regex whose last capture group is the test name, for test
  frameworks it does not already recognize.

## Flags

Run `<script> --help` for options. Do not guess flags.
