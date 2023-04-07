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
    
    var body: some View {
        if #available(iOS 15.0, *) {
            VStack(spacing: 15) {
                
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
