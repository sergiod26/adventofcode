use std::collections::HashMap;

pub struct DS {
    pub matrix: Vec<Vec<usize>>,
    pub visited: Vec<usize>,
    pub node_count: usize,
}

#[aoc_generator(day12)]
pub fn input_generator(input: &str) -> DS {
    let data: Vec<Vec<&str>> = input.lines().map(|l| l.split('-').collect()).collect();
    let mut tmp: Vec<&str> = data.clone().into_iter().flatten().collect();
    tmp.sort_unstable();
    tmp.dedup();
    let node_count = tmp.len();

    let mut nodes = HashMap::<&str, (usize, usize)>::new();
    nodes.entry("start").or_insert((0, 0));
    nodes.entry("end").or_insert((node_count - 1, 1));

    let mut pos = 1;
    tmp.iter().for_each(|x| {
        if x != &"start" && x != &"end" {
            let c = if x.chars().next().unwrap().is_uppercase() {
                std::usize::MAX
            } else {
                1
            };

            nodes.entry(x).or_insert((pos, c));
            pos += 1;
        }
    });

    let mut matrix: Vec<Vec<usize>> = vec![vec![0; node_count]; node_count];
    let mut visited = vec![0; node_count];

    nodes
        .iter()
        .for_each(|(_, (pos, weight))| visited[*pos] = *weight);

    data.iter().for_each(|l| {
        matrix[nodes[l[0]].0][nodes[l[1]].0] = 1;
        matrix[nodes[l[1]].0][nodes[l[0]].0] = 1
    });

    DS {
        matrix,
        visited,
        node_count,
    }
}

#[aoc(day12, part1)]
pub fn part1(input: &DS) -> usize {
    let matrix = input.matrix.clone();
    let visited = input.visited.clone();

    let mut result = vec![];

    matrix[0].iter().enumerate().for_each(|(x, val)| {
        if val == &1 {
            find_path(
                x,
                &matrix,
                visited.to_owned(),
                input.node_count - 1,
                &mut vec![0],
                &mut result,
            );
        }
    });

    result.len()
}

#[aoc(day12, part2)]
pub fn part2(input: &DS) -> usize {
    let matrix = input.matrix.clone();
    let visited = input.visited.clone();

    let mut result = vec![];

    visited.iter().enumerate().for_each(|(x, val)| {
        if val == &1 && x != input.node_count - 1 {
            let mut visited = visited.clone();
            visited[x] = 2;

            matrix[0].iter().enumerate().for_each(|(x, val)| {
                if val == &1 {
                    find_path(
                        x,
                        &matrix,
                        visited.to_owned(),
                        input.node_count - 1,
                        &mut vec![0],
                        &mut result,
                    );
                }
            });
        }
    });

    result.sort_unstable();
    result.dedup();
    result.len()
}

fn find_path(
    current: usize,
    matrix: &[Vec<usize>],
    visited: Vec<usize>,
    last: usize,
    path: &mut Vec<usize>,
    result: &mut Vec<String>,
) {
    if current == last {
        result.push(format!(
            "{}-{}",
            path.to_owned()
                .iter()
                .map(|&d| d.to_string())
                .collect::<Vec<String>>()
                .join("-"),
            last
        ));
        return;
    }
    if visited[current] > 0 {
        let mut path = path.clone();
        path.push(current);
        let mut visited = visited;
        visited[current] -= 1;

        matrix[current].iter().enumerate().for_each(|(x, val)| {
            if val == &1 {
                find_path(x, matrix, visited.to_owned(), last, &mut path, result);
            }
        });
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT1: &str = "start-A
start-b
A-c
A-b
b-d
A-end
b-end";

    const INPUT2: &str = "dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc";

    const INPUT3: &str = "fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW";

    #[test]
    pub fn part1_test1() {
        let result = part1(&input_generator(INPUT1));
        assert_eq!(result, 10);
    }

    #[test]
    pub fn part1_test2() {
        let result = part1(&input_generator(INPUT2));
        assert_eq!(result, 19);
    }

    #[test]
    pub fn part1_test3() {
        let result = part1(&input_generator(INPUT3));
        assert_eq!(result, 226);
    }

    #[test]
    pub fn part2_test1() {
        let result = part2(&input_generator(INPUT1));
        assert_eq!(result, 36);
    }

    #[test]
    pub fn part2_test2() {
        let result = part2(&input_generator(INPUT2));
        assert_eq!(result, 103);
    }

    #[test]
    pub fn part2_test3() {
        let result = part2(&input_generator(INPUT3));
        assert_eq!(result, 3509);
    }
}
