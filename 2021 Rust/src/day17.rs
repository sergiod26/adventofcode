// #[aoc_generator(day17)]
// pub fn input_generator(input: &str) -> Vec<i32> {
//     todo!();
// }

#[aoc(day17, part1)]
pub fn part1(_input: &str) -> i32 {
    let target_x = (230, 283);
    let target_y = (-107, -57);
    brute_force(target_x, target_y).into_iter().max().unwrap()
}

#[aoc(day17, part2)]
pub fn part2(_input: &str) -> usize {
    let target_x = (230, 283);
    let target_y = (-107, -57);
    brute_force(target_x, target_y).len()
}

fn brute_force(target_x: (i32, i32), target_y: (i32, i32)) -> Vec<i32> {
    let mut result = vec![];
    for x in 0..=target_x.1 {
        for y in target_y.0..500 {
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

    const INPUT: &str = "3,4,3,1,2";
    #[test]
    pub fn part1_test() {
        let result = part1(INPUT);
        assert_eq!(result, 5671);
    }

    #[test]
    pub fn part2_test() {
        let result = part2(INPUT);
        assert_eq!(result, 4556);
    }
}
