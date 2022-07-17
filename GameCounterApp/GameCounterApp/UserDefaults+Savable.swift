//
//  UserDefaults+Savable.swift
//  GameCounterApp
//
//  Created by Nadezhda Zenkova on 19.09.2021.
//
import Foundation

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

final class GameSaver {
    private(set) lazy var currentGame = loadGame()
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func updateGame(to game: Game) {
        currentGame = game
        do {
            try UserDefaults.standard.setObject(game, forKey: "Game")
        } catch {
            print(error.localizedDescription)
        }
    }

    private func loadGame() -> Game? {
        if let game = try? UserDefaults.standard.getObject(forKey: "Game", castTo: Game.self) { return game }
        return nil
    }
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
