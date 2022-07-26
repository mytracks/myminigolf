import SwiftUI

struct MainScreen: View {
    @EnvironmentObject var gameData: GameData
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if self.gameData.players.count > 0 {
                        List {
                            ForEach(self.gameData.players, id: \.self) { player in
                                PlayerCard()
                                    .environmentObject(player)
                                    .listRowSeparatorTint(.clear)
                                    .listRowBackground(AppStyle.shared.backgroundColor)
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    self.gameData.removePlayer(at: index)
                                }
                            }
                            .onMove { from, to in
                                self.gameData.movePlayers(fromOffsets: from, toOffset: to)
                            }
                        }
                        .listStyle(.plain)
                    }
                    else {
                        Text("Welcome to myMinigolf Board."~)
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .padding()
                        Text("Add some players by tapping the button with the plus sign at the bottom."~)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    Spacer()
                }
                VStack {
                    Spacer()
                    VStack {
                        if self.gameData.players.count > 0 && !self.gameData.isInGame {
                            Text("Either add more players or tap a player's card to start."~)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(EdgeInsets(top: 10, leading: 8, bottom: 0, trailing: 8))
                        }
                        NewPlayerButton()
                            .padding(10)
                    }
                    .frame(minWidth: nil, idealWidth: nil, maxWidth: .infinity, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .bottom)
                    .background(
                        .regularMaterial)
                }
            }
            .background(AppStyle.shared.backgroundColor)
            .navigationTitle(self.gameData.players.count > 0 ? "Players"~ : "")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if self.gameData.players.count > 0 {
                        EditButton()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    MainMenuButton()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
