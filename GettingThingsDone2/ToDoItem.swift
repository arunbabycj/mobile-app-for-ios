//
//  ToDoList.swift
//  GettingThingsDone2
//
//  Created by Arunbaby Janardhanan on 1/5/18.
//  Copyright © 2018 Arunbaby. All rights reserved.
//

import Foundation



class ToDoItem {
    var title: String
    var comments: [History]
    
    init(title: String, comments:[History]) {
        self.title = title
        self.comments = comments
    }
 

}


//let data = ToDoList(sectionHeaders: <#[(heading: String, rows: [String])]#>)
 //var title: String
