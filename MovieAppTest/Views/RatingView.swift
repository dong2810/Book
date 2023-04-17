//
//  RatingView.swift
//  MovieAppTest
//
//  Created by QuyNM on 4/3/23.
//

import SwiftUI

struct RatingView: View {
//    let title: String3
    @Namespace private var animation
    @State private var selectedMovie: Movie?
    @State private var showDetailView: Bool = false
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
//            Text(title)
//                .font(.title)
//                .fontWeight(.bold)
//                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(self.movies) { movie in
                        NavigationLink(destination: DetailView(show: $showDetailView, animation: animation, movie: movie)) {
                            LoadImage(movie: movie)
                                .frame(width: 272, height: 200)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.leading, movie.id == self.movies.first!.id ? 16 : 0)
                        .padding(.trailing, movie.id == self.movies.last!.id ? 16 : 0)
                    }
                }
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(movies: Movie.stubbedMovies)
    }
}
