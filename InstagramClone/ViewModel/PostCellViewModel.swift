//
//  PostCellViewModel.swift
//  InstagramClone
//
//  Created by A1398 on 08/10/2024.
//

import Foundation

final class PostCellViewModel {
    var statPost: StatsPost
    var postImageUrl: URL? { return URL(string: statPost.imageUrl) }
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: statPost.time.dateValue(), to: Date())
    }
    
    func getLike() -> String {
        return String(statPost.like)
    }
    
    func getComment() -> String {
        return String(statPost.comment)
    }
    
    init (statPost: StatsPost) {
        self.statPost = statPost
    }
}
