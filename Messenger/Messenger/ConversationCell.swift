//
//  ConversationCell.swift
//  Messenger
//
//  Created by Dillon Baker on 2/6/17.
//  Copyright © 2017 JDCollaboration. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: - Private variables
    private var _friendName: String?
    
    //MARK: - Public getters and setters
    var friendName: String {
        get {
            return _friendName ?? ""
        }
        
        set {
            _friendName = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setFriendData(name: String) {
        nameLabel.text = name
    }
}
