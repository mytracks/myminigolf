import SwiftUI

struct HistoryPlayerCard: View {
    @EnvironmentObject var player: Player
    @EnvironmentObject var entry: GameHistoryEntry
    @EnvironmentObject var savedGame: SavedGame
    
    var body: some View {
        return Group {
            VStack {
                HStack {
                    Text(self.player.name)
                        .font(.title)
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(self.player.sum)")
                        .font(.title)
                        .foregroundColor(.primary)
                }
                HStack {
                    Text("\(self.player.playedNumberLanes)/\(self.savedGame.numberLanes)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                HStack {
                    LanesCard(showAllLanes: self.savedGame.numberLanes)
                    Spacer()
                }
            }
            .frame(minWidth: 100, idealWidth: 200, maxWidth: 1024, minHeight: 60, idealHeight: nil, maxHeight: nil, alignment: .center)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .background(.clear)
                    .foregroundColor(AppStyle.shared.cardBackgroundColor)
                    .shadow(color: .secondary, radius: 2.5, x: 1, y: 1)
            )
        }
    }
}
