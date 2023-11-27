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
            NavigationStack {
                ZStack(alignment: .bottom) {
                    if restaurantModel.viewState == .list {
                        RestaurantList(viewModel: restaurantModel)
                    } else {
                        MapView(viewModel: restaurantModel)
                    }

                    Button {
                        if restaurantModel.viewState == .list {
                            restaurantModel.viewState = .map
                        } else {
                            restaurantModel.viewState = .list
                        }
                    } label: {
                        Label {
                            restaurantModel.viewState == .list ? Text("Map").foregroundColor(.white) : Text("List").foregroundColor(.white)
                        } icon: {
                            restaurantModel.viewState == .list ? Image(systemName: "list.bullet")
                                .foregroundColor(.white) : Image(systemName: "map").foregroundColor(.white)
                        }
                    }
                    .frame(width: 113, height: 48)
                    .background(.secondaryColor, in: Capsule())
                    .padding()
                }
            }
            .onAppear {
                restaurantModel.getCurrentLocation()

                Task {
                    await restaurantModel.getNearbyRestaurants()
                }
            }
            .searchable(text: $restaurantModel.searchQuery)
            .onSubmit(of: .search) {
                Task {
                    await restaurantModel.getTextSearch()
                }
            }
        }
    }
}
