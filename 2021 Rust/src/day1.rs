#[aoc_generator(day1)]
pub fn input_generator(input: &str) -> Vec<i32> {
    input
        .lines()
        .map(|line| line.parse::<i32>().unwrap())
        .collect()
}

#[aoc(day1, part1)]
pub fn part1(input: &[i32]) -> i32 {
    let mut prev = i32::MAX;
    let mut count: i32 = 0;

    input.iter().for_each(|&num| {
        if num > prev {
            count += 1;
        }
        prev = num;
    });

    count
}

#[aoc(day1, part2)]
pub fn part2(input: &[i32]) -> i32 {
    let mut prev = i32::MAX;
    let mut count: i32 = 0;

    let input: Vec<i32> = input.windows(3).map(|x| x.iter().sum()).collect();

    input.iter().for_each(|&num| {
        if num > prev {
            count += 1;
        }
        prev = num;
    });

    count
}
