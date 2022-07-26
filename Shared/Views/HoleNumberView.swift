import SwiftUI

struct HoleNumberView: View {
    let value: Int
    let alreadyPlayed: Bool
    let selected: Bool
    
    var body: some View {
        let symbolName = self.selected ? "\(self.value).square.fill" : "\(self.value).square"
        var color = Color.primary
        
        if self.selected {
            color = Color.accentColor
        }
        else if self.alreadyPlayed {
            color = Color.secondary
        }
        
        return Image(systemName: symbolName)
            .font(.largeTitle)
            .foregroundColor(color)
    }
}
