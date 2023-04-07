//
//  ContentView.swift
//  MovieAppTest
//
//  Created by QuyNM on 3/23/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeBook(movies: Movie.stubbedMovies, movie: Movie.stubbedMovie)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
