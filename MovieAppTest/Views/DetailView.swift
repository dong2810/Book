//
//  DetailView.swift
//  MovieAppTest
//
//  Created by QuyNM on 4/7/23.
//

import SwiftUI

struct DetailView: View {
    @Binding var show: Bool
    var animation: Namespace.ID
    var movie: Movie
    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {
        if #available(iOS 15.0, *) {
            VStack(spacing: 15) {
                Button {
                    withAnimation(.easeIn(duration: 0.35)) {
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
                
                GeometryReader {
                    let size = $0.size
                    HStack(spacing: 20) {
                        Image(uiImage: imageLoader.image ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width / 2, height: size.height)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background {
                Rectangle()
                    .fill(.white)
                    .ignoresSafeArea()
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
