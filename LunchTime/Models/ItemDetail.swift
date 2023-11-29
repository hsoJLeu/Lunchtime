//
//  ItemDetail.swift
//  LunchTime
//
//  Created by Josh Leung on 11/24/23.
//

import Foundation

struct ItemDetail: Codable, Identifiable, Hashable {
    var id: String
    var itemImageUrl: String?
    var name: String
    var rating: Float?
    var reviews: Int?
    var supportingText: String?
    var bookmarked: Bool // TODO: Implement computed variable to check bookmark store
}

extension ItemDetail {
    static func make() -> ItemDetail {
        return ItemDetail(id: "000",
                          itemImageUrl: nil,
                          name: "Little Original Joe's",
                          rating: 4.3,
                          reviews: 2300,
                          supportingText: "Iconic pizzeria chain known for pasta and pizza",
                          bookmarked: false)
    }
}
