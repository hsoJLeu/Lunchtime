//
//  LunchTimeApp.swift
//  LunchTime
//
//  Created by Josh Leung on 11/17/23.
//

import SwiftUI

@main
struct LunchTimeApp: App {
    @StateObject var restaurantModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            ListMapScreen().environmentObject(restaurantModel)
        }
    }
}
