//
//  myminigolfApp.swift
//  Shared
//
//  Created by Dirk Stichling on 24.07.22.
//

import SwiftUI

@main
struct myminigolfApp: App {
    @State var gameData = GameData.loadState()
    
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .background(AppStyle.shared.backgroundColor)
                .environmentObject(self.gameData)
                .onAppear {
                    var defaults = [String:Any]()
                    defaults["ShowAllLanes"] = true
                    UserDefaults.standard.register(defaults: defaults)
                }
        }
    }
}
