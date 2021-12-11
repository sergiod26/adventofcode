#[aoc_generator(day11)]
pub fn input_generator(input: &str) -> Vec<Vec<u32>> {
    input
        .lines()
        .map(|l| l.chars().map(|x| x.to_digit(10).unwrap()).collect())
        .collect()
}

#[aoc(day11, part1)]
pub fn part1(input: &[Vec<u32>]) -> u32 {
    let mut data = input.to_owned();
    let mut result = 0;
    for _i in 0..100 {
        result += step(&mut data);
    }
    result
}

#[aoc(day11, part2)]
pub fn part2(input: &[Vec<u32>]) -> u32 {
    let mut data = input.to_owned();
    for i in 1.. {
        if step(&mut data) == 100 {
            return i;
        }
    }
    0
}

pub fn step(data: &mut [Vec<u32>]) -> u32 {
    let len = data.len();
    let mut flashes = vec![vec![false; len]; len];
    let mut flash_count = 0;

    for i in 0..len {
        for j in 0..len {
            data[i][j] += 1;
            if data[i][j] > 9 && !flashes[i][j] {
                flashes[i][j] = true;
                flash_count += 1 + flash(data, &mut flashes, i as isize, j as isize, len as isize);
            }
        }
    }
    for i in 0..len {
        for j in 0..len {
            if data[i][j] > 9 {
                data[i][j] = 0;
            }
        }
    }

    flash_count
}

fn flash(data: &mut [Vec<u32>], flashes: &mut [Vec<bool>], i: isize, j: isize, len: isize) -> u32 {
    let mut flash_count = 0;
    for i_it in -1..=1 {
        for j_it in -1..=1 {
            if i_it == j_it && i_it == 0 {
                continue;
            }

            if i + i_it >= 0 && j + j_it >= 0 && i + i_it < len && j + j_it < len {
                let new_i = (i + i_it) as usize;
                let new_j = (j + j_it) as usize;

                data[new_i][new_j] += 1;
                if data[new_i][new_j] > 9 && !flashes[new_i][new_j] {
                    flashes[new_i][new_j] = true;
                    flash_count += 1 + flash(data, flashes, new_i as isize, new_j as isize, len);
                }
            }
        }
    }
    flash_count
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526";

    #[test]
    pub fn part1_test() {
        let result = part1(&input_generator(INPUT));
        assert_eq!(result, 1656);
    }
}
