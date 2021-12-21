use std::collections::HashMap;

#[aoc_generator(day21)]
pub fn input_generator(input: &str) -> Vec<usize> {
    input
        .lines()
        .map(|l| {
            let mut str = l.to_string();
            str.replace_range(..28, "");
            str.parse::<usize>().unwrap()
        })
        .collect()
}

#[aoc(day21, part1)]
pub fn part1(input: &[usize]) -> usize {
    let mut pos1 = input[0];
    let mut pos2 = input[1];
    let mut points1 = 0;
    let mut points2 = 0;

    for i in 0.. {
        let start = i * 6;
        let dice1 = start + 1 + start + 2 + start + 3;
        pos1 = ((pos1 + dice1 - 1) % 10) + 1;
        points1 += pos1;

        if points1 >= 1000 {
            return ((i + 1) * 6 - 3) * points2;
        }

        let dice2 = start + 4 + start + 5 + start + 6;
        pos2 = ((pos2 + dice2 - 1) % 10) + 1;
        points2 += pos2;

        if points2 >= 1000 {
            return ((i + 1) * 6) * points1;
        }
    }

    unreachable!();
}

#[aoc(day21, part2)]
pub fn part2(input: &[usize]) -> usize {
    let mut cache = HashMap::new();
    let players = vec![
        Player {
            position: input[0],
            score: 0,
        },
        Player {
            position: input[1],
            score: 0,
        },
    ];
    let result = play(0, players, &mut cache);
    *vec![result.0, result.1].iter().max().unwrap()
}

#[derive(PartialEq, Eq, Hash, Clone)]
pub struct Player {
    position: usize,
    score: usize,
}

fn play(
    current: usize,
    players: Vec<Player>,
    cache: &mut HashMap<(usize, Vec<Player>), (usize, usize)>,
) -> (usize, usize) {
    //Multiple universes will have the same configuration... so remember solutions and skip calculations
    if let Some(res) = cache.get(&(current, players.clone())) {
        return *res;
    }
    if players[0].score >= 21 {
        *cache.entry((0, players)).or_insert((1, 0)) = (1, 0);
        return (1, 0);
    }
    if players[1].score >= 21 {
        *cache.entry((1, players)).or_insert((0, 1)) = (0, 1);
        return (0, 1);
    }

    let mut total_wins = (0, 0);
    for d1 in 1..=3 {
        for d2 in 1..=3 {
            for d3 in 1..=3 {
                let dice = d1 + d2 + d3;
                let position = ((players[current].position + dice - 1) % 10) + 1;
                let score = players[current].score + position;

                let mut updated = players.clone();
                updated[current] = Player { position, score };
                let rec = play((current + 1) % 2, updated, cache);
                total_wins = (total_wins.0 + rec.0, total_wins.1 + rec.1);
            }
        }
    }
    *cache.entry((current, players)).or_insert(total_wins) = total_wins;
    total_wins
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "Player 1 starting position: 4
Player 2 starting position: 8";

    #[test]
    pub fn part1_test() {
        let result = part1(&input_generator(INPUT));
        assert_eq!(result, 739785);
    }
    #[test]
    pub fn part2_test() {
        let result = part2(&input_generator(INPUT));
        assert_eq!(result, 444356092776315);
    }
}
