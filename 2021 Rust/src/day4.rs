#[derive(Default, Clone, Debug)]
pub struct RowCol {
    row: usize,
    col: usize,
}

#[aoc(day4, part1)]
pub fn part1(input: &str) -> i32 {
    let mut data = input.lines().peekable();
    let numbers: Vec<&str> = data.next().unwrap().split(',').collect();
    let mut boards: Vec<Vec<Vec<&str>>> = vec![];
    let mut boards_checks: Vec<Vec<Vec<bool>>> = vec![];
    data.next();
    while data.peek().is_some() {
        let mut board: Vec<Vec<&str>> = vec![];
        let mut board_check: Vec<Vec<bool>> = vec![];
        for line in &mut data {
            if line.is_empty() {
                break;
            }
            let row: Vec<&str> = line.split(' ').filter(|&x| !x.is_empty()).collect();
            board.push(row.clone());
            board_check.push(vec![false; row.len()]);
        }
        boards.push(board);
        boards_checks.push(board_check);
    }

    let cols = boards[0][0].len();
    let rows = boards[0].len();
    let boards_count = boards.len();

    let mut boards_sums: Vec<Vec<RowCol>> = vec![vec![Default::default(); rows]; boards_count];

    for n in numbers {
        for b in 0..boards_count {
            for r in 0..rows {
                for c in 0..cols {
                    if boards[b][r][c] == n {
                        boards_checks[b][r][c] = true;
                        boards_sums[b][r].row += 1;
                        boards_sums[b][c].col += 1;

                        if boards_sums[b][r].row == rows || boards_sums[b][c].col == cols {
                            let mut result = 0;
                            for i in 0..rows {
                                for j in 0..cols {
                                    if !boards_checks[b][i][j] {
                                        result += boards[b][i][j].parse::<i32>().unwrap();
                                    }
                                }
                            }

                            return result * n.parse::<i32>().unwrap();
                        }
                    }
                }
            }
        }
    }
    panic!("oops")
}

#[aoc(day4, part2)]
pub fn part2(input: &str) -> i32 {
    let mut data = input.lines().peekable();
    let numbers: Vec<&str> = data.next().unwrap().split(',').collect();
    let mut boards: Vec<Vec<Vec<&str>>> = vec![];
    let mut boards_checks: Vec<Vec<Vec<bool>>> = vec![];
    data.next();
    while data.peek().is_some() {
        let mut board: Vec<Vec<&str>> = vec![];
        let mut board_check: Vec<Vec<bool>> = vec![];
        for line in &mut data {
            if line.is_empty() {
                break;
            }
            let row: Vec<&str> = line.split(' ').filter(|&x| !x.is_empty()).collect();
            board.push(row.clone());
            board_check.push(vec![false; row.len()]);
        }
        boards.push(board);
        boards_checks.push(board_check);
    }

    let cols = boards[0][0].len();
    let rows = boards[0].len();
    let boards_count = boards.len();

    let mut boards_won_counter = 0;
    let mut boards_won: Vec<bool> = vec![false; boards_count];

    let mut boards_sums: Vec<Vec<RowCol>> = vec![vec![Default::default(); rows]; boards_count];

    for n in numbers {
        'outer: for b in 0..boards_count {
            if !boards_won[b] {
                for r in 0..rows {
                    for c in 0..cols {
                        if boards[b][r][c] == n {
                            boards_checks[b][r][c] = true;
                            boards_sums[b][r].row += 1;
                            boards_sums[b][c].col += 1;

                            if (boards_sums[b][r].row == rows || boards_sums[b][c].col == cols) && !boards_won[b] {
                                boards_won[b] = true;
                                boards_won_counter += 1;
                                if boards_won_counter == boards_count {
                                    let mut result = 0;
                                    for i in 0..rows {
                                        for j in 0..cols {
                                            if !boards_checks[b][i][j] {
                                                result +=
                                                    boards[b][i][j].parse::<i32>().unwrap();
                                            }
                                        }
                                    }

                                    return result * n.parse::<i32>().unwrap();
                                }
                                continue 'outer;
                            }
                        }
                    }
                }
            }
        }
    }
    panic!("oops")
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = r#"7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7"#;

    #[test]
    pub fn part1_test() {
        let result = part1(INPUT);
        assert_eq!(result, 4512);
    }

    #[test]
    pub fn part2_test() {
        let result = part2(INPUT);
        assert_eq!(result, 1924);
    }
}
