//
//  TaskTableViewCell.swift
//  GettingThingsDone2
//
//  Created by Arunbaby on 6/5/18.
//  Copyright © 2018 Arunbaby. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

     @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
