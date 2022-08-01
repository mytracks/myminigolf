import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var gameData: GameData
    @State var maxStrokes = 1
    @State var numberLanes = 1    
    @Binding var activeSheet: MainMenuButton.SheetType?
    @State var showAllLanes = false
    
    var body: some View {
        NavigationView {
            Group {
                Form {
                    Section(header: Text("Game"~), footer: Text("These settings will be used when you start a new game."~)) {
                        Stepper(String(format: "Max %d strokes"~, maxStrokes), value: $maxStrokes, in: 5...20)
                        Stepper(String(format: "%d lanes"~, numberLanes), value: $numberLanes, in: 1...99)
                    } 
                    Section(header: Text("View"~)) {
                        Toggle("Show all lanes"~, isOn: $showAllLanes)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .onAppear {
                self.maxStrokes = self.gameData.settingsMaxStrokes
                self.numberLanes = self.gameData.settingsNumberLanes
                self.showAllLanes = UserDefaults.standard.bool(forKey: "ShowAllLanes")
            }
            .onChange(of: self.activeSheet) { activeSheet in 
                if activeSheet != .settings {
                    self.gameData.settingsMaxStrokes = self.maxStrokes
                    self.gameData.settingsNumberLanes = self.numberLanes
                    self.gameData.saveState()
                    
                    if !self.gameData.isInGame {
                        self.gameData.newGame(description: nil)
                    }
                    
                    UserDefaults.standard.set(self.showAllLanes, forKey: "ShowAllLanes")
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close"~) {
                        self.activeSheet = nil
                    }
                    .accessibilityIdentifier("settingsClose")
                }
            }
            .navigationTitle("Settings")
        }
    }
}
