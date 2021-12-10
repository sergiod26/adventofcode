use std::collections::HashMap;

#[derive(Debug, Eq, PartialEq, Hash)]
pub struct Coord {
    x: u32,
    y: u32,
}

#[aoc_generator(day5)]
pub fn input_generator(input: &str) -> Vec<Coord> {
    input
        .lines()
        .flat_map(|l| {
            l.split(" -> ").into_iter().map(|s| {
                let pair: Vec<u32> = s
                    .split(',')
                    .into_iter()
                    .map(|c| c.parse::<u32>().unwrap())
                    .collect();
                Coord {
                    x: pair[0],
                    y: pair[1],
                }
            })
        })
        .collect()
}

#[aoc(day5, part1)]
pub fn part1(input: &[Coord]) -> usize {
    let mut data = HashMap::<Coord, u32>::new();
    let pairs = input.chunks(2);
    for pair in pairs {
        if pair[0].x == pair[1].x {
            let range = get_range(pair[0].y, pair[1].y);
            range.for_each(|i| *data.entry(Coord { x: pair[0].x, y: i }).or_insert(0) += 1);
        } else if pair[0].y == pair[1].y {
            let range = get_range(pair[0].x, pair[1].x);
            range.for_each(|i| *data.entry(Coord { x: i, y: pair[0].y }).or_insert(0) += 1);
        }
    }

    data.iter().filter(|(_, &c)| c > 1).count()
}

#[aoc(day5, part2)]
pub fn part2(input: &[Coord]) -> usize {
    let mut data = HashMap::<Coord, u32>::new();
    let pairs = input.chunks(2);
    for pair in pairs {
        if pair[0].x == pair[1].x {
            let range = get_range(pair[0].y, pair[1].y);
            range.for_each(|i| *data.entry(Coord { x: pair[0].x, y: i }).or_insert(0) += 1);
        } else if pair[0].y == pair[1].y {
            let range = get_range(pair[0].x, pair[1].x);
            range.for_each(|i| *data.entry(Coord { x: i, y: pair[0].y }).or_insert(0) += 1);
        } else if pair[0].x < pair[1].x {
            if pair[0].y < pair[1].y {
                (pair[0].x..=pair[1].x)
                    .zip(pair[0].y..=pair[1].y)
                    .for_each(|(x, y)| *data.entry(Coord { x, y }).or_insert(0) += 1);
            } else {
                (pair[0].x..=pair[1].x)
                    .zip((pair[1].y..=pair[0].y).rev())
                    .for_each(|(x, y)| *data.entry(Coord { x, y }).or_insert(0) += 1);
            }
        } else if pair[0].y < pair[1].y {
            (pair[1].x..=pair[0].x)
                .rev()
                .zip(pair[0].y..=pair[1].y)
                .for_each(|(x, y)| *data.entry(Coord { x, y }).or_insert(0) += 1);
        } else {
            (pair[1].x..=pair[0].x)
                .rev()
                .zip((pair[1].y..=pair[0].y).rev())
                .for_each(|(x, y)| *data.entry(Coord { x, y }).or_insert(0) += 1);
        }
    }

    data.iter().filter(|(_, &c)| c > 1).count()
}

fn get_range(x: u32, y: u32) -> std::ops::RangeInclusive<u32> {
    if x < y {
        x..=y
    } else {
        y..=x
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = r#"0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"#;

    #[test]
    pub fn part1_test() {
        let input = input_generator(INPUT);
        let result = part1(&input);
        assert_eq!(result, 5);
    }

    #[test]
    pub fn part2_test() {
        let input = input_generator(INPUT);
        let result = part2(&input);
        assert_eq!(result, 12);
    }
}
