//
//  ContentView.swift
//  MovieAppTest
//
//  Created by QuyNM on 3/23/23.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var nowPlayingState = MovieListState()

    var body: some View {
		HomeBook()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
