//
//  ContentView.swift
//  LunchTime
//
//  Created by Josh Leung on 11/17/23.
//

import SwiftUI

struct RestaurantList: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var selectedPlace: Place?


    var body: some View {
        NavigationView {
            List(viewModel.places) { item in
                RestaurantItem(item: item,
                               selectedPlace: $selectedPlace)
            }
            .listStyle(.plain)
        }
        .sheet(item: $selectedPlace) { place in
            RestaurantDetailView(item: place)
        }

    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        RestaurantList()
            .environmentObject(MainViewModel())
    }
}
