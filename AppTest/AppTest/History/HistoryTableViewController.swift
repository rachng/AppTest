//
//  HistoryTableViewController.swift
//  AppTest
//
//  Created by rachel ng on 08/07/2019.
//  Copyright © 2019 rachelng. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
//    private var historyListViewModel: HistoryListViewModel!
//    private var dataSource: TableViewDataSource<HistoryTableViewCell,HistoryViewModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
}
