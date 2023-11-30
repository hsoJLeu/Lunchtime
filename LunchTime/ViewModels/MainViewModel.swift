//
//  RestaurantViewModel.swift
//  LunchTime
//
//  Created by Josh Leung on 11/20/23.
//

import Foundation
import MapKit
import Combine

@MainActor
class MainViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var places: [Place] = []
    @Published var viewState: ViewState  = .list

    enum ViewState: Int {
        case map
        case list
    }

    private var location: LocationClient
    private var api: ApiService

    @Published var currentLocation: MKCoordinateRegion?
    
    private var cancellables = Set<AnyCancellable>()

    init(location: LocationClient = .shared, api: ApiService = .init()) {
        self.location = location
        self.api = api

        setupLocationPublisher()
    }

    private func setupLocationPublisher() {
        location.$location.sink { location in
           if let coordinate = location?.coordinate {
               let span = MKCoordinateSpan(latitudeDelta: 0.05,
                                           longitudeDelta: 0.05)
               let locationCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                       longitude: coordinate.longitude)
               self.currentLocation = MKCoordinateRegion(center: locationCoordinate,
                                                         span: span)
           }
        }.store(in: &cancellables)
    }

    func getNearbyRestaurants() async {
        if location.locationExists() {
            do {
                if let location = location.location?.coordinate {
                    let center = Center(latitude: location.latitude, longitude: location.longitude)
                    let data = try await api.getNearbySearchRequest(locale: center)
                    
                    objectWillChange.send()
                    self.places = data
                }
            } catch {
                // TODO: Implement error handling
                print("\(error)")
            }
        } else {
            location.requestUserLocation()
        }
    }

    func getTextSearch() async {
        do {
            guard !searchQuery.isEmpty,
                  searchQuery.count >= 3 else {
                // TODO: Implement error handling
                print("Enter 3 or more characters to search")
                return
            }

            let data  = try await api.getTextSearchRequest(query: searchQuery)

            self.places = data
        } catch {
            // TODO: Implement error handling
            print("\(error)")
        }
    }

    func getBuiltPhotoUrl(_ uri: String?) -> String? {
        guard let uri = uri else { return nil }

        return api.buildPlacePhotoRequest(placeUri: uri)?.absoluteString
    }
}
