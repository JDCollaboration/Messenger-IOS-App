//
//  ConversationVC.swift
//  Messenger
//
//  Created by Dillon Baker on 2/6/17.
//  Copyright © 2017 JDCollaboration. All rights reserved.
//

import UIKit

class ConversationVC: UIViewController {
    
    //needed to animate the text field and send button when the keyboard shows or hides
    @IBOutlet weak var textViewBottomLayoutConstraint: NSLayoutConstraint!
    
    var contact: Contact!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = contact.name
        
        setKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleKeyboardNotification(notification: Notification) {
        
        if let info = notification.userInfo {
            
            //we need to know how tall the keyboard is so we can move the text view accordingly
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let isKeyboardShowing = notification.name == Notification.Name.UIKeyboardWillShow
            self.textViewBottomLayoutConstraint.constant = isKeyboardShowing ? keyboardFrame.height : 0
            
            //animate the text view position change so it moves with the keyboard
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { 
                
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in })
        }
    }
    
    //MARK: - Private functions
    private func setKeyboardObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
}
