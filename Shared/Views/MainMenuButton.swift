import SwiftUI

struct MainMenuButton: View {
    @EnvironmentObject var gameData: GameData
    @State var isPresentingSettings = false
    @State var isPresentingAbout = false
    @State var activeSheet: SheetType?
    
    enum SheetType: Identifiable {
        case settings
        case about
        case history
        case newGame
        
        var id: Int {
            hashValue
        }
    }
    
    var body: some View {
        Menu {
            Button {
                if myminigolfApp.noPersistence {
                    self.generateGameData()
                }
                else {
                    self.activeSheet = .newGame
                }
            } label: {
                Label("New Game"~, systemImage: "arrowtriangle.right.circle")
            }
            .accessibilityIdentifier("mainMenuNewGame")

            Button {
                self.activeSheet = .history
            } label: {
                Label("Game History"~, systemImage: "book")
            }
            .accessibilityIdentifier("mainMenuGameHistory")

            Button {
                self.activeSheet = .settings
            } label: {
                Label("Settings"~, systemImage: "gear")
            }
            .accessibilityIdentifier("mainMenuSettings")

            Button {
                self.activeSheet = .about
            } label: {
                Label("About myMinigolf Board"~, systemImage: "heart")
            }
            .accessibilityIdentifier("mainMenuAbout")
        } label: {
            Image(systemName: "gear")
                .accessibilityIdentifier("mainMenu")
        }
        .sheet(item: $activeSheet) { sheetType in
            switch sheetType {
            case .newGame:
                NewGameView(activeSheet: $activeSheet)
            case .settings:
                SettingsView(activeSheet: $activeSheet)
            case .about:
                AboutView(activeSheet: $activeSheet)
            case .history:
                HistoryView(activeSheet: $activeSheet)
            }
        }
    }
    
    func generateGameData() {
        self.gameData.players.removeAll()
        
        let dirk = Player(name: "Dirk")
        let michael = Player(name: "Michael")
        let kai = Player(name: "Kai")

        self.gameData.players.append(dirk)
        self.gameData.players.append(michael)
        self.gameData.players.append(kai)
        
        let values = [
            2, 1, 2,
            4, 2, 2,
            1, 2, 1,
            3, 2, 4,
            7, 5, 4,
            2, 1, 1,
            4, 3, 6,
            2, 2, 2,
            3, 1, 3,
            3, 1, 2,
            4, 3, 3,
            ]
        
        for lanes in 0..<values.count/3 {
            dirk.add(hole: lanes+1, value: values[lanes*3+0])
            michael.add(hole: lanes+1, value: values[lanes*3+1])
            kai.add(hole: lanes+1, value: values[lanes*3+2])
        }
    }
}
