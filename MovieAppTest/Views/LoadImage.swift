//
//  LoadImage.swift
//  MovieAppTest
//
//  Created by đông on 08/04/2023.
//

import SwiftUI

struct LoadImage: View {
	let movie: Movie
    @StateObject var imageLoader = ImageLoader()
	
    var body: some View {
		ZStack {
			Rectangle()
				.fill(Color.gray.opacity(0.3))

			if self.imageLoader.image != nil {
				Image(uiImage: self.imageLoader.image ?? UIImage())
				.resizable()
				.aspectRatio(contentMode: .fill)
			}
		}
		.onAppear {
			self.imageLoader.loadImage(with: self.movie.backdropURL)
		}
	}
}
