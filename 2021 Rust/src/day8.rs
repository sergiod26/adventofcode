use std::collections::HashSet;

#[aoc(day8, part1)]
pub fn part1(input: &str) -> usize {
    let tmp: Vec<Vec<&str>> = input
        .lines()
        .map(|l| {
            l.split(" | ")
                .into_iter()
                .nth(1)
                .unwrap()
                .split(" ")
                .collect::<Vec<&str>>()
        })
        .collect();

    let sizes: Vec<usize> = tmp
        .iter()
        .flat_map(|x| x.iter().map(|y| y.chars().count()))
        .collect();

    sizes
        .iter()
        .filter(|&x| x == &2 || x == &3 || x == &4 || x == &7)
        .collect::<Vec<&usize>>()
        .len()
}

#[aoc(day8, part2)]
pub fn part2(input: &str) -> usize {
    let mut final_answer = 0;
    for line in input.trim().lines() {
        let split: Vec<&str> = line.split(" | ").collect();
        let input: Vec<Vec<char>> = split[0]
            .split(" ")
            .map(|x| {
                let mut ch: Vec<char> = x.chars().collect();
                ch.sort();
                ch
            })
            .collect();

        let output: Vec<Vec<char>> = split[1]
            .split(" ")
            .map(|x| {
                let mut ch: Vec<char> = x.chars().collect();
                ch.sort();
                ch
            })
            .collect();

        let one = input.iter().filter(|x| x.iter().len() == 2).nth(0).unwrap();
        let seven = input.iter().filter(|x| x.iter().len() == 3).nth(0).unwrap();
        let four = input.iter().filter(|x| x.iter().len() == 4).nth(0).unwrap();
        let eight = input.iter().filter(|x| x.iter().len() == 7).nth(0).unwrap();

        let nine = input
            .iter()
            .filter(|&x| {
                x.iter().len() == 6 && diff(diff(x.clone(), seven.clone()), four.clone()).len() == 1
            })
            .nth(0)
            .unwrap();

        let zero = input
            .iter()
            .filter(|&x| {
                x.iter().len() == 6
                    && !eq(x.clone(), nine.clone())
                    && diff(x.clone(), one.clone()).len() == 4
            })
            .nth(0)
            .unwrap();

        let six = input
            .iter()
            .filter(|&x| x.iter().len() == 6 && diff(x.clone(), one.clone()).len() == 5)
            .nth(0)
            .unwrap();

        let two = input
            .iter()
            .filter(|&x| {
                x.iter().len() == 5 && diff(diff(x.clone(), seven.clone()), four.clone()).len() == 2
            })
            .nth(0)
            .unwrap();

        let three = input
            .iter()
            .filter(|&x| x.iter().len() == 5 && diff(x.clone(), seven.clone()).len() == 2)
            .nth(0)
            .unwrap();

        let five = input
            .iter()
            .filter(|&x| {
                x.iter().len() == 5
                    && !eq(x.clone(), three.clone())
                    && diff(diff(x.clone(), seven.clone()), four.clone()).len() == 1
            })
            .nth(0)
            .unwrap();

        // println!("0 {:?}", zero);
        // println!("1 {:?}", one);
        // println!("2 {:?}", two);
        // println!("3 {:?}", three);
        // println!("4 {:?}", four);
        // println!("5 {:?}", five);
        // println!("6 {:?}", six);
        // println!("7 {:?}", seven);
        // println!("8 {:?}", eight);
        // println!("9 {:?}", nine);

        let values = vec![zero, one, two, three, four, five, six, seven, eight, nine];
        let mut answer = 0;

        for o in output {
            answer *= 10;
            let r = values
                .iter()
                .enumerate()
                .filter(|(_, &v)| eq(o.clone(), v.clone()))
                .nth(0)
                .expect(&format!("MISS {:?}\n\n{:?}", o, values));
            answer += r.0;
        }
        final_answer += answer;
    }
    final_answer
}

fn diff(vec1: Vec<char>, vec2: Vec<char>) -> Vec<char> {
    vec1.iter()
        .cloned()
        .collect::<HashSet<_>>()
        .difference(&vec2.iter().cloned().collect::<HashSet<_>>())
        .cloned()
        .collect()
}

fn eq(vec1: Vec<char>, vec2: Vec<char>) -> bool {
    vec1.len() == vec2.len()
        && vec1.iter().zip(&vec2).filter(|&(a, b)| a == b).count() == vec1.len()
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = r#"be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"#;
    #[test]
    pub fn part1_test() {
        let result = part1(INPUT);
        assert_eq!(result, 26);
    }

    #[test]
    pub fn part2_test() {
        let result = part2(INPUT);
        assert_eq!(result, 61229);
    }
}
