//
//  HomeBook.swift
//  MovieAppTest
//
//  Created by QuyNM on 3/28/23.
//

import SwiftUI

struct HomeBook: View {
    @State private var activeTag = "Now Playing"
    @State private var carouselMode: Bool = false
    @Namespace private var animation
    let movies: [Movie]
    let movie: Movie
    let movieId: Int = 0
    @State private var showDetailView: Bool = false
    @State private var selectedMovie: Movie?
    @State private var animateCurrentMovie: Bool = false
    
    let imageLoader = ImageLoader()
    @ObservedObject private var nowPlayingState = MovieListState()
    @ObservedObject private var upcomingState = MovieListState()
    @ObservedObject private var topRatedState = MovieListState()
    @ObservedObject private var popularState = MovieListState()
    @ObservedObject private var movieDetailState = MovieDetailState()
    
    var body: some View {
        if #available(iOS 15.0, *) {
            VStack(spacing: 15) {
                HStack {
                    Text("Home")
                        .font(.largeTitle.bold())
                    
                    Text("Recommend")
                        .fontWeight(.semibold)
                        .padding(.leading, 15)
                        .foregroundColor(.gray)
                        .offset(y: 2)
                    
                    Spacer(minLength: 10)
                    Menu {
                        Button("Toggle ") {
                            
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: -90))
                            .foregroundColor(.gray)
                    }
                }
                
                tagView()
                
                GeometryReader {
                    let size = $0.size
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 35) {
                            ForEach(self.movies) { movie in
                                MovieCardView1(movie, imageLoader)
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
                        .padding(.horizontal, 15)
                        .padding(.vertical, 15)
                        .padding(.bottom, bottomPadding(size))
                        .background {
                            ScrollviewDetector(carouselMode: $carouselMode, totalCardCount: self.movies.count)
                        }
                    }
                    .coordinateSpace(name: "SCROLLVIEW")
                }
                .padding(.top, 15)
            }
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
        } else {
            // Fallback on earlier versions
        }
    }
    
    func bottomPadding(_ size: CGSize = .zero) -> CGFloat {
        let cardHeight: CGFloat = 220
        let scrollviewHeight: CGFloat = size.height
        
        return scrollviewHeight - cardHeight - 40
    }
    
    @ViewBuilder
    func MovieCardView1(_ movie: Movie, _ imageLoader: ImageLoader) -> some View {
        GeometryReader {
            let size = $0.size
            let rect = $0.frame(in: .named("SCROLLVIEW"))
            
            HStack(spacing: -25) {
                if #available(iOS 15.0, *) {
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
                    .offset(x: animateCurrentMovie && selectedMovie?.id == movie.id ? -20 : 0)
                } else {
                    // Fallback on earlier versions
                }
                ZStack {
                    if !(showDetailView && selectedMovie?.id == movie.id) {
                        LoadImage(movie: movie)
                            .frame(width: size.width / 2, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .matchedGeometryEffect(id: movie.id, in: animation)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    self.imageLoader.loadImage(with: self.movie.backdropURL)
                }
            }
            .frame(width: size.width)
            .rotation3DEffect(.init(degrees: convertOffsetToRotation(rect)), axis: (x: 1, y: 0, z: 0), anchor: .bottom, anchorZ: 1, perspective: 0.8)
        }
        .frame(height: 220)
    }
    
    func convertOffsetToRotation(_ rect: CGRect) -> CGFloat {
        let cardHeight = rect.height + 20
        let minY = rect.minY - 20
        let progress = minY < 0 ? (minY / cardHeight) : 0
        let constrainedProgress = min(-progress, 1.0)
        return constrainedProgress * 90
    }
    
    @ViewBuilder
    func tagView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    if #available(iOS 15.0, *) {
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background {
                                if activeTag == tag {
                                    Capsule()
                                        .fill(Color.blue)
                                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                } else {
                                    Capsule()
                                        .fill(.gray.opacity(0.2))
                                }
                            }
                            .foregroundColor(activeTag == tag ? Color.white : Color.gray)
                            .onTapGesture {
                                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                                    activeTag = tag
                                }
                            }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            .padding(.horizontal, 15)
        }
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

var tags: [String] = ["Now Playing", "Upcoming", "Top Rated", "Popular"]

struct HomeBook_Previews: PreviewProvider {
    static var previews: some View {
        HomeBook(movies: Movie.stubbedMovies, movie: Movie.stubbedMovie)
    }
}
