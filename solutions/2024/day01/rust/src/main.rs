use std::fs;

fn main() {
    let input = fs::read_to_string("input").expect("Failed to read input file");

    println!("Part 1: {}", solve_part1(&input));
    println!("Part 2: {}", solve_part2(&input));
}

fn solve_part1(input: &str) -> i32 {
    // TODO: Implement part 1 solution
    0
}

fn solve_part2(input: &str) -> i32 {
    // TODO: Implement part 2 solution
    0
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "3   4
4   3
2   5
1   3
3   9
3   3";

    #[test]
    fn test_part1() {
        assert_eq!(solve_part1(EXAMPLE), 0);
    }

    #[test]
    fn test_part2() {
        assert_eq!(solve_part2(EXAMPLE), 0);
    }
}
