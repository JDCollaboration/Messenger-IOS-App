//
//  AddContactVC.swift
//  Messenger
//
//  Created by Dillon Baker on 2/13/17.
//  Copyright © 2017 JDCollaboration. All rights reserved.
//

import UIKit
import CoreData

class AddContactVC: UIViewController {
    
    @IBOutlet weak var contactName: UITextField!
    
    let contactManager = ContactManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        if let name = contactName.text, name != "" {
            
            let newContact = Contact(context: context)
             newContact.name = name
            
            contactManager.addContact(contact: newContact)
        }
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
}
