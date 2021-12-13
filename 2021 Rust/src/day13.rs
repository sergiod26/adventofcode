#[aoc_generator(day13)]
pub fn input_generator(input: &str) -> Vec<Vec<usize>> {
    input
        .lines()
        .map(|l| l.split(',').map(|x| x.parse::<usize>().unwrap()).collect())
        .collect()
}

#[aoc(day13, part1)]
pub fn part1(input: &[Vec<usize>]) -> usize {
    let fold = 655;
    let result = fold_x(input, fold);
    result.len()
}
#[aoc(day13, part2)]
pub fn part2(input: &[Vec<usize>]) -> usize {
    let result = fold_x(input, 655);
    let result = fold_y(&result, 447);
    let result = fold_x(&result, 327);
    let result = fold_y(&result, 223);
    let result = fold_x(&result, 163);
    let result = fold_y(&result, 111);
    let result = fold_x(&result, 81);
    let result = fold_y(&result, 55);
    let result = fold_x(&result, 40);
    let result = fold_y(&result, 27);
    let result = fold_y(&result, 13);
    let result = fold_y(&result, 6);

    //println!("{:?}", result);

    let mut matrix = vec![vec!['.'; 50]; 50];

    result.iter().for_each(|x| matrix[x[1]][x[0]] = '#');

    for row in matrix {
        for cell in row {
            print!("{}", cell);
        }
        println!("");
    }

    0
}
fn fold_x(input: &[Vec<usize>], fold: usize) -> Vec<Vec<usize>> {
    let mut result: Vec<Vec<usize>> = input
        .iter()
        .filter(|x| x[0] != fold)
        .map(|x| {
            if x[0] > fold {
                vec![(fold - (x[0] % fold)) % fold, x[1]]
            } else {
                vec![x[0], x[1]]
            }
        })
        .collect();
    result.sort_unstable();
    result.dedup();
    result
}

fn fold_y(input: &[Vec<usize>], fold: usize) -> Vec<Vec<usize>> {
    let mut result: Vec<Vec<usize>> = input
        .iter()
        .filter(|x| x[1] != fold)
        .map(|x| {
            if x[1] > fold {
                vec![x[0], (fold - (x[1] % fold)) % fold]
            } else {
                vec![x[0], x[1]]
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
9,0";
    #[test]
    pub fn part1_test() {
        let result = part1(&input_generator(INPUT));
        assert_eq!(result, 17);
    }

    #[test]
    pub fn part2_test() {
        let result = part2(&input_generator(INPUT));
        assert_eq!(result, 17);
    }
}
