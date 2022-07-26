import SwiftUI

struct NewGameView: View {
    @EnvironmentObject var gameData: GameData
    @Binding var activeSheet: MainMenuButton.SheetType?
    @State var gameDescription = ""
    
    var body: some View {NavigationView {
        Group {
            Form {
                Section {
                    TextEditor(text: $gameDescription)
                } header: {
                    Text("Description"~)
                } footer: {
                    Text("When you start a new game your current game will be saved in the game history."~)
                }
            }
            .listStyle(.insetGrouped)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Start"~, role: .none) {
                    self.gameData.newGame(description: self.gameDescription)
                    self.activeSheet = nil
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel"~, role: .cancel) {
                    self.activeSheet = nil
                }
            }
        }
        .navigationTitle("New Game"~)
    }
    }
}
