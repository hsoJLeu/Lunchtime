//
//  LunchTimeApp.swift
//  LunchTime
//
//  Created by Josh Leung on 11/17/23.
//

import SwiftUI

@main
struct LunchTimeApp: App {
    @StateObject var viewModel = MainViewModel()
    @StateObject var bookmarks = BookmarkStore()

    var body: some Scene {
        WindowGroup {
            ListMapScreen()
                .environmentObject(viewModel)
                .environmentObject(bookmarks)
                .onReceive(viewModel.$currentLocation) { _ in
                    
                    Task {
                        await viewModel.getNearbyRestaurants()
                    }
                }
        }
    }
}
