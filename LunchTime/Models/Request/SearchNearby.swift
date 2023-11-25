//
//  Search.swift
//  LunchTime
//
//  Created by Josh Leung on 11/17/23.
//

import Foundation

struct SearchNearbyRequest: Encodable {
    var includedTypes: [String] = ["restaurant"]
    var maxResultCount: Int
    var locationRestriction: LocationRestriction
}

struct LocationRestriction: Encodable {
    var circle: Circle
}

struct Circle: Encodable {
    var center: Center
    var radius: Double
}

struct Center: Encodable {
    var latitude: Double
    var longitude: Double
}
