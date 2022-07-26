import SwiftUI

struct LanesCard: View {
    @EnvironmentObject var player: Player
    var showAllLanes: Int?
    
    func allLanes(_ lanes: Int) -> some View {
        let numberRows = Int((lanes-1)/10)+1
        let numberColumns = Int((lanes-1)/numberRows)+1
        
        var columns = [GridItem]()
        for _ in 0..<numberColumns {
            columns.append(GridItem(.flexible(minimum: 20, maximum: 26)))
        }
        
        return LazyVGrid(columns: columns) {
            ForEach(1..<lanes+1, id: \.self) { i in
                StrokeView(value: self.player.lanes[i])
            }
        }
    }
    
    var playedLanes: some View {
        let columns = [GridItem(.adaptive(minimum: 20))]
        
        return LazyVGrid(columns: columns) {
            ForEach(Array(self.player.lanes.keys.sorted()), id: \.self) { lane in 
                if let value =  self.player.lanes[lane] {
                    StrokeView(value: value)
                }
            }
        }
    }
    
    var body: some View {
        Group {
            if let showAllLanes = self.showAllLanes {
                self.allLanes(showAllLanes)
            }
            else {
                self.playedLanes
            }
        }
    }
}
