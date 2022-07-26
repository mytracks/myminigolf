import SwiftUI

struct AboutView: View {
    @Binding var activeSheet: MainMenuButton.SheetType?
    
    var body: some View {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
        
        return NavigationView {
            VStack {
                VStack {
                    Text("myMinigolf Board")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                    Text(String(format: "Version %@ (%@)"~, version, build))
                }
                .padding()
                VStack {
                    Text("Made with"~)
                        .multilineTextAlignment(.center)
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text("and SwiftUI"~)
                        .multilineTextAlignment(.center)
                    Text("on Mac and iPad"~)
                        .multilineTextAlignment(.center)
                    Text("by Dirk Stichling"~)
                        .multilineTextAlignment(.center)
                }
                .padding()
                VStack {
                    let email = "dirk@stichling.info"
                    Text(.init(String(format: "Support: [%@](mailto:%@)"~, email, email)))
                }
                VStack {
                    Text(.init(String(format: "Source Code is available on [GitHub](%@) under the MIT license."~, "https://github.com/mytracks/myminigolf")))
                        .multilineTextAlignment(.center)
                }
                .padding()
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close") {
                        self.activeSheet = nil
                    }
                }
            }
        }
    }
}
