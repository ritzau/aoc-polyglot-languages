#!/usr/bin/env python3

import pytest
from solution import solve_part1, solve_part2

EXAMPLE = """3   4
4   3
2   5
1   3
3   9
3   3"""


def test_part1():
    assert solve_part1(EXAMPLE) == 11


def test_part2():
    assert solve_part2(EXAMPLE) == 31
