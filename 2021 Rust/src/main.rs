use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    part1();
    part2();
}

fn part1() {
    let lines = read_numbers("input/input1.txt");

    let mut prev = i32::MAX;
    let mut count: i32 = 0;

    lines.for_each(|num| {
        if num > prev {
            count += 1;
        }
        prev = num;
    });

    println!("part1: {}", count);
}

fn part2() {
    let mut prev = i32::MAX;
    let mut count: i32 = 0;

    let lines: Vec<i32> = read_numbers("input/input1.txt").collect();
    let lines: Vec<i32> = lines.windows(3).map(|x| x.iter().sum()).collect();

    lines.iter().for_each(|&num| {
        if num > prev {
            count += 1;
        }
        prev = num;
    });

    println!("part2: {}", count);
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

fn read_numbers<P>(filename: P) -> impl Iterator<Item = i32>
where
    P: AsRef<Path>,
{
    read_lines(filename)
        .unwrap()
        .map(|e| e.unwrap().parse::<i32>().unwrap())
}
