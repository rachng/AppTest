//
//  NewsAPIManager.swift
//  AppTest
//
//  Created by rachel ng on 08/07/2019.
//  Copyright © 2019 rachelng. All rights reserved.
//

import UIKit
import CoreData

typealias JSONDictionary = [String:Any]

class NewsAPIManager: NSObject {

    private let articlesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=sg&category=business&apiKey=104d7bd77d0b46f2802fef857710e84f&page=1")!
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadArticles(completion :@escaping ([Article]) -> ()) {
        
        URLSession.shared.dataTask(with: articlesURL) { data, _, _ in
            
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                let articleDictionary = json as! JSONDictionary
                let dictionaries = articleDictionary["articles"] as! [JSONDictionary]
                
                let articles = dictionaries.compactMap(Article.init)
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
            
        }.resume()
        
    }
}
