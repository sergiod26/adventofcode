#[aoc_generator(day17)]
pub fn input_generator(input: &str) -> ((i32, i32), (i32, i32)) {
    let vec: Vec<i32> = input
        .trim()
        .replace("target area: x=", "")
        .replace(" y=", "")
        .split(',')
        .flat_map(|e| e.split(".."))
        .map(|n| n.parse::<i32>().unwrap())
        .collect();

    ((vec[0], vec[1]), (vec[2], vec[3]))
}

#[aoc(day17, part1)]
pub fn part1(input: &((i32, i32), (i32, i32))) -> i32 {
    let &(target_x, target_y) = input;
    brute_force(target_x, target_y).into_iter().max().unwrap()
}

#[aoc(day17, part2)]
pub fn part2(input: &((i32, i32), (i32, i32))) -> usize {
    let &(target_x, target_y) = input;
    brute_force(target_x, target_y).len()
}

fn brute_force(target_x: (i32, i32), target_y: (i32, i32)) -> Vec<i32> {
    let mut result = vec![];
    for x in 0..=target_x.1 {
        for y in target_y.0..500 {
            //why 500 you ask? just because :)
            let tmp = path((x, y), target_x, target_y);
            if tmp != i32::MIN {
                result.push(tmp);
            }
        }
    }
    result
}

fn path(velocity: (i32, i32), target_x: (i32, i32), target_y: (i32, i32)) -> i32 {
    let mut velocity = velocity;
    let mut current = (0, 0);
    let mut acc = vec![];

    while !(current.0 >= target_x.0
        && current.0 <= target_x.1
        && current.1 >= target_y.0
        && current.1 <= target_y.1)
    {
        current.0 += velocity.0;
        current.1 += velocity.1;
        acc.push(current);

        if velocity.0 < 0 {
            velocity.0 += 1
        } else if velocity.0 > 0 {
            velocity.0 -= 1
        };
        velocity.1 -= 1;

        if current.0 > target_x.1 || current.1 < target_y.0 {
            return i32::MIN;
        }
    }
    acc.into_iter().map(|(_, y)| y).max().unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "target area: x=20..30, y=-10..-5";
    #[test]
    pub fn part1_test() {
        let result = part1(&input_generator(INPUT));
        assert_eq!(result, 45);
    }

    #[test]
    pub fn part2_test() {
        let result = part2(&input_generator(INPUT));
        assert_eq!(result, 112);
    }
}
