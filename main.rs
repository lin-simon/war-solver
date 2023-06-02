#![allow(non_snake_case,non_camel_case_types,dead_code)]
use std::convert::TryInto;

/*
    Below is the function stub for deal. Add as many helper functions
    as you like, but the deal function should not be modified. Just
    fill it in.
    
    Test your code by running 'cargo test' from the war_rs directory.
*/
// search for 1's change to 14
fn fixAces(card: u8) -> u8 {
    if card == 1 {
        14
    } else {
        card
    }
}
// search for 14's, revert to 1's
fn revertAces(card: u8) -> u8 {
    if card == 14 {
        1
    } else {
        card
    }
}


fn turn(p1: &mut Vec<u8>, p2: &mut Vec<u8>, warchest: &Vec<u8>) -> Vec<u8> {
    // make warchest mutable
    let mut warchest: Vec<u8> = warchest.to_vec();
    // sort the war chest from largest to smallest each recursive call
    warchest.sort_unstable_by(|a, b| b.cmp(a));
    // check for a tie edgecase in war, return winning hand
    if p1.is_empty() && p2.is_empty() {
        return warchest;
    }
    // check for p1 running out of cards
    if p1.is_empty() {
        p2.append(&mut warchest);
        return p2.to_vec();
    }
    // check for p2 running out of cards
    if p2.is_empty() {
        p1.append(&mut warchest);
        return p1.to_vec();
    }
    // if not base case, perform gameloop aka recursive case
    //head tail recursion
    let p1_top = p1[0];
    let p1_tail = &p1[1..];
    let p2_top = p2[0];
    let p2_tail = &p2[1..];
 
    warchest.extend_from_slice(&[p1_top, p2_top]);
    // sort the war chest from largest to smallest each recursive call
    warchest.sort_unstable_by(|a, b| b.cmp(a));
    // compare top card rank of both hands
    if p1_top > p2_top {
        //add the warchest to winning hand when someone wins the war
        p1.extend_from_slice(&warchest);
        //empty the warchest when someone wins the war
        warchest.clear();
        p1.remove(0);
        // recursively play with updated hands
        return turn(&mut p1.to_vec(), &mut p2_tail.to_vec(), &warchest);

    } else if p2_top > p1_top {
        //add the warchest to winning hand when someone wins the war
        p2.extend_from_slice(&warchest);
        warchest.clear();
        p2.remove(0);
        // recursively play with updated hands
        return turn(&mut p1_tail.to_vec(), &mut p2.to_vec(), &warchest);
    } else {
        // same rank, check if war is possible recurse turn() and add matching cards to warchest
        if ((p1.len() > 2) && (p2.len() > 2)) && (p1_top == p2_top) {    
            let (d1, rest1) = p1_tail.split_first().unwrap();
            let (d2, rest2) = p2_tail.split_first().unwrap();
            //add the face down cards warchest when begin war
            warchest.push(*d1);
            warchest.push(*d2);
            return turn(&mut rest1.to_vec(),&mut rest2.to_vec(), &warchest);
        }
        else
        {
            return turn(&mut p1_tail.to_vec(),&mut p2_tail.to_vec(), &warchest);
        }
    };
}

fn deal(shuf: &[u8; 52]) -> [u8; 52] {
    let mut p1 = [0; 26];
    let mut p2 = [0; 26];
    let warchest: Vec<u8> = Vec::new();
    // convert every 1 to 14 in shuffled cards to simplify comparisons later
    for (i, &card) in shuf.iter().enumerate() {
        let ace = fixAces(card);
        if i % 2 == 0 {
            p1[i/2] = ace;
        } else {
            p2[i/2] = ace;
        }
    }
    p1.reverse();
    p2.reverse();
    let mut winner = turn(&mut p1.to_vec(),&mut p2.to_vec(), &warchest);
    // revert every 14 to 1 
    for i in 0..winner.len() { 
        let newace = revertAces(winner[i]);
        winner[i] = newace;
    }
    // convert vec to u8
    let new_winner: [u8; 52] = winner.try_into().unwrap();
    
    return new_winner

}


#[cfg(test)]
#[path = "tests.rs"]
mod tests;

