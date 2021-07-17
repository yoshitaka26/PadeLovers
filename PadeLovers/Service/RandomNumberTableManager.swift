//
//  RandomNumberTableManager.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/26.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation

struct Pair {
    let number: Int
    let player1: Int
    let player2: Int
    
    func contains(number: Int) -> Bool {
        guard player1 != number else { return true }
        guard player2 != number else { return true }
        return false
    }
}

struct Match {
    let number: Int
    let pair1: Pair
    let pair2: Pair
    
    func contains(number: Int) -> Bool {
        guard pair1.player1 != number else { return true }
        guard pair1.player2 != number else { return true }
        guard pair2.player1 != number else { return true }
        guard pair1.player2 != number else { return true }
        return false
    }
    var group: String {
        var list = [pair1.player1, pair1.player2, pair2.player1, pair2.player2]
        list.sort()
        var string = ""
        list.forEach { string.append("\($0)") }
        return string
    }
}

class RandomNumberTableManager {
    // swiftlint:disable force_unwrapping
    static let shared = RandomNumberTableManager()
        
    func generateTable(playerNumber: Int) -> [Match]? {
        
        guard 4...8 ~= playerNumber else { return nil }
        
        var pairs: [Pair] = []
        for i in 1..<playerNumber {
            for j in (i + 1)...playerNumber {
                let pair = Pair(number: pairs.count, player1: i, player2: j)
                pairs.append(pair)
            }
        }
        
        var matches: [Match] = []
        for i in 0..<pairs.count {
            for j in (i + 1)..<pairs.count {
                let pair1 = pairs[i]
                let pair2 = pairs[j]
                guard !pair1.contains(number: pair2.player1) else { continue }
                guard !pair1.contains(number: pair2.player2) else { continue }
                let match = Match(number: matches.count, pair1: pair1, pair2: pair2)
                matches.append(match)
            }
        }
        
        var playerGameNum: [Int: Int] = [:]
        for i in 0...playerNumber {
            playerGameNum[i] = 0
        }
        
        var pairGameNum: [Int: Int] = [:]
        for i in 0...pairs.count {
            pairGameNum[i] = 0
        }
        
        var groupGameNum: [String: Int] = [:]
        for match in matches {
            groupGameNum[match.group] = 0
        }
        
        var points: [Int: Int] = [:]
        for i in 1...playerNumber {
            points[i] = 0
        }
        
        var results: [Match] = []
        var inGames: [String] = []
        
        let weight = 10
        
        while true {
            guard !matches.isEmpty else { break }
            
            var minPriority = Int.max
            var candidates: [Match] = []
            for match in matches {
                let player1: Int = playerGameNum[match.pair1.player1]! * weight + match.pair1.player1
                let player2: Int = playerGameNum[match.pair1.player2]! * weight + match.pair1.player2
                let player3: Int = playerGameNum[match.pair2.player1]! * weight + match.pair2.player1
                let player4: Int = playerGameNum[match.pair2.player2]! * weight + match.pair2.player2
                let pair1: Int = pairGameNum[match.pair1.number]! * weight
                let pair2: Int = pairGameNum[match.pair2.number]! * weight
                let group = groupGameNum[match.group]! * weight
                let priority = player1 + player2 + player3 + player4 + pair1 + pair2 + group
                if minPriority >= priority {
                    if minPriority > priority {
                        minPriority = priority
                        candidates.removeAll()
                    }
                    candidates.append(match)
                }
            }
            
            var minMatch: Match?
            var minMatchNum = Int.max
            for candidate in candidates where minMatchNum > candidate.number {
                minMatchNum = candidate.number
                minMatch = candidate
                
            }
            
            guard let safeMinMatch = minMatch else { return nil }
            results.append(safeMinMatch)
            matches = matches.filter { $0.number != safeMinMatch.number }
            
            playerGameNum[safeMinMatch.pair1.player1]! += 1
            playerGameNum[safeMinMatch.pair1.player2]! += 1
            playerGameNum[safeMinMatch.pair2.player1]! += 1
            playerGameNum[safeMinMatch.pair2.player2]! += 1
            pairGameNum[safeMinMatch.pair1.number]! += 1
            pairGameNum[safeMinMatch.pair2.number]! += 1
            groupGameNum[safeMinMatch.group]! += 1
            
            points[safeMinMatch.pair1.player1]! += results.count
            points[safeMinMatch.pair1.player2]! += results.count
            points[safeMinMatch.pair2.player1]! += results.count
            points[safeMinMatch.pair2.player2]! += results.count
            
            for i in 1...playerNumber {
                if safeMinMatch.contains(number: i) {
                    inGames.append(String(playerGameNum[i]!))
                }
            }
        }
        return results
    }
    // swiftlint:enable force_unwrapping
}
