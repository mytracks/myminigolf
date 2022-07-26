import SwiftUI

struct NewPlayerButton: View {
    @EnvironmentObject var gameData: GameData
    
    @State private var isPresented = false
    @State private var name: String = ""
    @FocusState private var nameInFocus: Bool
    
    var body: some View {
        Image(systemName: "plus.circle.fill")
            .font(.largeTitle)
            .foregroundColor(.secondary)
            .onTapGesture {
                self.isPresented = true            
            }
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    VStack {
                        HStack {
                            Text("Name:"~)
                            TextField("", text: $name)
                                .textFieldStyle(.roundedBorder)
                                .focused($nameInFocus)
                                .onAppear {
                                    self.name = ""
                                    DispatchQueue.main.async {
                                        self.nameInFocus = true
                                    }
                                }
                        }
                        Spacer()
                    }
                    .padding()
                    .navigationTitle("New Player"~)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel"~, role: .cancel) {
                                self.isPresented = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add"~) {
                                self.gameData.add(player: self.name)
                                self.isPresented = false
                            }
                            .disabled(self.name.count == 0)
                        }
                    }
                }
            }
    }
}
