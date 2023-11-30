//
//  ContentView.swift
//  LunchTime
//
//  Created by Josh Leung on 11/17/23.
//

import SwiftUI

struct RestaurantList: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isPresented: Bool = false
    var body: some View {
        List(viewModel.places) { item in
            RestaurantItem(item: item,
                           isPresented: $isPresented)
            .sheet(isPresented: $isPresented) {
                    RestaurantDetailView(item: item)
            }
        }
        .listStyle(.plain)
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        RestaurantList()
            .environmentObject(MainViewModel())
    }
}
