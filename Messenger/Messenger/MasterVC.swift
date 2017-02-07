//
//  MasterVC.swift
//  Messenger
//
//  Created by Dillon Baker on 2/6/17.
//  Copyright © 2017 JDCollaboration. All rights reserved.
//

import UIKit
import CoreData

class MasterVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var controller: NSFetchedResultsController<Contact>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //set a default value for the tab bar
        tabBar.selectedItem = tabBar.items?[0]
        
        //generateTestData()
        
        fetchContacts()
    }
    
    //Eventually this will allow you to search for people to chat with
    //But for now it just adds Bob Dole 👍
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let newContact = Contact(context: context)
        newContact.name = "Bob Dole"
        
        do {
            try context.save()
        } catch let err as NSError {
            print(err.debugDescription)
        }
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
    
    
    //MARK: - Table View functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell") as? ConversationCell {
            
            let contact = controller.object(at: indexPath)
            
            if let name = contact.name {
                cell.setFriendData(name: name)
            }
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects, objs.count > 0 {
            
            if let contactName = objs[indexPath.row].name {
                
                performSegue(withIdentifier: "ConversationVC", sender: contactName)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if let contacts = controller.fetchedObjects, contacts.count > 0 {
                
                let contact = contacts[indexPath.row]
                
                context.delete(contact)
                
                do {
                    try context.save()
                } catch let err as NSError {
                    print(err.debugDescription)
                }
                
            }
        }
        
    }
    
    //MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ConversationVC" {
            
            if let conversationVC = segue.destination as? ConversationVC {
                
                if let name = sender as? String {
                    conversationVC.name = name
                }
                
            }
            
        }
    }
    
    //MARK: - CoreData functions
    
    //fetch Contacts from CoreData
    func fetchContacts() {
        
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        
        //sort by alphabetical order for now
        //eventually Contacts will be sorted by most recent message
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch let err {
            print(err)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
            
            case .insert:
                self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
                
            case .delete:
                self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
                
            default:
                return
            
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
                
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
                
            default:
                return
            
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //used to generate some test data to put in CoreData
    private func generateTestData() {
        
        let contact1 = Contact(context: context)
        contact1.name = "Bob"
        
        let contact2 = Contact(context: context)
        contact2.name = "George"
        
        let contact3 = Contact(context: context)
        contact3.name = "Jerry"
        
        let contact4 = Contact(context: context)
        contact4.name = "Max"
        
        let contact5 = Contact(context: context)
        contact5.name = "Frank"
        
        let contact6 = Contact(context: context)
        contact6.name = "Bill"
        
        ad.saveContext()
        
    }

}


















