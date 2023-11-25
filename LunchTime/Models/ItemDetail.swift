//
//  ItemDetail.swift
//  LunchTime
//
//  Created by Josh Leung on 11/24/23.
//

import Foundation

struct ItemDetail: Identifiable {
    var id: String
    var itemImageUrl: String
    var name: String
    var rating: Float?
    var reviews: Int?
    var supportingText: String?
    var bookmarked: Bool 
}

extension ItemDetail {
    static func make() -> ItemDetail {
        return ItemDetail(id: "000",
                          itemImageUrl: "",
                          name: "Little Original Joe's",
                          rating: 4.3,
                          reviews: 2300,
                          supportingText: "Iconic pizzeria chain known for pasta and pizza",
                          bookmarked: false)
    }
}
