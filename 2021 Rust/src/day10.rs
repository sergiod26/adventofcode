#[aoc_generator(day10)]
pub fn input_generator(input: &str) -> Vec<Vec<char>> {
    input.lines().map(|l| l.chars().collect()).collect()
}

#[aoc(day10, part1)]
pub fn part1(input: &[Vec<char>]) -> i32 {
    let mut points: i32 = 0;
    for line in input {
        points += calculate_illegal(line);
    }
    points
}

#[aoc(day10, part2)]
pub fn part2(input: &[Vec<char>]) -> u64 {
    let mut result: Vec<u64> = vec![];
    for line in input {
        let points = calculate_autocomplete(line);
        if points > 0 {
            result.push(points);
        }
    }

    result.sort_unstable();
    result[result.len() / 2]
}

fn calculate_illegal(line: &[char]) -> i32 {
    let mut track = vec![];
    for &c in line {
        if is_open(c) {
            track.push(c);
        } else if is_match(*track.last().unwrap(), c) {
            track.pop();
        } else {
            //Line is corrupted
            return get_illegal_points(c);
        }
    }
    //Line is incomplete
    0
}

fn calculate_autocomplete(line: &[char]) -> u64 {
    let mut track = vec![];
    for &c in line {
        if is_open(c) {
            track.push(c);
        } else if is_match(*track.last().unwrap(), c) {
            track.pop();
        } else {
            //Line is corrupted, zeroes will be ignored
            return 0;
        }
    }
    let mut score: u64 = 0;
    while let Some(c) = track.pop() {
        score = (score * 5) + get_autocomplete_points(c);
    }
    score
}

fn is_open(c: char) -> bool {
    c == '(' || c == '[' || c == '{' || c == '<'
}

fn is_match(c: char, o: char) -> bool {
    c == '(' && o == ')' || c == '[' && o == ']' || c == '{' && o == '}' || c == '<' && o == '>'
}

fn get_illegal_points(c: char) -> i32 {
    match c {
        ')' => 3,
        ']' => 57,
        '}' => 1197,
        '>' => 25137,
        _ => panic!(),
    }
}

fn get_autocomplete_points(c: char) -> u64 {
    match c {
        '(' => 1,
        '[' => 2,
        '{' => 3,
        '<' => 4,
        _ => panic!(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = r#"[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]"#;

    #[test]
    pub fn part1_test() {
        let result = part1(&input_generator(INPUT));
        assert_eq!(result, 26397);
    }

    #[test]
    pub fn part2_test() {
        let result = part2(&input_generator(INPUT));
        assert_eq!(result, 288957);
    }
}
