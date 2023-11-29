//
//  ContentDetailView.swift
//  LunchTime
//
//  Created by Josh Leung on 11/24/23.
//

import SwiftUI

struct RestaurantRowItem: View {
    @EnvironmentObject var store: PlacesStore
    @EnvironmentObject var viewModel: MainViewModel

    var item: ItemDetail

    var body: some View {
        Button {
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(.white)
                    .shadow(radius: 1, x: 0, y: 6)
                    .padding(
                        EdgeInsets(
                            top: 1,
                            leading: 1,
                            bottom: 1,
                            trailing: 1))
                HStack {
                    // TODO: Replace with cached images
                    if let imageUrl = getBuiltImageUrl(item.itemImageUrl) {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .padding(EdgeInsets(top: 0,
                                                    leading: 10,
                                                    bottom: 0,
                                                    trailing: 0))
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 64,
                               height: 72)
                        .cornerRadius(10)
                    } else {
                        Image(systemName: Constants.forkKnife.rawValue)
                            .frame(width: 64,
                                   height: 72)
                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Text(item.name)
                                .font(.title3)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(.black)
                            Spacer(minLength: 10)
                            Button {
                                if store.contains(item) {
                                    store.remove(item)
                                } else {
                                    store.add(item)
                                }

                            } label: {
                                store.contains(item) ?
                                Image(systemName: Constants.bookmarkFill.rawValue)
                                    .foregroundColor(.secondaryColor) :
                                Image(systemName: Constants.bookmark.rawValue)
                                    .foregroundColor(.black)
                            }
                        }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))

                        HStack {
                            Image(systemName: Constants.starFill.rawValue)
                                .foregroundColor(.green)
                            Text("\(item.rating?.description ?? "")")
                                .foregroundColor(.black)
                                .font(.subheadline)
                            Text("•")
                                .foregroundColor(.black)
                                .font(.title3)
                            Text("(\(item.reviews ?? 0))")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                        Text(item.supportingText ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }.padding(10)
                }
            }
        }
        .padding(EdgeInsets(top: 10,
                            leading: 15,
                            bottom: 10,
                            trailing: 15))
        .listRowSeparator(.hidden)
    }

    enum Constants: String {
        case bookmarkFill = "bookmark.fill"
        case bookmark = "bookmark"
        case starFill = "star.fill"
        case forkKnife = "fork.knife"
    }
}

extension RestaurantRowItem {
    func getBuiltImageUrl(_ uri: String?) -> String? {
        guard let uri = uri else { return nil }

        return viewModel.getBuiltPhotoUrl(uri)
    }
}

struct RestaurantRowItem_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRowItem(item: .make())
    }
}
