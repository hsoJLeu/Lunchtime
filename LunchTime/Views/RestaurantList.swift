//
//  ContentView.swift
//  LunchTime
//
//  Created by Josh Leung on 11/17/23.
//

import SwiftUI

struct RestaurantList: View {
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        List(viewModel.places) { item in
            RestaurantRowItem(item: item.toWrapper())
        }
        .listStyle(.plain)
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        RestaurantList().environmentObject(MainViewModel())
    }
}
