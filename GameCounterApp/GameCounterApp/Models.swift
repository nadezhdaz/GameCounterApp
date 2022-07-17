//
//  Models.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 19.09.2021.
//

import Foundation

struct Game: Codable {
    var firstStart: Bool
    var players: [Player]
    var turns: [Turn]
    var timing: Timing?
}

struct Player: Codable {
    var name: String
    var score: Int
}

struct Turn: Codable {
    var playerName: String
    var scoreChanged: String
    var lastScore: Int
    var currentPlayer: Int
}

struct Timing: Codable {
    var currentTime: TimeInterval?
}


