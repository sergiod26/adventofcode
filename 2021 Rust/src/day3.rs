#[aoc(day3, part1)]
pub fn part1(input: &str) -> isize {
    let data: Vec<&str> = input.lines().collect();
    let cols = data[0].len();
    let rows = data.len() as u32;

    let mut vals = vec![0; cols];
    data.iter().for_each(|line| {
        for (i, c) in line.chars().enumerate() {
            vals[i] += c.to_digit(10).unwrap();
        }
    });

    let mut gamma: String = "".to_owned();
    let mut epsilon: String = "".to_owned();
    vals.iter().for_each(|&x| {
        gamma.push_str(if x > rows / 2 { "1" } else { "0" });
        epsilon.push_str(if x <= rows / 2 { "1" } else { "0" });
    });

    isize::from_str_radix(&gamma, 2).unwrap() * isize::from_str_radix(&epsilon, 2).unwrap()
}

#[aoc(day3, part2)]
pub fn part2(input: &str) -> isize {
    let data: Vec<&str> = input.lines().collect();
    let cols = data[0].len();
    let mut oxygen = data.clone();
    for n in 0..cols {
        let freq = freq(oxygen.clone(), cols);
        oxygen = oxygen
            .into_iter()
            .filter(|x| &x[n..n + 1] == freq[n] || (freq[n] == "-" && &x[n..n + 1] == "1"))
            .collect();

        if oxygen.iter().len() == 1 {
            break;
        }
    }
    let mut co2 = data.clone();
    for n in 0..cols {
        let freq = freq(co2.clone(), cols);
        co2 = co2
            .into_iter()
            .filter(|x| {
                (freq[n] == "-" && &x[n..n + 1] == "0")
                    || (freq[n] != "-" && &x[n..n + 1] != freq[n])
            })
            .collect();

        if co2.iter().len() == 1 {
            break;
        }
    }

    isize::from_str_radix(&oxygen[0], 2).unwrap() * isize::from_str_radix(&co2[0], 2).unwrap()
}

fn freq(data: Vec<&str>, cols: usize) -> Vec<&str> {
    let mut vals = vec![0; cols];

    data.iter().for_each(|line| {
        for (i, c) in line.chars().enumerate() {
            vals[i] += c.to_digit(10).unwrap();
        }
    });

    let rows = data.len() as f32;
    vals.clone()
        .iter()
        .map(|&x| {
            if (x as f32) > rows / 2.0 {
                "1"
            } else if (x as f32) < rows / 2.0 {
                "0"
            } else {
                "-"
            }
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = r#"00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"#;

    #[test]
    pub fn part1_test() {
        let result = part1(INPUT);
        assert_eq!(result, 198);
    }

    #[test]
    pub fn part2_test() {
        let result = part2(INPUT);
        assert_eq!(result, 230);
    }
}
