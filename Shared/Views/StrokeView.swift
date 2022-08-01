import SwiftUI

struct StrokeView: View {
    let value: Int?
    
    var symbolName: String {
        if let value = self.value {
            return "\(value).circle.fill"
        }
        else {
            return "circle"
        }
    }
    
    var body: some View {
        Image(systemName: self.symbolName)
            .resizable()
            .frame(width: 26, height: 26, alignment: .center)
    }
}
