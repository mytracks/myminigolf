import SwiftUI
import Combine

struct NewLaneLanesView: View {
    @EnvironmentObject var player: Player
    @EnvironmentObject var gameData: GameData
    @Binding var selectedLane: Int?
    @Binding var value: Int?
    
    var body: some View {
        let allLanes = self.player.lanes.keys
        let columns = [GridItem(.adaptive(minimum: 40))]
        
        return LazyVGrid(columns: columns) {
            ForEach(1..<self.gameData.numberLanes+1, id: \.self) { i in
                LaneNumberView(value: i, alreadyPlayed: allLanes.contains(i), selected: i == self.selectedLane)
                    .onTapGesture {
                        self.selectedLane = i
                        
                        if let selectedLane = self.selectedLane {
                            self.value = self.player.valueOf(lane: selectedLane)
                        }
                    }
            }
        }
    }
}

struct NewLaneView: View {
    @EnvironmentObject var player: Player
    @EnvironmentObject var gameData: GameData
    @Environment(\.presentationMode) var presentationMode
    
    @State var valueString = ""
    @State var value: Int?
    @State var lane: Int?
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
        self.canSave = self.lane != nil
    }
    
    var body: some View {
        let canIncreaseLanes = self.value == nil || self.value! < self.gameData.maxStrokes
        let canDecreaseLanes = self.value != nil
        let increaseLanesColor = canIncreaseLanes ? Color.primary : Color.secondary
        let decreaseLanesColor = canDecreaseLanes ? Color.primary : Color.secondary
        
        return NavigationView {
            List {
                Section("Lane"~) {
                    let _ = self.lane // Workaround
                    NewLaneLanesView(selectedLane: $lane, value: $value)
                }
                Section("Strokes"~) {
                    HStack {
                        Image(systemName: "minus.circle")
                            .font(.largeTitle)
                            .foregroundColor(decreaseLanesColor)
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
                            .accessibilityIdentifier("newLaneIncreaseStrokes")
                            .font(.largeTitle)
                            .foregroundColor(increaseLanesColor)
                            .onTapGesture {
                                if let value = self.value {
                                    if value < self.gameData.maxStrokes {
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
            .onChange(of: self.lane) { lane in
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
                        if let lane = self.lane {
                            if let value = self.value {
                                self.player.add(lane: lane, value: value)
                            }
                            else {
                                self.player.remove(lane: lane)
                            }
                            self.gameData.saveState()
                        }
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                    .accessibilityIdentifier("newLaneIncreaseSave")
                    .disabled(!canSave)
                }
            }
            .onAppear() {
                self.lane = self.player.getNextLane(gameData: self.gameData)
                
                if let lane = self.lane {
                    self.value = self.player.valueOf(lane: lane)
                }
            }
        }
    }
}

