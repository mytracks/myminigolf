import SwiftUI

struct HistoryEntryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var gameData: GameData
    @ObservedObject var entry: GameHistoryEntry
    @ObservedObject var savedGame: SavedGame
    @State var deleteDialogPresented = false
    
    init(entry: GameHistoryEntry) {
        self.entry = entry
        self.savedGame = SavedGame.load(from: entry) ?? SavedGame()
    }
    
    var body: some View {
        VStack {
            if self.savedGame.gameDescription.count > 0 {
                HStack {
                    Text(self.savedGame.gameDescription)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.horizontal)
            }
            List {
                ForEach(self.savedGame.players, id: \.self) { player in
                    HistoryPlayerCard()
                        .environmentObject(player)
                        .environmentObject(self.savedGame)
                }
                .listRowSeparatorTint(.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        .navigationTitle(entry.date.formatted())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.deleteDialogPresented = true
                } label: {
                    Label("Delete"~, systemImage: "trash")
                }
                .confirmationDialog("Delete"~, isPresented: $deleteDialogPresented) {
                    Button("Delete"~, role: .destructive) {
                        self.gameData.gameHistory.delete(id: self.savedGame.id)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    Button("Cancel"~, role: .cancel) {}
                } message: {
                    Text("Do you want to delete this history entry? This action cannot be undone."~)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink { 
                    HistoryEntryEditView()
                        .environmentObject(self.savedGame)
                        .environmentObject(self.entry)
                } label: {
                    Label("Edit"~, systemImage: "square.and.pencil")
                }
            }
            
        }
    }
}
