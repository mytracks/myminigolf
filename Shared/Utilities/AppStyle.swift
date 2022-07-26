import SwiftUI

class AppStyle {
    public static let shared = AppStyle()
    
    public var backgroundColor: Color {
        let uiColor = UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ?
            UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1) :
            UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        }
        return Color(uiColor: uiColor)
    }

    public var cardBackgroundColor: Color {
        let uiColor = UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ?
            UIColor(red: 0.03, green: 0.03, blue: 0.03, alpha: 1) :
            UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
        return Color(uiColor: uiColor)
    }
}
