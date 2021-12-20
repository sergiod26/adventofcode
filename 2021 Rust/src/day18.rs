// use Number::*;

// #[derive(Debug, Clone)]
// enum Number {
//     Regular(i32),
//     Pair(Box<Number>, Box<Number>),
// }

// // #[aoc_generator(day18)]
// // pub fn input_generator(input: &str) -> Vec<i32> {
// //     todo!();
// // }

// #[aoc(day18, part1)]
// pub fn part1(input: &str) -> i32 {
//     use Number::*;

//     let data = vec![(1, 1), (2, 2), (3, 3), (4, 4), (5, 5)];
//     let mut result = to_number(data[0]);

//     for (a, b) in data.into_iter().skip(1) {
//         result = reduce(
//             Pair(
//                 Box::new(result),
//                 Box::new(Pair(Box::new(Regular(a)), Box::new(Regular(b)))),
//             ),
//             1,
//         )
//         .0;
//         //println!("{:?}", result);
//         println!("***********");
//     }

//     0
// }

// fn reduce(number: Number, depth: usize) -> (Number, i32, i32) {
//     match number.clone() {
//         Regular(num) => (Regular(num), 0, 0),
//         Pair(a, b) => {
//             match (*a, *b) {
//                 (Pair(aa, ab), pair) => {
//                     let (num, left, right) = explode(*aa, *ab);
//                     (
//                         Pair(Box::new(num), Box::new(add_left(pair, right))),
//                         left,
//                         0,
//                     )
//                 }
//                 (regular, Pair(ba, bb)) => {
//                     let (num, left, right) = explode(*ba, *bb);
//                     (
//                         Pair(Box::new(add_right(regular, left)), Box::new(num)),
//                         0,
//                         right,
//                     )
//                 }
//                 _ => panic!(),
//             }

//             // if depth == 4 {
//             //     println!("reduce {:?} depth: {:?}", &number, depth);
//             //     let (num, left, right) = explode(*a);
//             //     (Pair(Box::new(num), Box::new(add_left(*b, right))), left, 0)
//             // } else {
//             //     //
//             //     let left = reduce(*a, depth + 1);
//             //     let right = reduce(*b, depth + 1);
//             //     (
//             //         Pair(
//             //             Box::new(add_right(left.0, right.1)),
//             //             Box::new(add_left(right.0, left.2)),
//             //         ),
//             //         0,
//             //         0,
//             //     )
//             // }
//         }
//     }
// }

// fn explode(a: Number, b: Number) -> (Number, i32, i32) {
//     match (a, b) {
//         (Regular(aa), Regular(bb)) => (Regular(0), aa, bb),
//         _ => panic!(),
//     }
// }

// fn foo(number: Number) -> (i32, i32) {
//     if let Pair(a, b) = number {
//         if let Regular(a_val) = *a {
//             if let Regular(b_val) = *b {
//                 return (a_val, b_val);
//             }
//         }
//     }
//     panic!("FOO");
// }

// fn add_right(number: Number, val: i32) -> Number {
//     match number {
//         Pair(a, b) => Pair(a, Box::new(add_right(*b, val))),
//         Regular(n) => Regular(n + val),
//     }
// }

// fn add_left(number: Number, val: i32) -> Number {
//     match number {
//         Pair(a, b) => Pair(Box::new(add_left(*a, val)), b),
//         Regular(n) => Regular(n + val),
//     }
// }

// fn to_number((a, b): (i32, i32)) -> Number {
//     use Number::*;
//     Pair(Box::new(Regular(a)), Box::new(Regular(b)))
// }

// #[cfg(test)]
// mod tests {
//     use super::*;

//     const INPUT: &str = "3,4,3,1,2";
//     #[test]
//     pub fn part1_test() {
//         let result = part1(INPUT);
//         assert_eq!(result, 0);
//     }
// }
