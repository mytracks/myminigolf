import SwiftUI

class SavedGame: NSObject, ObservableObject, Codable {
    var id: String
    @Published var date: Date
    @Published var gameDescription: String
    @Published var players = [Player]()
    @Published var numberLanes: Int
    @Published var maxStrokes: Int
    
    override init() {
        self.id = UUID().uuidString
        self.date = Date()
        self.gameDescription = ""
        self.numberLanes = 0
        self.maxStrokes = 0
        
        super.init()
    }
    
    init(currentGameData: GameData) {
        self.id = currentGameData.currentGameId
        self.date = currentGameData.startOfGame ?? Date()
        self.gameDescription = currentGameData.gameDescription
        self.numberLanes = currentGameData.numberLanes
        self.maxStrokes = currentGameData.maxStrokes
        
        self.players = currentGameData.players
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? values.decode(String.self, forKey: .id)) ?? UUID().uuidString
        self.date = (try? values.decode(Date.self, forKey: .date)) ?? Date()
        self.gameDescription = (try? values.decode(String.self, forKey: .description)) ?? ""
        self.players = (try? values.decode([Player].self, forKey: .players)) ?? [Player]()
        self.numberLanes = (try? values.decode(Int.self, forKey: .numberLanes)) ?? 18
        self.maxStrokes = (try? values.decode(Int.self, forKey: .maxStrokes)) ?? 7
        
        super.init()
        
        self.update()
    }
    
    func update() {
        for player in self.players {
            player.update()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case description
        case players
        case numberLanes
        case maxStrokes
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.gameDescription, forKey: .description)
        try container.encode(self.numberLanes, forKey: .numberLanes)
        try container.encode(self.players, forKey: .players)
        try container.encode(self.numberLanes, forKey: .numberLanes)
        try container.encode(self.maxStrokes, forKey: .maxStrokes)
    }
    
    static func load(from entry: GameHistoryEntry) -> SavedGame? {
        do {
            let filename = "game_\(entry.id).json"
            if let data = try Data.load(filename: filename) {
                let savedGame = try JSONDecoder().decode(SavedGame.self, from: data)
                
                return savedGame
            }
            else {
                print("No saved game for id \(entry.id).")
            }
        }
        catch let error {
            print("error loading history: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func saveGame() {
        let gameFilename = "game_\(self.id).json"
        
        do {
            if let data = try? JSONEncoder().encode(self) {
                let _ = try data.save(filename: gameFilename)
            }
        }
        catch let error {
            print("error saving SavedGame: \(error.localizedDescription)")
        }
    }
    
    static func delete(id: String) {
        let gameFilename = "game_\(id).json"
        do {
            try Data.delete(filename: gameFilename)
        }
        catch {
            print("Error deleting \(gameFilename)")
        }
    }
}

class GameHistoryEntry: NSObject, ObservableObject, Codable {
    var id: String
    @Published var date: Date
    @Published var gameDescription: String
    
    override init() {
        self.id = UUID().uuidString
        self.date = Date()
        self.gameDescription = ""
    }
    
    init(savedGame: SavedGame) {
        self.id = savedGame.id
        self.date = savedGame.date
        self.gameDescription = savedGame.gameDescription
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? values.decode(String.self, forKey: .id)) ?? UUID().uuidString
        self.date = (try? values.decode(Date.self, forKey: .date)) ?? Date()
        self.gameDescription = (try? values.decode(String.self, forKey: .description)) ?? ""
        
        super.init()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case description
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.gameDescription, forKey: .description)
    }
}

class GameHistory: NSObject, ObservableObject, Codable {
    private var entries = [String:GameHistoryEntry]()
    @Published var sortedEntries = [GameHistoryEntry]()
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.entries = try values.decode([String:GameHistoryEntry].self, forKey: .entries)
        
        super.init()
        
        self.updateSortedEntries()
    }
    
    enum CodingKeys: String, CodingKey {
        case entries
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.entries, forKey: .entries)
    }
    
    func saveCurrentGame(gameData: GameData) {
        guard gameData.currentGameId.count > 0 else { return }
        guard gameData.isInGame else { return }
        
        let savedGame = SavedGame(currentGameData: gameData)
        self.updateSavedGame(savedGame: savedGame)
    }
    
    func updateSavedGame(savedGame: SavedGame) {
        savedGame.saveGame()
        self.entries[savedGame.id] = GameHistoryEntry(savedGame: savedGame)
        self.save()
    }
    
    func delete(id: String) {
        if self.entries[id] != nil {
            self.entries.removeValue(forKey: id)
            self.save()
            SavedGame.delete(id: id)
        }
    }
    
    static func loadHistory() -> GameHistory {
        do {
            if let data = try Data.load(filename: "history.json") {
                let gameHistory = try JSONDecoder().decode(GameHistory.self, from: data)
                
                return gameHistory
            }
            else {
                print("no saved history.")
            }
        }
        catch let error {
            print("error loading history: \(error.localizedDescription)")
        }
        
        return GameHistory()
    }
    
    func save() {
        do {
            if let data = try? JSONEncoder().encode(self) {
                let _ = try data.save(filename: "history.json")
            }
        }
        catch let error {
            print("error saving history: \(error.localizedDescription)")
        }
        
        self.updateSortedEntries()
    }
    
    private func updateSortedEntries() {
        self.sortedEntries = self.entries.values.map({$0}).sorted(by: {e1, e2 in e1.date > e2.date})
    }
}
