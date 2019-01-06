//
//  DetailViewController.swift
//  GettingThingsDone2
//
//  Created by Arunbaby on 28/4/18.
//  Copyright © 2018 Arunbaby. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: class {
    func detailViewControllerDidUpdate(_ detailViewController: DetailViewController)
    func onFinished(_ :ToDoItem)
}

class DetailViewController: UITableViewController, UITextFieldDelegate {

    var detailSectionHeaders:[(heading: String, rows: [String])] = [
        ("Task", []),
        ("History", []),
        ("Collaborators", [])
    ]
    
    var index: Int? = nil
    var detailItem: ToDoItem? = nil
    var newtester: History? = nil
    var detailComments: [String] = []
    var textField: UITextField? = nil
    var histextField: UITextField? = nil
    weak var delegate: DetailViewControllerDelegate?
    
    @IBAction func AddButton(_ sender: Any) {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY, HH:mm a"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        //self.save()
        detailSectionHeaders[1].rows.append(dateString)
        self.tableView?.reloadData()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            detailSectionHeaders[0].rows.append(detail.title)
            //print("yes",detailComments)
            for comments in (detailItem?.comments)! {
                detailSectionHeaders[1].rows.append(comments.comment)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return detailSectionHeaders.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return detailSectionHeaders[section].heading
    }
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return detailSectionHeaders[section].rows.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.detailSectionHeaders[indexPath.section].rows[indexPath.row]
        //let item = detailItem?
        //print(item)
        switch indexPath.section {
        case 0:
            //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskTableViewCell else {
                fatalError("Unable to get cell")
            }
            textField = cell.textField
            textField?.text = item
            return cell
       case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryTableViewCell else {
                fatalError("Unable to get cell")
            }
            histextField = cell.historyTextField
            histextField?.text = item
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorCell", for: indexPath) as? CollaboratorTableViewCell else {
                fatalError("Unable to get cell")
            }
            cell.textField?.text = item
            return cell
        default:
            fatalError("No such section")
        }
    }
    
    // function to save item when view disappears
    func save() {
        guard let detailtitle = textField?.text else{
            return
        }
        detailItem?.title = detailtitle
        //detailComments = []
        var newComments: [History] = []
         let totalRows = tableView.numberOfRows(inSection: 1)
         detailSectionHeaders[1].rows.removeAll()
         for row in 0...totalRows-1 {
            //print("row \(row)")
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 1)) as? HistoryTableViewCell
            guard let details = cell?.historyTextField.text else {
                continue
            }
            newComments.append(History(comment: details))
            //newtester?.comment = details!
            //print("cell",details)
            //detailComments.append(details!)
            //detailItem?.comments
           // detailSectionHeaders[1].rows.append(details!)
        }
        detailItem?.comments = newComments
        print("title",detailItem?.title,"   ", "comments",detailItem?.comments)
        self.delegate?.onFinished(detailItem!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.save()
        delegate?.detailViewControllerDidUpdate(self)
        //detailSectionHeaders[1].rows.removeAll()
    }

}

//extension DetailViewController {
   // var json: Data {
        //get { return try! JSONEncoder().encode(<#T##value: Encodable##Encodable#>)}
   // }
//}



//historyTextField.resignFirstResponder()

//detailComments = histextField.text
//let new = historyTextField.text

//for row in historyTextField.text. {
// detailComments.append(row)
//}
//print("how",detailSectionHeaders[1].rows)
//detailSectionHeaders[1].rows.append(item)
//cell.textField?.text = item
//cell.historyTextField.text = item
//let num = detailSectionHeaders[1].rows.count
// detailSectionHeaders[1].rows.insert((histextField?.text)!, at: num-1)
//detailSectionHeaders[1].rows.popLast()
//let totalSection = tableView.numberOfSections
//for section in 0..<totalSection
//{
//print("section \(section)")
//print("this isnow",detailComments)
/*if let label = cell?.viewWithTag(2) as? UILabel {
 label.text = "Section = \(1), Row = \(row)"
 print("cell",label.text)
 }*/
//print("this isnow at last",detailComments)
//}

/*for details in detailSectionHeaders[1].rows {
 detailComments = []
 detailComments.append(details)
 //print("this is",detailComments)
 }
 print("this is",detailComments)*/
/*let totalSection = tableView.numberOfSections
 for section in 0..<totalSection
 {
 print("section \(section)")
 let totalRows = tableView.numberOfRows(inSection: section)
 
 for row in 0..<totalRows
 {
 print("row \(row)")
 let cell = tableView.cellForRow(at: IndexPath(row: row, section: section))
 print("cell",cell)
 detailComments = []
 //detailComments.append((cell?.textInputContextIdentifier)!)
 //print("this isnow",detailComments)
 //if let label = cell?.viewWithTag(2) as? UILabel
 //{
 //    label.text = "Section = \(section), Row = \(row)"
 //}
 }
 }*/
//for (UIView in TableView.subviews) {
//   for (tableviewCell in view.subviews) {
//do
// }
//}
/*for n in (histextField?.text)!{
 print ("gotcha",n)
 }*/
//print("this is",detailItem!)
//for elements in (self.tableView(_ tableView: UITableView, cellForRowAt: num)) {
/*for elements in {
 detailComments = []
 detailComments.append(details)
 }*/
//for elements in (self.tableView.cellForRowAt: num)


/*var detailItem: String? {
 didSet {
 // Update the view.
 configureView()
 }
 }*/

//@IBAction func editDetail(_ sender: Any) {
//  detailSectionHeaders[1].rows.append(comments)
// }
/*var detailComment: [String] = [] {
 didSet {
 // Update the view.
 //configureView()
 }
 }*/
