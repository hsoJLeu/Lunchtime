//
//  Place.swift
//  LunchTime
//
//  Created by Josh Leung on 11/17/23.
//

import Foundation
import SwiftUI

struct Places: Decodable {
    var places: [Place]?
}

struct Place: Decodable, Identifiable {
    var id: String
    var displayName: LocalizedText
    var formattedAddress: String
    var shortFormattedAddress: String
    var location: Coordinate
    var rating: Float?
    var userRatingCount: Int?
    var weekdayDescriptions: [String]?
    var googleMapsUri: String

    var regularOpeningHours: OpeningHours?
    var currentOpeningHours: OpeningHours?
    var editorialSummary: LocalizedText?


    struct Coordinate: Decodable {
        var latitude: Double
        var longitude: Double
    }

    struct LocalizedText: Decodable {
        var text: String
    }
}

struct OpeningHours: Decodable {
      var periods: [Period]
      var openNow: Bool

    struct Period: Decodable {
        var opening: Point
        var closing: Point
    }

    struct Point: Decodable {
        var date: Date.ISO8601FormatStyle
        var day: Int
        var hour: Int
        var minute: Int
    }
}

extension Place {
    func toWrapper() -> ItemDetail {
        return ItemDetail(id: self.id,
                          itemImageUrl: "",
                          name: self.displayName.text,
                          rating: self.rating,
                          reviews: 1200,
                          supportingText: self.editorialSummary?.text,
                          bookmarked: false)
    }
}

extension Place {
    static func generateData() -> Place {
        Place(id: "000",
              displayName: LocalizedText(text: "Little Original Joes"),
              formattedAddress: "212 Main Street",
              shortFormattedAddress: "",
              location: Coordinate(latitude: 37.33233141, longitude: -122.03121860),
              rating: 4.0,
              userRatingCount: 40,
              googleMapsUri: "",
              editorialSummary: LocalizedText(text: "Iconic pizzeria chain known for pasta and pizza"))
    }

    static func generateData(for nums: Int) -> [Place] {
        var result:[Place] = []
        for num in 0..<nums {
            let place = Place(id: "\(num)",
                  displayName: LocalizedText(text: "Little Original Joes \(num)"),
                  formattedAddress: "\(num) Main Street",
                  shortFormattedAddress: "",
                              location: Coordinate(latitude: 37.33233141, longitude: -122.03121860),
                  rating: 4.0,
                  userRatingCount: 40,
                  googleMapsUri: "",
                  editorialSummary: LocalizedText(text: "Iconic pizzeria chain known for pasta and pizza"))
            result.append(place)
        }
        return result
    }
}
