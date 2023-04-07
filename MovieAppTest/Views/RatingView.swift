//
//  RatingView.swift
//  MovieAppTest
//
//  Created by QuyNM on 4/3/23.
//

import SwiftUI

struct RatingView: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            if !movie.ratingText.isEmpty {
                Text(movie.ratingText).foregroundColor(.yellow)
            }
            Text(movie.scoreText)
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(movie: Movie.stubbedMovie)
    }
}
