//
//  ContentDetailView.swift
//  LunchTime
//
//  Created by Josh Leung on 11/24/23.
//

import SwiftUI

struct RestaurantRowItem: View {
    var item: ItemDetail
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .fill(.white)
                .shadow(radius: 1, x: 0, y: 8)
                .padding(EdgeInsets(top: 5,
                                    leading: 5,
                                    bottom: 5,
                                    trailing: 5))

            HStack {
                // TODO: Replace with cached images
                if let imageUrl = item.itemImageUrl {
                    AsyncImage(url: URL(string: imageUrl))
                        .frame(width: 64, height: 72)
                } else {
                    Image(systemName: "fork.knife")
                        .frame(width: 64,
                               height: 72)
                }

                VStack(alignment: .leading) {
                    HStack {
                        Text(item.name)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .font(.title2)
                        Spacer(minLength: 10)
                        Button {
                            // TODO: Implement bookmark store
                            debugPrint("Implement bookmark store")
                        } label: {
                            item.bookmarked ?
                            Image(systemName: "bookmark.fill")
                                .foregroundColor(.secondaryColor) :
                            Image(systemName: "bookmark")
                                .foregroundColor(.black)
                        }
                    }

                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.green)
                        Text("\(item.rating?.description ?? "") • (\(item.reviews ?? 0))")
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    Text(item.supportingText ?? "")
                        .font(.caption)
                }
            }
            .padding(10)
        }
    }
}

struct RestaurantRowItem_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRowItem(item: .make())
    }
}
