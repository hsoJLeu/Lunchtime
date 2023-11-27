//
//  ContentView.swift
//  LunchTime
//
//  Created by Josh Leung on 11/17/23.
//

import SwiftUI

struct RestaurantList: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.places) { item in
                NavigationLink {
                    // TODO: navigate to detail view
                    Text("Implement detail view")
                } label: {
                    RestaurantRowItem(item: item.toWrapper())
                }
            }
        }
//        .navigationDestination(for: ItemDetail.self) { item in
//            ItemRow(item: item)
//        }

    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        RestaurantList(viewModel: MainViewModel())
    }
}
