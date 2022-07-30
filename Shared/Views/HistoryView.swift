import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var gameData: GameData
    @Binding var activeSheet: MainMenuButton.SheetType?
    @State var entryViewPresented = false
    @State var entries = [GameHistoryEntry]()
    
    func labelText(entry: GameHistoryEntry) -> String {
        var text = "\(entry.date.formatted())"
        if entry.gameDescription.count > 0 {
            text += " " + entry.gameDescription
        } 
        return text
    }
    
    var body: some View {
        NavigationView {
            Group {
                List {
                    ForEach(self.entries, id: \.self) { entry in
                        NavigationLink {
                            HistoryEntryView(entry: entry)
                        } label: {
                            Text(self.labelText(entry: entry))
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                }
            }
            .onAppear {
                if myminigolfApp.noPersistence {
                    self.generateTestData()
                }
                else {
                    self.entries = self.gameData.gameHistory.sortedEntries
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close"~) {
                        self.activeSheet = nil
                    }
                    .accessibilityIdentifier("gameHistoryClose")
                }
            }
            .navigationTitle("Game History"~)
        }
    }
    
    func generateTestData() {
        let e1 = GameHistoryEntry()
        e1.date = Date(timeIntervalSinceReferenceDate: 680288700)
        e1.gameDescription = "Weissensee"
        
        self.entries.append(e1)

        let e2 = GameHistoryEntry()
        e2.date = Date(timeIntervalSinceReferenceDate: 675786180)
        e2.gameDescription = "Neubeckum"
        
        self.entries.append(e2)

        let e3 = GameHistoryEntry()
        e3.date = Date(timeIntervalSinceReferenceDate: 669654660)
        e3.gameDescription = "Paderborn"
        
        self.entries.append(e3)
    }
}
