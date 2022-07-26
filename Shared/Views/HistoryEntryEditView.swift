import SwiftUI

struct HistoryEntryEditView: View {
    @EnvironmentObject var savedGame: SavedGame
    @EnvironmentObject var gameData: GameData
    @State var gameDescription = ""
    
    var body: some View {
        Form {
            Section("Description") {
                TextEditor(text: $gameDescription)
            }
        }
        .onAppear {
            self.gameDescription = self.savedGame.gameDescription
        }
        .onDisappear {
            self.savedGame.gameDescription = self.gameDescription
            
            self.gameData.gameHistory.updateSavedGame(savedGame: self.savedGame)
        }
        .navigationBarTitleDisplayMode(.inline)
        }
}
