import SwiftUI

class Player: NSObject, ObservableObject, Codable {
    let name: String
    @Published private (set) var lanes = [Int:Int]()
    @Published private (set) var sum: Int = 0
    
    init(name: String) {
        self.name = name
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.lanes = try values.decode([Int:Int].self, forKey: .lanes)
    }
    
    func add(lane: Int, value: Int) {
        self.lanes[lane] = value
        self.update()
    }
    
    func remove(lane: Int) {
        self.lanes.removeValue(forKey: lane)
        self.update()
    } 
    
    var playedNumberLanes: Int {
        self.lanes.keys.count
    }
    
    func valueOf(lane: Int) -> Int? {
        self.lanes[lane]
    }
    
    func getNextLane(gameData: GameData) -> Int? {
        var index = 1
        for lane in self.lanes.keys.sorted() {
            if lane != index {
                return index
            }
            
            index += 1
        }
        
        if index > gameData.numberLanes {
            return nil
        }
        
        return index
    }
    
    fileprivate func resetLanes() {
        self.lanes.removeAll()
        self.update()
    }
    
    func update() {
        var s = 0
        
        for lane in self.lanes.keys {
            s += self.lanes[lane] ?? 0
        }
        
        self.sum = s
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case lanes
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.lanes, forKey: .lanes)
    }
}

class GameData: NSObject, ObservableObject, Encodable, Decodable {
    @Published var players = [Player]()
    @Published var isInGame = false
    @Published var currentGameId: String
    @Published var startOfGame: Date?
    
    @Published var settingsNumberLanes: Int
    @Published var settingsMaxStrokes: Int
    
    @Published var numberLanes: Int
    @Published var maxStrokes: Int
    @Published var gameDescription: String
    
    @Published var gameHistory = GameHistory.loadHistory()
    
    override init() {
        self.numberLanes = 18
        self.maxStrokes = 7
        self.settingsNumberLanes = 18
        self.settingsMaxStrokes = 7
        self.currentGameId = UUID().uuidString
        self.gameDescription = ""
        
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.currentGameId = (try? values.decode(String.self, forKey: .currentGameId)) ?? UUID().uuidString
        self.players = (try? values.decode([Player].self, forKey: .players)) ?? [Player]()
        self.numberLanes = (try? values.decode(Int.self, forKey: .numberLanes)) ?? 18
        self.maxStrokes = (try? values.decode(Int.self, forKey: .maxStrokes)) ?? 7
        self.settingsNumberLanes = (try? values.decode(Int.self, forKey: .settingsNumberLanes)) ?? 18
        self.settingsMaxStrokes = (try? values.decode(Int.self, forKey: .settingsMaxStrokes)) ?? 7
        self.gameDescription = (try? values.decode(String.self, forKey: .description)) ?? ""
        
        super.init()
        
        for player in self.players {
            player.update()
        }
    }
    
    func newGame(description: String?) {
        self.gameHistory.saveCurrentGame(gameData: self)
        
        for player in self.players {
            player.resetLanes()
        }
        
        if let description = description {
            self.gameDescription = description
        }
        self.maxStrokes = self.settingsMaxStrokes
        self.numberLanes = self.settingsNumberLanes
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
            if player.playedNumberLanes > 0 {
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
        try container.encode(self.numberLanes, forKey: .numberLanes)
        try container.encode(self.maxStrokes, forKey: .maxStrokes)
        try container.encode(self.settingsNumberLanes, forKey: .settingsNumberLanes)
        try container.encode(self.settingsMaxStrokes, forKey: .settingsMaxStrokes)
        try container.encode(self.gameDescription, forKey: .description)
    }
}
