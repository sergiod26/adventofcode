use Number::*;

#[derive(Debug, Clone)]
enum Number {
    Regular(i32),
    Pair(Box<Number>, Box<Number>),
}

// #[aoc_generator(day18)]
// pub fn input_generator(input: &str) -> Vec<i32> {
//     todo!();
// }

#[aoc(day18, part1)]
pub fn part1(input: &str) -> i32 {
    use Number::*;

    let data = vec![(1, 1), (2, 2), (3, 3), (4, 4), (5, 5)];
    let mut result = to_number(data[0]);

    for (a, b) in data.into_iter().skip(1) {
        result = reduce(
            Pair(
                Box::new(result),
                Box::new(Pair(Box::new(Regular(a)), Box::new(Regular(b)))),
            ),
            1,
        )
        .0;
        //println!("{:?}", result);
        println!("***********");
    }

    0
}

fn reduce(number: Number, depth: usize) -> (Number, i32, i32) {
    match number.clone() {
        Regular(num) => (Regular(num), 0, 0),
        Pair(a, b) => {
            if depth + 1 == 4 {
                println!("reduce {:?} depth: {:?}", &number, depth);
                match (*a, *b) {
                    (Regular(aa), Regular(bb)) => (Regular(0), aa, bb),
                    (Regular(aa), Pair(ba, bb)) => {
                        let pair = foo(Pair(ba, bb));
                        (
                            Pair(Box::new(Regular(aa + pair.0)), Box::new(Regular(0))),
                            0,
                            pair.1,
                        )
                    }
                    (Pair(aa, ab), Regular(bb)) => {
                        let pair = foo(Pair(aa, ab));
                        (
                            Pair(Box::new(Regular(0)), Box::new(Regular(bb + pair.1))),
                            pair.0,
                            0,
                        )
                    }
                    (Pair(aa, ab), Pair(ba, bb)) => {
                        let pair_a = foo(Pair(aa, ab));
                        let pair_b = foo(Pair(ba, bb));
                        (
                            Pair(
                                Box::new(Regular(0)),
                                Box::new(Pair(
                                    Box::new(Regular(pair_b.0 + pair_a.1)),
                                    Box::new(Regular(pair_b.1)),
                                )),
                            ),
                            0,
                            0,
                        )
                    }
                    _ => panic!(),
                }
            } else {
                //println!("reduce {:?} depth: {:?}", &number, depth);
                let left = reduce(*a, depth + 1);
                let right = reduce(*b, depth + 1);
                (
                    Pair(
                        Box::new(add_right(left.0, right.1)),
                        Box::new(add_left(right.0, left.2)),
                    ),
                    0,
                    0,
                )
            }
        }
    }
}

fn explode(number: Number) -> (Number, i32, i32) {
    match number {
        Pair(a, b) => match (*a, *b) {
            (Regular(aa), Regular(bb)) => (Regular(0), aa, bb),
            _ => panic!(),
        },
        _ => panic!(),
    }
}

fn foo(number: Number) -> (i32, i32) {
    if let Pair(a, b) = number {
        if let Regular(a_val) = *a {
            if let Regular(b_val) = *b {
                return (a_val, b_val);
            }
        }
    }
    panic!("FOO");
}

fn add_right(number: Number, val: i32) -> Number {
    match number {
        Pair(a, b) => Pair(a, Box::new(add_right(*b, val))),
        Regular(n) => Regular(n + val),
    }
}

fn add_left(number: Number, val: i32) -> Number {
    match number {
        Pair(a, b) => Pair(Box::new(add_left(*a, val)), b),
        Regular(n) => Regular(n + val),
    }
}

fn to_number((a, b): (i32, i32)) -> Number {
    use Number::*;
    Pair(Box::new(Regular(a)), Box::new(Regular(b)))
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "3,4,3,1,2";
    #[test]
    pub fn part1_test() {
        let result = part1(INPUT);
        assert_eq!(result, 0);
    }
}
