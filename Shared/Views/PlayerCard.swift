import SwiftUI

struct PlayerCard: View {
    @EnvironmentObject var player: Player
    @EnvironmentObject var gameData: GameData
    
    @State private var isShowingNewHoleInput = false
    
    var body: some View {
        let showAllLanes = UserDefaults.standard.bool(forKey: "ShowAllLanes") ? self.gameData.numberHoles : nil
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
                    Text("\(self.player.playedNumberHoles)/\(self.gameData.numberHoles)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                HStack {
                    HolesCard(showAllLanes: showAllLanes)
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
            self.isShowingNewHoleInput = true
        }
        .sheet(isPresented: $isShowingNewHoleInput) {
            NewHoleView().environmentObject(self.player)
        }
    }
}
