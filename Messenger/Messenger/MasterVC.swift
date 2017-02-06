//
//  MasterVC.swift
//  Messenger
//
//  Created by Dillon Baker on 2/6/17.
//  Copyright © 2017 JDCollaboration. All rights reserved.
//

import UIKit

class MasterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //normally a bad idea but I am initializing this in viewDidLoad()
    private var fakeFriendData: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fakeFriendData = ["Bob", "Joe", "Tom", "Jimmy", "Franky"]
    }
    
    //MARK: - Table View functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell") as? ConversationCell {
            
            let friend = fakeFriendData[indexPath.row]
            
            cell.setFriendData(name: friend)
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeFriendData.count
    }

}

