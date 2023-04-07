//
//  MovieCardView.swift
//  MovieAppTest
//
//  Created by QuyNM on 4/3/23.
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let rect = $0.frame(in: .named("SCROLLVIEW"))
            
            HStack(spacing: -25) {
                if #available(iOS 15.0, *) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(movie.title)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        if movie.crew != nil && movie.crew!.count > 0 {
                            VStack(alignment: .leading, spacing: 4) {
                                if movie.directors != nil && movie.directors!.count > 0 {
                                    Text("Director(s)").font(.headline)
                                    ForEach(self.movie.directors!.prefix(2)) { crew in
                                        Text(crew.name)
                                            .font(.caption)
                                            .foregroundColor(Color.gray)
                                    }
                                    
                                }
                            }
                        }
                        HStack {
                            if !movie.ratingText.isEmpty {
                                Text(movie.ratingText).foregroundColor(.yellow)
                            }
                            Text(movie.scoreText)
                        }
                    }
                    .frame(width: size.width / 2, height: size.height * 0.8)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                    }
                    .zIndex(1)
                } else {
                    // Fallback on earlier versions
                }
                ZStack {
                    Image(uiImage: imageLoader.image ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width / 2, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
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
}

struct MovieCardView_Previews: PreviewProvider {
    static var previews: some View {
        MovieCardView(movie: Movie.stubbedMovie)
    }
}
