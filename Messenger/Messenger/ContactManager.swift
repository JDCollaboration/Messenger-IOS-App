//
//  ContactManager.swift
//  Messenger
//
//  Created by Dillon Baker on 2/13/17.
//  Copyright © 2017 JDCollaboration. All rights reserved.
//

import Foundation
import CoreData

class ContactManager: NSObject, NSFetchedResultsControllerDelegate {
    
    static let sharedInstance = ContactManager()
    
    private var controller: NSFetchedResultsController<Contact>!
    private var _contacts: [Contact]!
    
    var numberOfContacts: Int {
        
        if _contacts == nil {
            _ = getContacts()
        }
        
        return _contacts != nil ? _contacts.count: 0
    }
    
    var contactController: NSFetchedResultsController<Contact>! {
        
        if controller == nil {
            fetchContacts()
        }
        
        return controller
    }
    
    func getContacts() -> [Contact] {
        
        fetchContacts()
        
        if let contacts = controller.fetchedObjects, contacts.count > 0 {
            _contacts = contacts
            return _contacts
        }
        
        return [Contact]()
    }
    
    func getContact(at: IndexPath) -> Contact {
        
        if _contacts == nil {
            fetchContacts()
        }
        
        let contact = _contacts[at.row]
        
        return contact
    }
    
    func addContact(contact: Contact) {
        
        if _contacts == nil {
            _ = getContacts()
        }
        
        _contacts.append(contact)
        
        do {
            try context.save()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        _ = getContacts()
    }
    
    func deleteContact(at: IndexPath) {
        
        let contact = _contacts.remove(at: at.row)
        
        let messageManager = MessageManager(contact: contact)
        messageManager.deleteMessages()
        
        context.delete(contact)
        
        do {
            try context.save()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        _ = getContacts()
    }
    
    private func fetchContacts() {
    
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
            _contacts = [Contact]()
            print(err)
        }
    }
    
}
