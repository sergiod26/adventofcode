pub struct Line(String, i32);

#[aoc_generator(day2)]
pub fn input_generator(input: &str) -> Vec<Line> {
    input
        .lines()
        .map(|l| {
            let sp: Vec<&str> = l.split(" ").collect();
            Line(sp[0].to_string(), sp[1].parse::<i32>().unwrap())
        })
        .collect()
}

#[aoc(day2, part1)]
pub fn part1(input: &[Line]) -> i32 {
    let mut horizontal = 0;
    let mut depth = 0;
    input.iter().for_each(|Line(d, v)| match d.as_str() {
        "forward" => horizontal += v,
        "down" => depth += v,
        "up" => depth -= v,
        _ => panic!("WHY?!"),
    });

    horizontal * depth
}

#[aoc(day2, part2)]
pub fn part2(input: &[Line]) -> i32 {
    let mut horizontal = 0;
    let mut depth = 0;
    let mut aim = 0;
    input.iter().for_each(|Line(d, v)| match d.as_str() {
        "forward" => {
            horizontal += v;
            depth += aim * v
        }
        "down" => aim += v,
        "up" => aim -= v,
        _ => panic!("WHY?!"),
    });

    horizontal * depth
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    pub fn part1_test() {
        let result = part1(&input_generator(
            "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2\n",
        ));

        assert_eq!(result, 150);
    }

    #[test]
    pub fn part2_test() {
        let result = part2(&input_generator(
            "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2\n",
        ));

        assert_eq!(result, 900);
    }
}
