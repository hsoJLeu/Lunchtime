//
//  RestaurantDetailView.swift
//  LunchTime
//
//  Created by Josh Leung on 11/30/23.
//

import SwiftUI

struct RestaurantDetailView: View {
    var item: Place = .generateData()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text(item.formattedAddress)
                    .font(.title2)

                RatingStackView(rating: item.rating?.description,
                                ratingCount: item.userRatingCount?.description)

                Text(item.editorialSummary?.text ?? "")
                    .font(.caption)

                Spacer()
    //            if let link = URL(string: item.googleMapsUri) {
    //                Link("Google Maps", destination: link)
    //            }

            }
            .navigationTitle(item.displayName.text)
            .lineLimit(2)

        }

    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailView()
    }
}
