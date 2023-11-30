//
//  MapView.swift
//  LunchTime
//
//  Created by Josh Leung on 11/20/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isPresented: Bool = false
    @State private var isPinSelected: Bool = false

    var body: some View {
        Map(coordinateRegion: $viewModel.currentLocation,
            annotationItems: viewModel.places) { place in

            // TODO: Show item detail only on pin selected
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: place.location.latitude,
                                                             longitude: place.location.longitude)) {
                VStack {
                    if isPinSelected {
                        RestaurantItem(item: place,
                                       isPresented: $isPresented)
                        .sheet(isPresented: $isPresented) {
                            RestaurantDetailView(item: place)
                        }
                            .foregroundColor(.black)
                            .frame(width: 300)
                    }

                    Image(uiImage: UIImage(named: Constants.pinSelected)!)
                        .onTapGesture {
                            self.isPinSelected.toggle()
                        }
                }
            }
        }
    }

    struct Constants {
        static let pinSelected = "pin-selected"
        static let pinResting = "pin-resting"

    }
}

struct MapView_Previews: PreviewProvider {
    
    static var previews: some View {
        MapView()
            .environmentObject(MainViewModel())
    }
}
