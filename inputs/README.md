# Input Files

This directory contains the input files for Advent of Code challenges.

## Structure

```
inputs/
├── 2024/
│   ├── day01.txt
│   ├── day02.txt
│   └── ...
├── 2023/
│   └── ...
└── README.md
```

## Usage

Input files are symlinked from solution directories to avoid duplication:

```bash
# From a solution directory
ln -s ../../../../inputs/2024/day01.txt input
```

## Getting Input Files

1. Go to [Advent of Code](https://adventofcode.com/)
2. Navigate to the specific year and day
3. Copy your personal input (requires login)
4. Save it as `inputs/YEAR/dayXX.txt`

**Note:** Input files are personal to each user and should not be committed to public repositories per AOC guidelines.
