//
//  RestaurantViewModel.swift
//  LunchTime
//
//  Created by Josh Leung on 11/20/23.
//

import Foundation
import MapKit

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

    var currentLocation: MKCoordinateRegion = .init()

    init(location: LocationClient = .shared, api: ApiService = .init()) {
        self.location = location
        self.api = api
    }

    func getCurrentLocation() {
        guard let location = location.location else {
            debugPrint("Location client does not have location data yet. Please try again")
            return
        }

        objectWillChange.send()
        self.currentLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                                                 longitude: location.coordinate.longitude),
                                                  span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }

    func getNearbyRestaurants() async {
        do {
            let location = currentLocation.center
            let center = Center(latitude: location.latitude, longitude: location.longitude)
            let data = try await api.getNearbySearchRequest(locale: center)

            objectWillChange.send()
            self.places = data
        } catch {
            // TODO: Implement error handling
            print("\(error)")
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
