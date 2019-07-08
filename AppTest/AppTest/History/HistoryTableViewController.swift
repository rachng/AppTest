//
//  HistoryTableViewController.swift
//  AppTest
//
//  Created by rachel ng on 08/07/2019.
//  Copyright © 2019 rachelng. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {
    
    private var fetchedRC: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"HasReadArticle")
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dataSource:[HasReadArticle] = [HasReadArticle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        retrieveData()
    }
    
    private func setupUI() {
        self.title = "Recently Read Articles"
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func retrieveData() {
        do {
            let result = try context.fetch(fetchedRC)
            dataSource = result as! [HasReadArticle]
            self.tableView.reloadData()
        } catch {
            print("failed to retrieve HasReadArticle data")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.history, for: indexPath) as! HistoryTableViewCell
        
        let article = dataSource[indexPath.row]
        cell.articleTitle.text = article.title
        cell.articleDscp.text = article.content ?? ""
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Swipe left to delete a past history entry"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fetchedRC.predicate = NSPredicate(format: "title = %@", dataSource[indexPath.row].title ?? "")
            deleteEntryFromCore()
            dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func deleteEntryFromCore() {
        do {
            let filter = try context.fetch(fetchedRC)
            let entry = filter[0] as! NSManagedObject
            context.delete(entry)
            
            do {
                try context.save()
            } catch {
                print("failed to delete HasReadArticle entry.")
            }
            
        } catch {
            print("failed to filter article from HasReadArticle.")
        }
    }
}
