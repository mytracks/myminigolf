import SwiftUI

class Player: NSObject, ObservableObject, Codable {
    let name: String
    @Published private (set) var holes = [Int:Int]()
    @Published private (set) var sum: Int = 0
    
    init(name: String) {
        self.name = name
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.holes = try values.decode([Int:Int].self, forKey: .holes)
    }
    
    func add(hole: Int, value: Int) {
        self.holes[hole] = value
        self.update()
    }
    
    func remove(hole: Int) {
        self.holes.removeValue(forKey: hole)
        self.update()
    } 
    
    var playedNumberHoles: Int {
        self.holes.keys.count
    }
    
    func valueOf(hole: Int) -> Int? {
        self.holes[hole]
    }
    
    func getNextHole(gameData: GameData) -> Int? {
        var index = 1
        for hole in self.holes.keys.sorted() {
            if hole != index {
                return index
            }
            
            index += 1
        }
        
        if index > gameData.numberHoles {
            return nil
        }
        
        return index
    }
    
    fileprivate func resetHoles() {
        self.holes.removeAll()
        self.update()
    }
    
    func update() {
        var s = 0
        
        for hole in self.holes.keys {
            s += self.holes[hole] ?? 0
        }
        
        self.sum = s
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case holes
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.holes, forKey: .holes)
    }
}

class GameData: NSObject, ObservableObject, Encodable, Decodable {
    @Published var players = [Player]()
    @Published var isInGame = false
    @Published var currentGameId: String
    @Published var startOfGame: Date?
    
    @Published var settingsNumberHoles: Int
    @Published var settingsMaxShots: Int
    
    @Published var numberHoles: Int
    @Published var maxShots: Int
    @Published var gameDescription: String
    
    @Published var gameHistory = GameHistory.loadHistory()
    
    override init() {
        self.numberHoles = 18
        self.maxShots = 7
        self.settingsNumberHoles = 18
        self.settingsMaxShots = 7
        self.currentGameId = UUID().uuidString
        self.gameDescription = ""
        
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.currentGameId = (try? values.decode(String.self, forKey: .currentGameId)) ?? UUID().uuidString
        self.players = (try? values.decode([Player].self, forKey: .players)) ?? [Player]()
        self.numberHoles = (try? values.decode(Int.self, forKey: .numberLanes)) ?? 18
        self.maxShots = (try? values.decode(Int.self, forKey: .maxStrokes)) ?? 7
        self.settingsNumberHoles = (try? values.decode(Int.self, forKey: .settingsNumberLanes)) ?? 18
        self.settingsMaxShots = (try? values.decode(Int.self, forKey: .settingsMaxStrokes)) ?? 7
        self.gameDescription = (try? values.decode(String.self, forKey: .description)) ?? ""
        
        super.init()
        
        for player in self.players {
            player.update()
        }
    }
    
    func newGame(description: String?) {
        self.gameHistory.saveCurrentGame(gameData: self)
        
        for player in self.players {
            player.resetHoles()
        }
        
        if let description = description {
            self.gameDescription = description
        }
        self.maxShots = self.settingsMaxShots
        self.numberHoles = self.settingsNumberHoles
        self.currentGameId = UUID().uuidString
        self.startOfGame = Date()
        
        self.saveState()
    }
    
    func add(player name: String) {
        let player = Player(name: name)
        
        self.players.append(player)
        
        self.saveState()
    }
    
    func removePlayer(at index: Int) {
        self.players.remove(at: index)
        self.saveState()
    }
    
    func movePlayers(fromOffsets from: IndexSet, toOffset to: Int) {
        self.players.move(fromOffsets: from, toOffset: to)
    }
    
    func saveState() {
        guard !myminigolfApp.noPersistence else { return }
        
        do {
            self.update()
            
            if let data = try? JSONEncoder().encode(self) {
                let _ = try data.save(filename: "gamedata.json")
            }
            
            self.gameHistory.saveCurrentGame(gameData: self)
        }
        catch let error {
            print("error saving state: \(error.localizedDescription)")
        }
    }
    
    func update() {
        var playing = false
        
        for player in self.players {
            if player.playedNumberHoles > 0 {
                playing = true
            }
        }
        
        if self.startOfGame == nil && playing {
            self.startOfGame = Date()
        }
        
        self.isInGame = playing
    }
    
    static func loadState() -> GameData {
        guard !myminigolfApp.noPersistence else { return GameData() }

        do {
            if let data = try Data.load(filename: "gamedata.json") {
                let gameData = try JSONDecoder().decode(GameData.self, from: data)
                
                gameData.update()
                
                return gameData
            }
        }
        catch let error {
            print("error loading state: \(error.localizedDescription)")
        }
        
        return GameData()
    }
    
    enum CodingKeys: String, CodingKey {
        case currentGameId
        case players
        case numberLanes
        case maxStrokes
        case settingsNumberLanes
        case settingsMaxStrokes
        case description
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.currentGameId, forKey: .currentGameId)
        try container.encode(self.players, forKey: .players)
        try container.encode(self.numberHoles, forKey: .numberLanes)
        try container.encode(self.maxShots, forKey: .maxStrokes)
        try container.encode(self.settingsNumberHoles, forKey: .settingsNumberLanes)
        try container.encode(self.settingsMaxShots, forKey: .settingsMaxStrokes)
        try container.encode(self.gameDescription, forKey: .description)
    }
}
