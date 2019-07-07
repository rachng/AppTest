//
//  NewsListViewModel.swift
//  AppTest
//
//  Created by rachel ng on 08/07/2019.
//  Copyright © 2019 rachelng. All rights reserved.
//

import Foundation

class NewsListViewModel : NSObject {
    
    @objc dynamic private(set) var articleViewModels: [ArticleViewModel] = [ArticleViewModel]()
    private var token :NSKeyValueObservation?
    var bindToArticleViewModels: (() -> ()) = {  }
    private var apiManager: NewsAPIManager
    
    init(apiManager: NewsAPIManager) {
        
        self.apiManager = apiManager
        super.init()
        
        token = self.observe(\.articleViewModels) { _,_ in
            self.bindToArticleViewModels()
        }
        
        populateArticles()
    }
    
    func invalidateObservers() {
        self.token?.invalidate()
    }
    
    func populateArticles() {
        
        self.apiManager.loadArticles { [unowned self] articles in
            self.articleViewModels = articles.compactMap(ArticleViewModel.init)
        }
    }
    
    func article(at index:Int) -> ArticleViewModel {
        return self.articleViewModels[index]
    }
}

class ArticleViewModel : NSObject {
    
    var source: JSONDictionary?
    var author: String?
    var urlToImage: String?
    var content: String?
    var title: String!
    var publishedAt: String!
    var dscp: String?
    var url: String!
    
    init(article: Article) {
        
        self.source = article.source
        self.author = article.author
        self.urlToImage = article.urlToImage
        self.content = article.content
        self.title = article.title
        self.publishedAt = article.publishedAt
        self.dscp = article.description
        self.url = article.url
    }
}
