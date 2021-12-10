//Brute force all the way!

#[aoc_generator(day7)]
pub fn input_generator(input: &str) -> Vec<i32> {
    input
        .split(',')
        .map(|c| c.parse::<i32>().unwrap())
        .collect()
}

#[aoc(day7, part1)]
pub fn part1(input: &[i32]) -> i32 {
    let mut min = std::i32::MAX;
    let smallest = *input.iter().min().unwrap();
    let biggest = *input.iter().max().unwrap();
    for i in smallest..=biggest {
        let tmp = input.iter().map(|n| (n - i).abs()).sum();
        if tmp < min {
            min = tmp;
        }
    }
    min
}

#[aoc(day7, part2)]
pub fn part2(input: &[i32]) -> i32 {
    let mut min = std::i32::MAX;
    let smallest = *input.iter().min().unwrap();
    let biggest = *input.iter().max().unwrap();
    for i in smallest..=biggest {
        let tmp = input
            .iter()
            .map(|n| {
                let tmp = (n - i).abs();
                (tmp * (tmp + 1)) / 2
            })
            .sum::<i32>();

        if tmp < min {
            min = tmp;
        }
    }
    min
}

#[cfg(test)]
mod tests {
    use super::*;
    const INPUT: &str = "16,1,2,0,4,2,7,1,2,14";

    #[test]
    pub fn part1_test() {
        let input = input_generator(INPUT);
        let result = part1(&input);
        assert_eq!(result, 37);
    }

    #[test]
    pub fn part2_test() {
        let input = input_generator(INPUT);
        let result = part2(&input);
        assert_eq!(result, 168);
    }
}
