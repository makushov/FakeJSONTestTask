//
//  DataItem.swift
//  FakeJSONTestTask
//
//  Created by Stanislav Makushov on 19.02.2023.
//

import Foundation

struct DataItem {
    
    private struct Keys {
        static let title = "title"
        static let firstImage = "firstimg"
        static let secondImage = "secondimg"
        static let thirdImage = "thirdimg"
        static let details = "details"
    }
    
    var title: String?
    var firstImageUrl: URL?
    var secondImageUrl: URL?
    var thirdImageUrl: URL?
    var details: String?
    
    init(from dictionary: [String: String]) {
        title = dictionary[Keys.title]
        details = dictionary[Keys.details]
        
        if let firstImageUrlString = dictionary[Keys.firstImage], let firstImageUrl = URL(string: firstImageUrlString) {
            self.firstImageUrl = firstImageUrl
        }
        
        if let secondImageUrlString = dictionary[Keys.secondImage], let secondImageUrl = URL(string: secondImageUrlString) {
            self.secondImageUrl = secondImageUrl
        }
        
        if let thirdImageUrlString = dictionary[Keys.thirdImage], let thirdImageUrl = URL(string: thirdImageUrlString) {
            self.thirdImageUrl = thirdImageUrl
        }
    }
}
