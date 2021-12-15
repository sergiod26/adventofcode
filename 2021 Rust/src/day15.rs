use pathfinding::prelude::dijkstra;

#[derive(Clone, Debug, Eq, Hash, Ord, PartialEq, PartialOrd)]
struct Pos(usize, usize);

impl Pos {
    fn successors(&self, matrix: &[Vec<usize>]) -> Vec<(Pos, usize)> {
        let &Pos(x, y) = self;
        let mut vec = vec![];

        if x + 1 < matrix.len() {
            vec.push((Pos(x + 1, y), matrix[x + 1][y]));
        }
        if x as isize - 1 >= 0 {
            vec.push((Pos(x - 1, y), matrix[x - 1][y]));
        }

        if y + 1 < matrix.len() {
            vec.push((Pos(x, y + 1), matrix[x][y + 1]));
        }
        if y as isize - 1 >= 0 {
            vec.push((Pos(x, y - 1), matrix[x][y - 1]));
        }

        vec
    }
}

#[aoc_generator(day15)]
pub fn input_generator(input: &str) -> Vec<Vec<usize>> {
    input
        .lines()
        .map(|l| {
            l.chars()
                .map(|x| x.to_digit(10).unwrap() as usize)
                .collect()
        })
        .collect()
}

#[aoc(day15, part1)]
pub fn part1(input: &[Vec<usize>]) -> usize {
    let len = input.len() - 1;
    let goal: Pos = Pos(len, len);
    let result = dijkstra(&Pos(0, 0), |p| p.successors(input), |p| *p == goal);
    result.expect("no path found").1
}

#[aoc(day15, part2)]
pub fn part2(input: &[Vec<usize>]) -> usize {
    let len = input.len();
    let mut vec = vec![vec![0; len * 5]; len * 5];
    for i in 0..len {
        for j in 0..len {
            vec[i][j] = input[i][j];
        }
    }

    for m in 1..5 {
        for i in 0..len {
            for j in 0..len {
                vec[(len * m) + i][j] = ((vec[(len * (m - 1)) + i][j]) % 9) + 1;
            }
        }
    }

    for m in 1..5 {
        for i in 0..len * 5 {
            for j in 0..len {
                vec[i][(len * m) + j] = ((vec[i][(len * (m - 1)) + j]) % 9) + 1;
            }
        }
    }

    let len = vec.len() - 1;
    let goal: Pos = Pos(len, len);
    let result = dijkstra(&Pos(0, 0), |p| p.successors(&vec), |p| *p == goal);
    result.expect("no path found").1
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581";

    #[test]
    pub fn part1_test() {
        let result = part1(&input_generator(INPUT));
        assert_eq!(result, 40);
    }

    #[test]
    pub fn part2_test() {
        let result = part2(&input_generator(INPUT));
        assert_eq!(result, 315);
    }
}
