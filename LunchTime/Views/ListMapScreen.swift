//
//  MainView.swift
//  LunchTime
//
//  Created by Josh Leung on 11/29/23.
//

import SwiftUI
import UIKit

struct ListMapScreen: View {
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                if viewModel.viewState == .list {
                    RestaurantList()
                } else {
                    MapView()
                }

                Button {
                    if viewModel.viewState == .list {
                        viewModel.viewState = .map
                    } else {
                        viewModel.viewState = .list
                    }
                } label: {
                    Label {
                        viewModel.viewState == .list ? Text(Constants.map).foregroundColor(.white) : Text(Constants.list).foregroundColor(.white)
                    } icon: {
                        viewModel.viewState == .list ? Image(systemName: Constants.mapFill)
                            .foregroundColor(.white) : Image(systemName: Constants.listBullet)
                            .foregroundColor(.white)
                    }
                }
                .frame(width: Constants.ctaButtonWidth,
                       height: Constants.ctaButtonHeight)
                .background(.secondaryColor, in: Capsule())
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(uiImage: UIImage(named: Constants.atLogo)!)
                }
            }
            .onAppear {
                viewModel.getCurrentLocation()

                Task {
                    await viewModel.getNearbyRestaurants()
                }
            }
            .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always))
            .onSubmit(of: .search) {
                Task {
                    await viewModel.getTextSearch()
                }
            }
        }
    }

    struct Constants  {
        static let ctaButtonWidth: CGFloat = 113
        static let ctaButtonHeight: CGFloat = 48
        static let map = "Map"
        static let list = "List"
        static let atLogo = "ATLogo"
        static let mapFill = "map.fill"
        static let listBullet = "list.bullet"
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ListMapScreen().environmentObject(MainViewModel())
    }
}
