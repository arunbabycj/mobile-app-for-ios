//
//  MasterViewController.swift
//  GettingThingsDone2
//
//  Created by Arunbaby on 28/4/18.
//  Copyright © 2018 Arunbaby. All rights reserved.
//

import UIKit

var Model1 = [ToDoItem]()
var Model2 = [ToDoItem]()
var Model = [Model1, Model2]
var test = History(comment: "hello")
var test1 = [test]

var indexSection: Int? = nil
var indexRow: Int? = nil
var rowNumber: Int? = nil



let sectionHeaders = ["Yet To Do", "Completed"]

enum Sections: Int {
    case sectionA = 0
    case sectionB = 1
}


class MasterViewController: UITableViewController, DetailViewControllerDelegate {
   
    
    
    var indexPath: IndexPath?
    
    var detailViewController: DetailViewController? = nil

   func detailViewControllerDidUpdate(_ detailViewController: DetailViewController) {
        self.tableView?.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func onFinished(_ returnItem: ToDoItem) {
        Model1[indexRow!] = returnItem

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY, HH:mm a"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        rowNumber = Model[0].count
        let indexPath = IndexPath(row:rowNumber!, section: 0)
        let list = "ToDoItem \((rowNumber)!+1)"
        let data = ToDoItem(title: list, comments: [History(comment: "\(dateString) Task Added")])
        Model1.append(data)
        Model = [Model1,Model2]
        tableView.insertRows(at: [indexPath], with: .automatic)
        self.indexPath = indexPath
    }

    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let ip = tableView.indexPathForSelectedRow {
                indexPath = ip
            } else {
                guard let ip = sender as? IndexPath else {
                    return
                }
                indexPath = ip
            }
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            indexSection = indexPath?.section
            indexRow = indexPath?.row
            var don = [String]()
            if (indexSection == 0){
                controller.detailItem = Model1[indexRow!]
                for com in Model1[indexRow!].comments {
                    let don1 = com.comment
                    don.append(don1)
                    controller.detailComments = don
                    print("ka",com.comment)
                }
            }else {
                controller.detailItem = Model2[indexRow!]
                for com in Model2[indexRow!].comments {
                     let don1 = com.comment
                    don.append(don1)
                    controller.detailComments = don
                    print("kadon",don1)
                }
            }
            controller.delegate = self
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return sectionHeaders[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let item = sectionHeaders[indexPath.section].rows[indexPath.row]
        let identifier: String
        guard let section = Sections(rawValue: indexPath.section) else {
            fatalError("Unexpectedly got section \(indexPath.section)")
        }
        switch section {
        case .sectionA:
            identifier = "sectionACell"
        case .sectionB:
            identifier = "sectionBCell"

        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let object = Model[indexPath.section][indexPath.row]
        cell.textLabel!.text = object.title
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Model[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY, HH:mm a"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        if(sourceIndexPath.section == 0 && destinationIndexPath.section == 1){
            let movedObject = Model[sourceIndexPath.section][sourceIndexPath.row]
            Model1.remove(at: sourceIndexPath.row)
            let dataTitle = movedObject.title
            var dataComments = movedObject.comments
            dataComments.append(History(comment: "\(dateString) Task Completed"))
            let data = ToDoItem(title: dataTitle, comments: dataComments)
            Model2.insert(data, at: destinationIndexPath.row)
            Model = [Model1,Model2]
        } else if(sourceIndexPath.section == 1 && destinationIndexPath.section == 0) {
           let movedObject = Model[sourceIndexPath.section][sourceIndexPath.row]
            Model2.remove(at: sourceIndexPath.row)
            let dataTitle = movedObject.title
            var dataComments = movedObject.comments
            dataComments.append(History(comment: "\(dateString) Some work left"))
            let data = ToDoItem(title: dataTitle, comments: dataComments)
            Model1.insert(data, at: destinationIndexPath.row)
            Model = [Model1,Model2]
        } else if (sourceIndexPath.section == 1 && destinationIndexPath.section == 1){
            let movedObject = Model[sourceIndexPath.section][sourceIndexPath.row]
            Model2.remove(at: sourceIndexPath.row)
            let data = ToDoItem(title: movedObject.title, comments: [History(comment: "\(dateString) Some work left")])
            Model2.insert(data, at: destinationIndexPath.row)
            Model = [Model1,Model2]
        } else if (sourceIndexPath.section == 0 && destinationIndexPath.section == 0) {
            let movedObject = Model[sourceIndexPath.section][sourceIndexPath.row]
            Model1.remove(at: sourceIndexPath.row)
            let data = ToDoItem(title: movedObject.title, comments: [History(comment: "\(dateString) Some work left")])
            Model1.insert(data, at: destinationIndexPath.row)
            Model = [Model1,Model2]
        }
        self.tableView?.reloadData()
    }
}

