//
//  MovieCardView.swift
//  MovieAppTest
//
//  Created by QuyNM on 4/3/23.
//

import SwiftUI

struct MovieCardView: View {
    let movies: [Movie]
    @ObservedObject var imageLoader = ImageLoader()
	@Namespace private var animation

//	@State private var carouselMode: Bool = false
	@State private var showDetailView: Bool = false
	@State private var selectedMovie: Movie?
	@State private var animateCurrentMovie: Bool = false

	var body: some View {
		if #available(iOS 15.0, *) {
			ForEach(self.movies) { movie in
				GeometryReader { proxy in
					let size = proxy.size
					let rect = proxy.frame(in: .named("SCROLLVIEW"))
					HStack(spacing: -25) {
						VStack(alignment: .leading, spacing: 6) {
							Text(movie.title)
								.font(.title3)
								.fontWeight(.semibold)

							ForEach(movie.directors ?? [MovieCrew]()) { crew in
								Text(crew.name)
							}

							ratingText(movie)
						}
						.frame(width: size.width / 2, height: size.height * 0.8)
						.background {
							RoundedRectangle(cornerRadius: 10, style: .continuous)
								.fill(.white)
								.shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
								.shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
						}
						.zIndex(1)
//						.offset(x: -20)

						if !(showDetailView && selectedMovie?.id == movie.id) {
							LoadImage(movie: movie)
								.frame(width: size.width / 2)
								.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
								.matchedGeometryEffect(id: movie.id, in: animation)
								.shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
								.shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
								.frame(maxWidth: .infinity, maxHeight: .infinity)
						}
					}
					.rotation3DEffect(.init(degrees: convertOffsetToRotation(rect)), axis: (x: 1, y: 0, z: 0), anchor: .bottom, anchorZ: 1, perspective: 0.8)
					.frame(width: size.width)
					.onTapGesture {
						withAnimation(.easeInOut(duration: 0.2)) {
							animateCurrentMovie = true
							selectedMovie = movie
						}
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
							withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
								showDetailView = true
							}
						}
					}
				}
			}
			//			.background {
			//				ScrollviewDetector(carouselMode: $carouselMode, totalCardCount: self.movies.count)
			//			}
			.overlay {
				if let selectedMovie = selectedMovie, showDetailView {
					DetailView(show: $showDetailView, animation: animation, movie: selectedMovie)
						.transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
				}
			}
			.onChange(of: showDetailView) { newValue in
				if !newValue {
					withAnimation(.easeInOut(duration: 0.15).delay(0.3)) {
						animateCurrentMovie = false
					}
				}
			}
			.frame(height: 220)
		} else {
			// Fallback on earlier versions
		}
	}

	func convertOffsetToRotation(_ rect: CGRect) -> CGFloat {
		let cardHeight = rect.height + 20
		let minY = rect.minY - 20
		let progress = minY < 0 ? (minY / cardHeight) : 0
		let constrainedProgress = min(-progress, 1.0)
		return constrainedProgress * 90
	}

	@ViewBuilder
	func ratingText(_ movie: Movie) -> some View {
		HStack {
			if !movie.ratingText.isEmpty {
				Text(movie.ratingText).foregroundColor(.yellow)
			}
			Text(movie.scoreText)
		}
	}
}

struct MovieCardView_Previews: PreviewProvider {
    static var previews: some View {
		MovieCardView(movies: Movie.stubbedMovies)
    }
}
