//
//  MessageManager.swift
//  Messenger
//
//  Created by Dillon Baker on 2/13/17.
//  Copyright © 2017 JDCollaboration. All rights reserved.
//

import Foundation
import CoreData

class MessageManager: NSObject, NSFetchedResultsControllerDelegate {
    
    private var controller: NSFetchedResultsController<Message>!
    private var _messages: [Message]!
    private var _contact: Contact!
    
    var messages: [Message]? {
        
        if _messages == nil {
            _messages = getMessages()
        }
        
        return _messages
    }
    
    init(contact: Contact) {
        _contact = contact
    }
    
    
    func getMessages() -> [Message]? {
        
        fetchMessages()
        
        if let messages = controller.fetchedObjects, messages.count > 0 {
            return messages
        }
        
        return nil
    }
    
    //Need isSending for simulation purposes
    func sendMessage(message: String, isSending: Bool) {
        
        let newMessage = Message(context: context)
        newMessage.contact = _contact
        newMessage.message = message
        newMessage.isSending = isSending
        newMessage.timestamp = NSDate()
        
        do {
            try context.save()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        _messages = getMessages()
    }
    
    func deleteMessages() {
        
        if let msgs = messages {
            
            for m in msgs {
                context.delete(m)
            }
            
            do {
                try context.save()
            } catch let err as NSError {
                print(err.debugDescription)
            }
            
        }
        
    }
    
    
    private func fetchMessages() {
        
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        
        let timestampSort = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [timestampSort]
        fetchRequest.predicate = NSPredicate(format: "contact.name = %@", _contact.name!)
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch let err {
            print(err)
        }
        
    }
}
