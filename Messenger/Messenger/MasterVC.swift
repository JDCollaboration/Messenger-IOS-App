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
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let contactManager = ContactManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //set a default value for the tab bar
        tabBar.selectedItem = tabBar.items?[0]
        
        //detect when the context has changes so we update the table view with the most recent data
        NotificationCenter.default.addObserver(self, selector: #selector(objectContextDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
        
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        if self.tableView.isEditing {
            
            editButton.title = "Edit"
            self.tableView.setEditing(false, animated: true)
            
        } else {
            
            editButton.title = "Done"
            self.tableView.setEditing(true, animated: true)
            
        }
    }
    
    func objectContextDidChange(notification: Notification) {
        tableView.reloadData()
    }
    
    //MARK: - Table View functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell") as? ConversationCell {
            
            let contact = contactManager.getContact(at: indexPath)
            
            if let name = contact.name {
                cell.setFriendData(name: name)
            }
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactManager.numberOfContacts
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contact = contactManager.getContact(at: indexPath)
        performSegue(withIdentifier: "ConversationVC", sender: contact)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            contactManager.deleteContact(at: indexPath)
        }
        
    }
    
    //MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ConversationVC" {
            
            if let conversationVC = segue.destination as? ConversationVC {
                
                if let contact = sender as? Contact {
                    conversationVC.contact = contact
                }
                
            }
            
        }
    }
    
}


















