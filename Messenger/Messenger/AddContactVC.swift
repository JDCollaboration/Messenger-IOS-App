//
//  AddContactVC.swift
//  Messenger
//
//  Created by Dillon Baker on 2/13/17.
//  Copyright © 2017 JDCollaboration. All rights reserved.
//

import UIKit

class AddContactVC: UIViewController {
    
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    
    
    let contactManager = ContactManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setKeyboardObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func handleKeyboardNotification(notification: Notification) {
        
        if let info = notification.userInfo {
            
            //we need to know how tall the keyboard is so we can move the text view accordingly
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let isKeyboardShowing = notification.name == Notification.Name.UIKeyboardWillShow
            self.bottomButtonConstraint.constant = isKeyboardShowing ? keyboardFrame.height + 20 : 20
            
            //animate the text view position change so it moves with the keyboard
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in })
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        if let name = contactName.text, name != "" {
            
            let newContact = Contact(context: context)
             newContact.name = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            contactManager.addContact(contact: newContact)
        }
        
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    
    }
    
}
