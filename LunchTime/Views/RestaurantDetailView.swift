//
//  RestaurantDetailView.swift
//  LunchTime
//
//  Created by Josh Leung on 11/30/23.
//

import SwiftUI

struct RestaurantDetailView: View {
    @EnvironmentObject var viewModel: MainViewModel
    var item: Place = .generateData()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if let photos = item.photos {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(photos, id: \.self) { photo in
                                if let builtPhotoUrl = viewModel.getBuiltPhotoUrl(photo.name),
                                   let url = URL(string: builtPhotoUrl) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(5)
                                }
                            }
                        }
                    }
                }
                Text(item.displayName.text)
                    .font(.title)
                    .lineLimit(2)
                Text(item.formattedAddress)
                    .font(.title3)
                RatingStackView(rating: item.rating?.description,
                                ratingCount: item.userRatingCount?.description)
                if let hours = item.currentOpeningHours,
                   hours.openNow {
                    Text("Open")
                        .foregroundColor(.green)
                        .bold()
                } else {
                    Text("Closed")
                        .foregroundColor(.red)
                        .bold()
                }
                Text("\(item.weekdayDescriptions?[0] ?? "")")
                Text(item.editorialSummary?.text ?? "")
                    .font(.subheadline)
                if let link = URL(string: item.googleMapsUri) {
                    Link("Google Maps", destination: link)
                }
                Spacer()

            }
            .padding(10)
        }
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailView()
    }
}
