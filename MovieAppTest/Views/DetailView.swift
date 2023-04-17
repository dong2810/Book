//
//  DetailView.swift
//  MovieAppTest
//
//  Created by QuyNM on 4/7/23.
//

import SwiftUI

struct DetailView: View {
    @Binding var show: Bool
//    let movieId: Int
    var animation: Namespace.ID
    var movie: Movie
    let imageLoader = ImageLoader()
	@State private var animationContent: Bool = false
	@ObservedObject var movieDetailState = MovieDetailState()
    
    var body: some View {
        if #available(iOS 15.0, *) {
            VStack(spacing: 15) {
                Button {
                    withAnimation(.easeIn(duration: 0.35)) {
						animationContent = false
                        show = false
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.black)
                        .contentShape(Rectangle())
                        
                }
                .padding([.leading, .vertical], 15)
                .frame(maxWidth: .infinity, alignment: .leading)
				.opacity(animationContent ? 1 : 0)
                
                GeometryReader {
                    let size = $0.size
                    HStack(spacing: 20) {
						MovieDetailImage(imageLoader: imageLoader, imageURL: self.movie.backdropURL)
                            .frame(width: (size.width - 30) / 2, height: size.height)
						//Custom Corner Shape
							.clipShape(CustomCorner(corner: [.topRight, .bottomRight], radius: 20))
							.matchedGeometryEffect(id: movie.id, in: animation)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(movie.title)
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            ForEach(movie.directors ?? [MovieCrew]()) { crew in
                                Text(crew.name)
                            }
                        }
                    }
                }
				.frame(height: 220)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background {
                Rectangle()
                    .fill(.white)
                    .ignoresSafeArea()
					.opacity(animationContent ? 1 : 0)
            }
			.onAppear {
				withAnimation(.easeIn(duration: 0.35)) {
					animationContent = true
				}
			}
        } else {
            // Fallback on earlier versions
        }
    }
}

struct MovieDetailImage: View {
	@ObservedObject var imageLoader : ImageLoader
	let imageURL : URL

	var body: some View {
		ZStack {
			Rectangle().fill(Color.gray.opacity(0.3))
			if self.imageLoader.image != nil {
				Image(uiImage: self.imageLoader.image!)
					.resizable()
					.aspectRatio(contentMode: .fill)
			}
		}
		.onAppear {
			self.imageLoader.loadImage(with: self.imageURL)
		}
	}
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
