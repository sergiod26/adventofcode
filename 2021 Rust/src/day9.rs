#[aoc_generator(day9)]
pub fn input_generator(input: &str) -> Vec<Vec<u32>> {
    input
        .lines()
        .map(|l| l.chars().map(|c| c.to_digit(10).unwrap()).collect())
        .collect()
}

#[aoc(day9, part1)]
pub fn part1(input: &[Vec<u32>]) -> usize {
    low_points(input)
        .into_iter()
        .map(|(i, j)| input[i][j] as usize + 1)
        .sum()
}

#[aoc(day9, part2)]
pub fn part2(data: &[Vec<u32>]) -> usize {
    let mut data = data.to_owned();

    let col_len = data[0].len() as i32;
    let row_len = data.len() as i32;

    let mut result = vec![];
    for i in 0..row_len {
        for j in 0..col_len {
            if data[i as usize][j as usize] != 9 {
                result.push(weight(&mut data, i, j, row_len, col_len));
            }
        }
    }

    result.sort_by(|a, b| b.cmp(a));
    result[0] * result[1] * result[2]
}

#[aoc(day9, part2, low_points)] //Smarter? but slower!
pub fn part2_low_points(data: &[Vec<u32>]) -> usize {
    let mut data = data.to_owned();
    let col_len = data[0].len() as i32;
    let row_len = data.len() as i32;

    let mut result: Vec<usize> = low_points(&data)
        .into_iter()
        .map(|(i, j)| weight(&mut data, i as i32, j as i32, row_len, col_len))
        .collect();

    result.sort_by(|a, b| b.cmp(a));
    result[0] * result[1] * result[2]
}

fn low_points(data: &[Vec<u32>]) -> Vec<(usize, usize)> {
    let col_len = data[0].len();
    let row_len = data.len();
    let mut result = vec![];
    for i in 0..row_len {
        for j in 0..col_len {
            if (i as i32 - 1 < 0 || data[i - 1][j] > data[i][j])
                && (j as i32 - 1 < 0 || data[i][j - 1] > data[i][j])
                && (i + 1 >= row_len || data[i + 1][j] > data[i][j])
                && (j + 1 >= col_len || data[i][j + 1] > data[i][j])
            {
                result.push((i, j));
            }
        }
    }
    result
}

fn weight(data: &mut Vec<Vec<u32>>, i: i32, j: i32, row_len: i32, col_len: i32) -> usize {
    let mut sum = 1;
    if i >= row_len || j >= col_len || j < 0 || i < 0 || data[i as usize][j as usize] == 9 {
        return 0;
    }

    data[i as usize][j as usize] = 9;

    sum += weight(data, i + 1, j, row_len, col_len)
        + weight(data, i, j + 1, row_len, col_len)
        + weight(data, i, j - 1, row_len, col_len)
        + weight(data, i - 1, j, row_len, col_len);
    sum
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "2199943210
3987894921
9856789892
8767896789
9899965678";

    #[test]
    pub fn part1_test() {
        let result = part1(&input_generator(INPUT));
        assert_eq!(result, 15);
    }

    #[test]
    pub fn part2_test() {
        let result = part2(&input_generator(INPUT));
        assert_eq!(result, 1134);
    }
}
