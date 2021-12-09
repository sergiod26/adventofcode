#[aoc(day9, part1)]
pub fn part1(input: &str) -> u32 {
    let data: Vec<Vec<u32>> = input
        .lines()
        .map(|l| l.chars().map(|c| c.to_digit(10).unwrap()).collect())
        .collect();

    let col_len = data[0].len();
    let row_len = data.len();
    let mut result = 0;
    for i in 0..row_len {
        for j in 0..col_len {
            if (i as i32 - 1 < 0 || data[i - 1][j] > data[i][j])
                && (j as i32 - 1 < 0 || data[i][j - 1] > data[i][j])
                && (i + 1 >= row_len || data[i + 1][j] > data[i][j])
                && (j + 1 >= col_len || data[i][j + 1] > data[i][j])
            {
                result += data[i][j] + 1;
            }
        }
    }
    result
}

#[aoc(day9, part2)]
pub fn part2(input: &str) -> usize {
    let mut data: Vec<Vec<char>> = input.lines().map(|l| l.chars().collect()).collect();

    let col_len = data[0].len();
    let row_len = data.len();

    let mut result = vec![];
    for i in 0..row_len {
        for j in 0..col_len {
            if data[i][j] != '9' {
                result.push(weight(&mut data, i, j, row_len, col_len));
            }
        }
    }

    result.sort_by(|a, b| b.cmp(a));
    result[0] * result[1] * result[2]
}

fn weight(data: &mut Vec<Vec<char>>, i: usize, j: usize, row_len: usize, col_len: usize) -> usize {
    let mut sum = 1;
    if data[i][j] != '9' {
        data[i][j] = '9';
        if i + 1 < row_len && data[i + 1][j] != '9' {
            sum += weight(data, i + 1, j, row_len, col_len);
        }
        if j + 1 < col_len && data[i][j + 1] != '9' {
            sum += weight(data, i, j + 1, row_len, col_len);
        }
        if j as i32 - 1 >= 0 && data[i][j - 1] != '9' {
            sum += weight(data, i, j - 1, row_len, col_len);
        }

        if i as i32 - 1 >= 0 && data[i - 1][j] != '9' {
            sum += weight(data, i - 1, j, row_len, col_len);
        }
    }
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
        let result = part1(INPUT);
        assert_eq!(result, 15);
    }

    #[test]
    pub fn part2_test() {
        let result = part2(INPUT);
        assert_eq!(result, 1134);
    }
}
