import SwiftUI

struct PlayerCard: View {
    @EnvironmentObject var player: Player
    @EnvironmentObject var gameData: GameData
    
    @State private var isShowingNewLaneInput = false
    
    var body: some View {
        let showAllLanes = UserDefaults.standard.bool(forKey: "ShowAllLanes") ? self.gameData.numberLanes : nil
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
                    Text("\(self.player.playedNumberLanes)/\(self.gameData.numberLanes)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                HStack {
                    LanesCard(showAllLanes: showAllLanes)
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
        .accessibilityIdentifier("playerCard:"+self.player.name)
        .onTapGesture {
            self.isShowingNewLaneInput = true
        }
        .sheet(isPresented: $isShowingNewLaneInput) {
            NewLaneView().environmentObject(self.player)
        }
    }
}
