//
//  ArticleViewController.swift
//  AppTest
//
//  Created by rachel ng on 08/07/2019.
//  Copyright © 2019 rachelng. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var headTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var content: UILabel!
    
    var article: ArticleViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        self.headTitle.text = article.title
        self.content.text = article.content
        
        guard let imageUrl = article.urlToImage else {
            self.imageView.isHidden = true
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: URL(string:imageUrl)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self!.imageView.image = image
                        self?.viewDidLayoutSubviews()
                    }
                }
            }
        }
    }
}
