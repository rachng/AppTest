//
//  NewsTableViewController.swift
//  AppTest
//
//  Created by rachel ng on 08/07/2019.
//  Copyright © 2019 rachelng. All rights reserved.
//

import UIKit
import CoreData

class NewsTableViewController: UITableViewController {
    
    private var apiManager: NewsAPIManager!
    private var newsListViewModel: NewsListViewModel!
    private var dataSource: TableViewDataSource<NewsTableViewCell,ArticleViewModel>!
    
    private var fetchedHasReadRC = NSFetchRequest<NSFetchRequestResult>(entityName:"HasReadArticle")
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var hasReadArticles:[HasReadArticle] = [HasReadArticle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        retrieveHasRead()
    }
    
    private func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .organize, target: self, action: Selector("segueHistory"))
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("updateUI"), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc
    func segueHistory() {
        self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryTableViewController") as! HistoryTableViewController, animated: true)
    }
    
    private func retrieveHasRead() {
        do {
            let result = try context.fetch(fetchedHasReadRC)
            hasReadArticles = result as! [HasReadArticle]
        } catch {
            print("failed to retrieve HasReadArticle data")
        }
    }
    
    @objc
    func updateUI() {
        self.apiManager = NewsAPIManager()
        self.newsListViewModel = NewsListViewModel(apiManager: self.apiManager)
        
        self.newsListViewModel.bindToArticleViewModels = {
            self.tableView.refreshControl?.endRefreshing()
            self.loadData()
        }
    }
    
    private func loadData() {
        self.dataSource = TableViewDataSource(cellIdentifier: Cells.news, items: self.newsListViewModel.articleViewModels) { cell, article in
            
            cell.articleTitle.text = article.title ?? ""
            cell.articleDscp.text = article.content ?? ""
        }
        
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let selectedArticle = self.newsListViewModel.article(at: indexPath.row)
        self.articleIsRead(selectedArticle: selectedArticle)
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleViewController") as! ArticleViewController
        controller.article = selectedArticle
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func articleIsRead(selectedArticle:ArticleViewModel) {
        var isExisting = false
        for article in hasReadArticles {
            if article.title == selectedArticle.title {
                isExisting = true
                break
            }
        }
        
        if isExisting == false {
            let entry = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "HasReadArticle", in: context)!, insertInto: context) as! HasReadArticle
            entry.title = selectedArticle.title
            entry.content = selectedArticle.content
            
            do {
                try self.context.save()
            } catch {
                print("Save new entry for HasReadArticle has failed")
            }
        }
    }
}
