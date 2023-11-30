//
//  ContentDetailView.swift
//  LunchTime
//
//  Created by Josh Leung on 11/24/23.
//

import SwiftUI

struct RestaurantItem: View {
    @EnvironmentObject var store: BookmarkStore
    @EnvironmentObject var viewModel: MainViewModel

    var item: Place
    @Binding var selectedPlace: Place?

    var body: some View {
        Button {
            self.selectedPlace = item
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(.white)
                    .shadow(radius: 2, x: 0, y: 6)
                    .padding(
                        EdgeInsets(
                            top: 1,
                            leading: 1,
                            bottom: 1,
                            trailing: 1))
                HStack {
                    // TODO: Replace with cached images
                    if let imageUrl = getBuiltImageUrl(item.photos?.first?.name) {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 64,
                               height: 72)
                        .cornerRadius(5)
                    } else {
                        Image(systemName: Constants.forkKnife.rawValue)
                            .frame(width: 64,
                                   height: 72)
                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Text(item.displayName.text)
                                .font(.title3)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(.black)
                            Spacer(minLength: 10)
                            Button {
                                if store.contains(item.id) {
                                    store.remove(item.id)
                                } else {
                                    store.add(item.id)
                                }
                            } label: {
                                store.contains(item.id) ?
                                Image(systemName: Constants.bookmarkFill.rawValue)
                                    .foregroundColor(.secondaryColor) :
                                Image(systemName: Constants.bookmark.rawValue)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(EdgeInsets(top: 5,
                                             leading: 0,
                                             bottom: 0,
                                             trailing: 5))

                        RatingStackView(rating: item.rating?.description,
                                        ratingCount: item.userRatingCount?.description)
                        Text(item.editorialSummary?.text ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    } // VStack

                } // HStack container
                .padding(10)
            } // ZStack
        }
        .padding(EdgeInsets(top: 5,
                            leading: 15,
                            bottom: 10,
                            trailing: 5))
        .listRowSeparator(.hidden)

    }

    enum Constants: String {
        case bookmarkFill = "bookmark.fill"
        case bookmark = "bookmark"
        case starFill = "star.fill"
        case forkKnife = "fork.knife"
    }
}

extension RestaurantItem {
    func getBuiltImageUrl(_ uri: String?) -> String? {
        guard let uri = uri else { return nil }

        return viewModel.getBuiltPhotoUrl(uri)
    }
}

struct RestaurantRowItem_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantItem(item: .generateData(),
                       selectedPlace: .constant(Place.generateData()))
            .environmentObject(BookmarkStore())
    }
}
