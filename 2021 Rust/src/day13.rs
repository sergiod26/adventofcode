pub struct Data {
    points: Vec<(usize, usize)>,
    folds: Vec<(String, usize)>,
}

#[aoc_generator(day13)]
pub fn input_generator(input: &str) -> Data {
    let mut input = input.lines();
    let mut points: Vec<(usize, usize)> = vec![];

    for line in &mut input {
        if line.is_empty() {
            break;
        }
        let point: Vec<usize> = line
            .split(',')
            .map(|x| x.parse::<usize>().unwrap())
            .collect();
        points.push((point[0], point[1]));
    }

    let mut folds = vec![];
    for line in input {
        folds.push(line);
    }

    let folds = folds
        .iter()
        .map(|e| {
            let tmp: Vec<&str> = e.split('=').collect();
            (
                tmp[0].to_owned().replace("fold along ", ""),
                tmp[1].parse::<usize>().unwrap(),
            )
        })
        .collect();

    Data { points, folds }
}

#[aoc(day13, part1)]
pub fn part1(input: &Data) -> usize {
    let result = fold(input.points.clone(), input.folds[0].clone());
    result.len()
}

#[aoc(day13, part2)]
pub fn part2(input: &Data) -> usize {
    let mut result = input.points.clone();
    input
        .folds
        .iter()
        .for_each(|f| result = fold(result.clone(), f.clone()));

    display(result.clone());

    result.len()
}

fn display(points: Vec<(usize, usize)>) {
    let rows = points.iter().map(|(x, _)| x).max().unwrap() + 1;
    let cols = points.iter().map(|(_, y)| y).max().unwrap() + 1;
    let mut matrix = vec![vec![' '; rows]; cols];
    points.iter().for_each(|x| matrix[x.1][x.0] = '#');
    for row in matrix {
        for cell in row {
            print!("{}", cell);
        }
        println!();
    }
}

fn fold(points: Vec<(usize, usize)>, (dir, point): (String, usize)) -> Vec<(usize, usize)> {
    match dir.as_str() {
        "x" => fold_x(points, point),
        _ => fold_y(points, point),
    }
}

fn fold_x(input: Vec<(usize, usize)>, fold: usize) -> Vec<(usize, usize)> {
    let mut result: Vec<(usize, usize)> = input
        .iter()
        .filter(|x| x.0 != fold)
        .map(|x| {
            if x.0 > fold {
                (fold - (x.0 - fold), x.1)
            } else {
                (x.0, x.1)
            }
        })
        .collect();
    result.sort_unstable();
    result.dedup();
    result
}

fn fold_y(input: Vec<(usize, usize)>, fold: usize) -> Vec<(usize, usize)> {
    let mut result: Vec<(usize, usize)> = input
        .iter()
        .filter(|x| x.1 != fold)
        .map(|x| {
            if x.1 > fold {
                (x.0, fold - (x.1 - fold))
            } else {
                (x.0, x.1)
            }
        })
        .collect();
    result.sort_unstable();
    result.dedup();
    result
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5";

    #[test]
    pub fn part1_test() {
        let result = part1(&input_generator(INPUT));
        assert_eq!(result, 17);
    }

    #[test]
    pub fn part2_test() {
        let result = part2(&input_generator(INPUT));
        assert_eq!(result, 16);
    }
}
