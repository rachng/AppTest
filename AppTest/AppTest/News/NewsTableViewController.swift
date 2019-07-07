//
//  NewsTableViewController.swift
//  AppTest
//
//  Created by rachel ng on 08/07/2019.
//  Copyright © 2019 rachelng. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    private var apiManager: NewsAPIManager!
    private var newsListViewModel: NewsListViewModel!
    private var dataSource: TableViewDataSource<NewsTableViewCell,ArticleViewModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
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
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleViewController") as! ArticleViewController
        controller.article = self.newsListViewModel.article(at: indexPath.row)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
