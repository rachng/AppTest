//
//  Article.swift
//  AppTest
//
//  Created by rachel ng on 08/07/2019.
//  Copyright © 2019 rachelng. All rights reserved.
//

import Foundation

class Article {
    
    var source: JSONDictionary?
    var author: String?
    var urlToImage: String?
    var content: String?
    var title: String!
    var publishedAt: String!
    var description: String?
    var url: String!
    
    init?(dictionary :JSONDictionary) {
        
        guard let title = dictionary["title"] as? String,
            let publishedAt = dictionary["publishedAt"] as? String,
            let url = dictionary["url"] as? String
        else { return nil }
        
        self.source = dictionary["source"] as? JSONDictionary
        self.author = dictionary["author"] as? String
        self.urlToImage = dictionary["urlToImage"] as? String
        self.content = dictionary["content"] as? String
        self.title = title
        self.publishedAt = publishedAt
        self.description = dictionary["description"] as? String
        self.url = url
        
    }
    
}
