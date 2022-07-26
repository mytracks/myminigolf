import SwiftUI
import Combine

struct NewHoleHolesView: View {
    @EnvironmentObject var player: Player
    @EnvironmentObject var gameData: GameData
    @Binding var selectedHole: Int?
    @Binding var value: Int?
    
    var body: some View {
        let allHoles = self.player.holes.keys
        let columns = [GridItem(.adaptive(minimum: 40))]
        
        return LazyVGrid(columns: columns) {
            ForEach(1..<self.gameData.numberHoles+1, id: \.self) { i in
                HoleNumberView(value: i, alreadyPlayed: allHoles.contains(i), selected: i == self.selectedHole)
                    .onTapGesture {
                        self.selectedHole = i
                        
                        if let selectedHole = self.selectedHole {
                            self.value = self.player.valueOf(hole: selectedHole)
                        }
                    }
            }
        }
    }
}

struct NewHoleView: View {
    @EnvironmentObject var player: Player
    @EnvironmentObject var gameData: GameData
    @Environment(\.presentationMode) var presentationMode
    
    @State var valueString = ""
    @State var value: Int?
    @State var hole: Int?
    @State var canSave = false
    
    func set(value: Int?) {
        self.value = value
        
        if let value = value {
            self.valueString = "\(value)"
        }
        else {
            self.valueString = ""
        }
    }
    
    func updateCanSave() {
        self.canSave = self.hole != nil
    }
    
    var body: some View {
        let canIncreaseHoles = self.value == nil || self.value! < self.gameData.maxShots
        let canDecreaseHoles = self.value != nil
        let increaseHolesColor = canIncreaseHoles ? Color.primary : Color.secondary
        let decreaseHolesColor = canDecreaseHoles ? Color.primary : Color.secondary
        
        return NavigationView {
            List {
                Section("Lane"~) {
                    let _ = self.hole // Workaround
                    NewHoleHolesView(selectedHole: $hole, value: $value)
                }
                Section("Strokes"~) {
                    HStack {
                        Image(systemName: "minus.circle")
                            .font(.largeTitle)
                            .foregroundColor(decreaseHolesColor)
                            .onTapGesture {
                                if let value = self.value {
                                    if value > 1 {
                                        self.set(value: value-1)
                                    }
                                    else {
                                        self.set(value: nil)
                                    }
                                }
                            }
                        Spacer()
                        if let value = value {
                            Text("\(value)")
                                .font(.title)
                                .bold()
                                .foregroundColor(.accentColor)
                        }
                        else {
                            Text("-")
                                .font(.title)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "plus.circle")
                            .font(.largeTitle)
                            .foregroundColor(increaseHolesColor)
                            .onTapGesture {
                                if let value = self.value {
                                    if value < self.gameData.maxShots {
                                        self.set(value: value+1)
                                    }
                                }
                                else {
                                    self.set(value: 1)
                                }
                            }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .onChange(of: self.hole) { hole in
                self.updateCanSave()
            }
            .navigationTitle(self.player.name)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel"~) {
                        presentationMode.wrappedValue.dismiss()
                    }
                } 
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save"~) {
                        if let hole = self.hole {
                            if let value = self.value {
                                self.player.add(hole: hole, value: value)
                            }
                            else {
                                self.player.remove(hole: hole)
                            }
                            self.gameData.saveState()
                        }
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                    .disabled(!canSave)
                }
            }
            .onAppear() {
                self.hole = self.player.getNextHole(gameData: self.gameData)
                
                if let hole = self.hole {
                    self.value = self.player.valueOf(hole: hole)
                }
            }
        }
    }
}

