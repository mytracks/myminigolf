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
                self.activeSheet = .newGame
            } label: {
                Label("New Game"~, systemImage: "arrowtriangle.right.circle")
            }
            Button {               
                self.activeSheet = .history
            } label: {
                Label("Game History"~, systemImage: "book")
            }
            Button {               
                self.activeSheet = .settings
            } label: {
                Label("Settings"~, systemImage: "gear")
            }
            Button {
                self.activeSheet = .about
            } label: {
                Label("About myMinigolf Board"~, systemImage: "heart")
            }
        } label: {
            Image(systemName: "gear")
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
}
