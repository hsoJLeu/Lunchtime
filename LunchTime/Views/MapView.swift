//
//  MapView.swift
//  LunchTime
//
//  Created by Josh Leung on 11/20/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        Map(coordinateRegion: $viewModel.currentLocation,
            annotationItems: viewModel.places) { place in

            // TODO: Show item detail only on pin selected
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: place.location.latitude,
                                                             longitude: place.location.longitude)) {
                VStack {
                    RestaurantRowItem(item: place.toWrapper())
                        .frame(width: 250, height: 104)
                    // TODO: Replace with supplied asset
                    Image(systemName: "pin")
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    
    static var previews: some View {
        MapView(viewModel: MainViewModel())
    }
}
