//
//  ConversationVC.swift
//  Messenger
//
//  Created by Dillon Baker on 2/6/17.
//  Copyright © 2017 JDCollaboration. All rights reserved.
//

import UIKit

class ConversationVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        titleLabel.text = name
    }
}
