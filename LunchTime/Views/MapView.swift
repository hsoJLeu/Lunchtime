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
    @State private var selectedPlace: Place?
    @State private var isPinSelected: Bool = false
    @State private var localCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 44.96724,
                                                                                                 longitude: -103.77156),
                                                                                      span: MKCoordinateSpan(latitudeDelta: 20.0,
                                                                                                             longitudeDelta: 20.0))

    var body: some View {
        Map(coordinateRegion: $localCoordinateRegion,
            annotationItems: viewModel.places) { place in

            // TODO: Show item detail only on pin selected
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: place.location.latitude,
                                                             longitude: place.location.longitude)) {
                if isPinSelected {
                    VStack {
                        RestaurantItem(item: place,
                                       selectedPlace: $selectedPlace)
                            .foregroundColor(.black)
                            .frame(width: 300)
                            .sheet(item: $selectedPlace) { place in
                                RestaurantDetailView(item: place)
                            }
                        Image(uiImage: UIImage(named: Constants.pinSelected)!)
                    }
                    .onTapGesture {
                        self.isPinSelected.toggle()
                    }
                } else {
                    Image(uiImage: UIImage(named: Constants.pinResting)!)
                        .onTapGesture {
                            self.isPinSelected.toggle()
                        }
                }
            }
        }
            .onReceive(viewModel.$currentLocation) { _ in
                if let coordinateRegion = viewModel.currentLocation {
                    self.localCoordinateRegion = coordinateRegion
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
