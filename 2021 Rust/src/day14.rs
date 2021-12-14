use std::collections::HashMap;

pub struct Data {
    dict: HashMap<String, char>,
    template: String,
}

#[aoc_generator(day14)]
pub fn input_generator(input: &str) -> Data {
    let mut input = input.lines();
    let template = input.next().unwrap().to_owned();
    input.next();

    let dict = input
        .map(|l| {
            let p: Vec<&str> = l.split(" -> ").collect();
            (p[0].to_owned(), p[1].chars().next().unwrap())
        })
        .collect();

    Data { dict, template }
}

#[aoc(day14, part1)]
pub fn part1(input: &Data) -> usize {
    steps(input, 10)
}

#[aoc(day14, part2)]
pub fn part2(input: &Data) -> usize {
    steps(input, 40)
}

pub fn steps(input: &Data, count: usize) -> usize {
    //CH -> B will create an entry in the hashmap like {"CH": ("CB", "BH")}
    let dict: HashMap<String, (String, String)> = input
        .dict
        .clone()
        .iter()
        .map(|(key, value)| {
            let mut chars = key.chars();
            (
                key.to_owned(),
                (
                    format!("{}{}", chars.next().unwrap(), value),
                    format!("{}{}", value, chars.next().unwrap()),
                ),
            )
        })
        .collect();

    //Template represented as (polymer,repetitions) aka NNCB = {"NC": 1, "CB": 1, "NN": 1}
    let mut template = input
        .template
        .clone()
        .chars()
        .collect::<Vec<char>>()
        .windows(2)
        .map(|x| (format!("{}{}", x[0], x[1]), 1))
        .collect::<HashMap<String, usize>>();

    for _ in 0..count {
        let tmp = template.clone().into_iter().filter(|(_, v)| v > &0);
        tmp.for_each(|(k, v)| {
            let add = dict.get(&k).unwrap().clone();
            *template.entry(add.0.clone()).or_insert(0) += v;
            *template.entry(add.1.clone()).or_insert(0) += v;

            //Inserting the char in the middle, will "destroy" the original pair
            *template.entry(k).or_insert(v) -= v;
        });
    }

    let mut result: HashMap<char, usize> = HashMap::new();
    template.into_iter().for_each(|(k, v)| {
        let mut chars = k.chars();
        *result.entry(chars.next().unwrap()).or_insert(0) += v;
        *result.entry(chars.next().unwrap()).or_insert(0) += v;
    });

    let template_chars: Vec<char> = input.template.clone().chars().collect();

    *result.entry(template_chars[0]).or_insert(0) += 1;
    *result
        .entry(template_chars[template_chars.len() - 1])
        .or_insert(0) += 1;

    let result: Vec<usize> = result.into_iter().map(|(_, v)| v).collect();

    (result.iter().max().unwrap() - result.iter().min().unwrap()) / 2
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C";

    #[test]
    pub fn part1_test() {
        let result = steps(&input_generator(INPUT), 10);
        assert_eq!(result, 1588);
    }

    #[test]
    pub fn part2_test() {
        let result = steps(&input_generator(INPUT), 40);
        assert_eq!(result, 2188189693529);
    }
}
