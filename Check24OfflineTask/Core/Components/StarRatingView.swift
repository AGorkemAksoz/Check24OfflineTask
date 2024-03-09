//
//  StarRatingView.swift
//  Check24OfflineTask
//
//  Created by Ali Görkem Aksöz on 9.03.2024.
//

import SwiftUI

import SwiftUI

struct StarRatingView: View {
    var rating: Double
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<5) { index in
                Image(systemName: self.starSymbol(for: index))
                    .foregroundColor(self.starColor(for: index)!)
            }
        }
    }
    
    private func starSymbol(for index: Int) -> String {
        let filledStars = Int(rating)
        let hasHalfStar = rating.truncatingRemainder(dividingBy: 1) != 0
        
        if index < filledStars {
            return "star.fill"
        } else if index == filledStars && hasHalfStar {
            return "star.leadinghalf.fill"
        } else {
            return "star"
        }
    }
    
    private func starColor(for index: Int) -> Color? {
        let filledStars = Int(rating)
        let hasHalfStar = rating.truncatingRemainder(dividingBy: 1) != 0
        
        if index < filledStars {
            return .yellow
        } else if index == filledStars && hasHalfStar {
            return .yellow
        } else {
            return .yellow
        }
    }
}
