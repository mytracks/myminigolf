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
                self.entries = self.gameData.gameHistory.sortedEntries
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close"~) {
                        self.activeSheet = nil
                    }
                }
            }
            .navigationTitle("Game History"~)
        }
    }
}
