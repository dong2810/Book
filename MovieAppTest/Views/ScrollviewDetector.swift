//
//  ScrollviewDetector.swift
//  MovieAppTest
//
//  Created by QuyNM on 4/6/23.
//

import SwiftUI

struct ScrollviewDetector: UIViewRepresentable {
    @Binding var carouselMode: Bool
    var totalCardCount: Int = 0
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, totalCount: 0)
    }
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView {
                scrollView.decelerationRate = carouselMode ? .fast : .normal
                if carouselMode {
                    scrollView.delegate = context.coordinator
                } else {
                    scrollView.delegate = nil
                }
                context.coordinator.totalCount = totalCardCount
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollviewDetector
        var totalCount: Int = 0
        var velocityY: CGFloat = 0
        init(parent: ScrollviewDetector, totalCount: Int) {
            self.parent = parent
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            let cardHeight: CGFloat = 220
            let cardSpacing: CGFloat = 35
            /// Adding velocity for more natural feel
            let targetEnd: CGFloat =  scrollView.contentOffset.y + (velocity.y * 60)
            let index = (targetEnd / cardHeight).rounded()
            let modifiedEnd = index * cardHeight
            let spacing = cardSpacing * index
            
            targetContentOffset.pointee.y = modifiedEnd + spacing
            velocityY = velocity.y
        }
        
        func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
            let cardHeight: CGFloat = 220
            let cardSpacing: CGFloat = 35
            /// Adding velocity for more natural feel
            let targetEnd: CGFloat =  scrollView.contentOffset.y + (velocityY * 60)
            let index = max(min((targetEnd / cardHeight).rounded(), CGFloat(totalCount - 1)), 0.0)
            let modifiedEnd = index * cardHeight
            let spacing = cardSpacing * index
            
            scrollView.setContentOffset(.init(x: 0, y: modifiedEnd + spacing), animated: true)
        }
    }
}
