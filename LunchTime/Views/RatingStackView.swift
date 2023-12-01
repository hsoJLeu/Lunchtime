//
//  RatingStackView.swift
//  LunchTime
//
//  Created by Josh Leung on 11/30/23.
//

import SwiftUI

struct RatingStackView: View {
    var rating: String?
    var ratingCount: String?

    var body: some View {
        HStack {
            Image(systemName: Constants.starFill.rawValue)
                .foregroundColor(.green)
            Text("\(rating ?? "0")")
                .foregroundColor(.black)
                .font(.subheadline)
            Text("•")
                .foregroundColor(.black)
                .font(.title3)
            Text("(\(ratingCount ?? "0"))")
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
    }

    enum Constants: String {
        case starFill = "star.fill"
    }
}

struct RatingStackView_Previews: PreviewProvider {
    static var previews: some View {
        RatingStackView()
    }
}
