#[aoc_generator(day6)]
pub fn input_generator(input: &str) -> Vec<u64> {
    let numbers = input.split(',').map(|c| c.parse::<usize>().unwrap());
    let mut data = vec![0; 9];
    numbers.for_each(|n| data[n] += 1);
    data
}

#[aoc(day6, part1)]
pub fn part1(input: &[u64]) -> u64 {
    calculate(input, 80)
}

#[aoc(day6, part2)]
pub fn part2(input: &[u64]) -> u64 {
    calculate(input, 256)
}

pub fn calculate(input: &[u64], days: u64) -> u64 {
    let mut data = input.to_owned();
    for _ in 0..days {
        let tmp = data[0];
        for i in 0..8 {
            data[i] = data[i + 1];
        }
        data[6] += tmp;
        data[8] = tmp;
    }
    data.iter().sum()
}

#[cfg(test)]
mod tests {
    use super::*;
    const INPUT: &str = "3,4,3,1,2";

    #[test]
    pub fn part1_test() {
        let input = input_generator(INPUT);
        let result = calculate(&input, 18);
        assert_eq!(result, 26);

        let result = calculate(&input, 80);
        assert_eq!(result, 5934);

        let result = calculate(&input, 256);
        assert_eq!(result, 26984457539);
    }

    #[test]
    pub fn part2_test() {
        let input = input_generator(INPUT);
        let result = calculate(&input, 256);
        assert_eq!(result, 26984457539);
    }
}
