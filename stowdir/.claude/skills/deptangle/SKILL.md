---
name: deptangle
description: Use when converting, filtering, diffing, clustering, or querying dependency graphs in DOT, Mermaid, TGF, depfile, cargo tree, cargo metadata, cmake, ninja, or BitBake output, or when shortening a list of file paths to unique suffixes.
---

# deptangle

deptangle is a set of targeted CLI tools for working with dependency graphs, from
https://github.com/Notgnoshi/deptangle. Every tool reads stdin when no input is given, writes to
stdout, and logs to stderr, so they chain with pipes. All of them accept the same graph formats,
auto-detected from the file extension or content, and emit DOT unless `-O` or the output file's
extension says otherwise.

## Using these tools

These tools are typically installed to the user's `$PATH`. Use the right tool for the job: one of
these, another purpose-built tool such as graphviz, or a script only when nothing fits. When another
tool fits better, say why. If a change to these tools would make the task easier, suggest it to the
user.

Run `command -v depconv` before the first use in a session. If it is missing, tell the user and
suggest installing from https://github.com/Notgnoshi/deptangle with `./install --prefix ~/.local`.

## Which tool

| Task                                                                                            | Tool                        |
| ----------------------------------------------------------------------------------------------- | --------------------------- |
| Convert between DOT, Mermaid, TGF, depfile, tree, and pathlist; parse cargo tree or metadata    | `depconv`                   |
| Keep or drop nodes by glob, optionally with their deps or rdeps                                 | `depfilter select`          |
| Subgraph of all paths between sets of nodes                                                     | `depfilter between`         |
| Find cycles                                                                                     | `depfilter cycles`          |
| Cut edges between subgraphs                                                                     | `depfilter slice`           |
| Reverse edges, transitive reduction, shorten path IDs, sed on IDs or attributes, merge, flatten | `deptransform <subcommand>` |
| List nodes or edges sorted by degree, ancestors, descendants, or topological order; metrics     | `depquery <subcommand>`     |
| Cluster nodes into subgraphs by community detection                                             | `depcluster`                |
| Compare two graphs: annotated graph, tab-separated list, summary counts, set difference         | `graphdiff <subcommand>`    |
| Shorten a list of file paths to the minimal unique suffix                                       | `minpath`                   |
| BitBake recipe inheritance diagram (needs a BitBake environment)                                | `bbclasses`                 |

`depquery` and `graphdiff list` and `summary` print tab-separated text, not a graph.

## Idioms

Input is `-i FILE` or stdin, never a positional argument, except `graphdiff <before> <after>` and
`minpath`. Formats are nominally auto-detected; pass `-I` and `-O` to override the graph formats.

```sh
# The 5 crates with the most direct dependencies
cargo metadata --format-version=1 | depquery nodes --sort out-degree --limit 5

# Subtree under a crate, without proc-macro crates, from cargo tree text
cargo tree | depfilter select -g 'clap*' --deps -x '*derive*' -x '*proc*' -I cargo-tree -O mermaid

# TGF is the quickest hand-written input: nodes, a '#' line, then 'from to' edges
printf 'a\nb\nc\n#\na b\nb c\na c\n' | deptransform simplify -I tgf

# Chain tools; the graph is DOT between them. No cycles gives an empty digraph.
depfilter cycles -i deps.dot | depquery nodes

# Collapse bitbake task nodes into recipes, then drop the now-wrong labels
deptransform sub 's/\.do_.*//' -i task-depends.dot | deptransform sub --key=node:label 's/.*//'
```

## Flags

Run `<tool> --help` and `<tool> <subcommand> --help` for options. Do not guess flags.
