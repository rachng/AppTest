//
//  NewsAPIManager.swift
//  AppTest
//
//  Created by rachel ng on 08/07/2019.
//  Copyright © 2019 rachelng. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String:Any]

class NewsAPIManager: NSObject {

    private let articlesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=sg&category=business&apiKey=104d7bd77d0b46f2802fef857710e84f&page=1")!
    
    func loadArticles(completion :@escaping ([Article]) -> ()) {
        
        URLSession.shared.dataTask(with: articlesURL) { data, _, _ in
            
            if let data = data {
                
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                let sourceDictionary = json as! JSONDictionary
                let dictionaries = sourceDictionary["articles"] as! [JSONDictionary]
                
                let sources = dictionaries.compactMap(Article.init)
                
                DispatchQueue.main.async {
                    completion(sources)
                }
            }
            
        }.resume()
        
    }
}
