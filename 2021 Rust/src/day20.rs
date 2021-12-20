#[derive(Debug)]
pub struct Data {
    alg: Vec<usize>,
    image: Vec<Vec<usize>>,
}

#[aoc_generator(day20)]
pub fn input_generator(input: &str) -> Data {
    let mut input = input.lines();
    let alg = input
        .next()
        .unwrap()
        .chars()
        .map(|c| if c == '#' { 1 } else { 0 })
        .collect();
    input.next();

    let image = input
        .map(|l| l.chars().map(|c| if c == '#' { 1 } else { 0 }).collect())
        .collect();

    Data { alg, image }
}

#[aoc(day20, part1)]
pub fn part1(input: &Data) -> usize {
    calculate(input, 2)
}

#[aoc(day20, part2)]
pub fn part2(input: &Data) -> usize {
    calculate(input, 50)
}

const PAD: usize = 2;

fn calculate(input: &Data, times: usize) -> usize {
    let mut original = input.image.clone();
    let mut all_off = true;
    let mut fill = 0;
    for _ in 0..times {
        let rows = original.len() as isize + PAD as isize;
        let cols = original[0].len() as isize + PAD as isize;

        let mut tmp = vec![vec![fill; cols as usize]; rows as usize];
        for i in 0..rows as usize - PAD {
            for j in 0..cols as usize - PAD {
                tmp[i + PAD / 2][j + PAD / 2] = original[i][j];
            }
        }
        original = tmp.clone();
        let mut matrix = original.clone();

        for i in 0..rows {
            for j in 0..cols {
                let mut square = vec![];
                for i_x in -1isize..=1 {
                    for j_y in -1isize..=1 {
                        if i as isize + i_x < 0
                            || j as isize + j_y < 0
                            || i as isize + i_x >= rows
                            || j as isize + j_y >= cols
                        {
                            square.push(fill);
                        } else {
                            square.push(original[(i + i_x) as usize][(j + j_y) as usize])
                        }
                    }
                }
                matrix[i as usize][j as usize] = input.alg[to_usize(&square)];
            }
        }
        let tmp = if all_off {
            *input.alg.first().unwrap()
        } else {
            *input.alg.last().unwrap()
        };
        if fill != tmp {
            all_off = !all_off;
            fill = tmp;
        }
        original = matrix.clone();
    }

    original.into_iter().flatten().sum()
}

fn to_usize(slice: &[usize]) -> usize {
    slice.iter().fold(0, |acc, &b| acc * 2 + b as usize)
}

fn _display(matrix: &[Vec<usize>]) {
    let x = matrix.iter().map(|r| {
        r.iter()
            .map(|&c| if c == 0 { "." } else { "#" })
            .collect::<Vec<&str>>()
            .join("")
    });

    for r in x {
        println!("{}", r);
    }
    println!();
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###";

    #[test]
    pub fn part1_test() {
        let result = part1(&input_generator(INPUT));
        assert_eq!(result, 35);
    }

    #[test]
    pub fn part2_test() {
        let result = part2(&input_generator(INPUT));
        assert_eq!(result, 3351);
    }
}
