//
//  ConversationVC.swift
//  Messenger
//
//  Created by Dillon Baker on 2/6/17.
//  Copyright © 2017 JDCollaboration. All rights reserved.
//

import UIKit

class ConversationVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var messageTextField: RoundedTextField!
    
    //needed to animate the text field and send button when the keyboard shows or hides
    @IBOutlet weak var textViewBottomLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var messageManager: MessageManager!
    var contact: Contact!
    
    private let messageFont = UIFont.systemFont(ofSize: 18)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = contact.name
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //needed to maintain bottom inset after repositioning the collectionView
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        messageManager = MessageManager(contact: contact)
        
        setKeyboardObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        repositionCollectionView(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        //get rid of the keyboard if it is out
        //the messages don't resize properly if the keyboard is out
        view.endEditing(true)
        
        collectionView.reloadData {
            self.repositionCollectionView(animated: true)
        }
        
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
                
            }, completion: { (completed) in
            
                self.repositionCollectionView(animated: true)
            
            })
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        if let messageToSend = messageTextField.text, messageToSend != "" {
            
            messageManager.sendMessage(message: messageToSend, isSending: true)
            
            collectionView.reloadData {
                self.repositionCollectionView(animated: true)
            }
        }
        
        messageTextField.text = ""
    }
    
    @IBAction func SimulateResponse(_ sender: UIBarButtonItem) {
        
        messageManager.sendMessage(message: "What up dude?", isSending: false)
        
        collectionView.reloadData {
            self.repositionCollectionView(animated: true)
        }
        
    }
    
    
    //MARK: - CollectionView functions
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as? MessageCell {
            
            if let message = messageManager.messages?[indexPath.row] {
                
                cell.message = message
                
                let maxWidth = view.frame.width * 2.0 / 3.0
                
                if let widthAndHeight = message.message?.dimmensionsWithMaximumWidth(maxWidth: maxWidth, font: messageFont) {
                    
                    cell.drawMessageBubble(width: widthAndHeight.width, height: widthAndHeight.height + 20, font: messageFont)
                    
                }
                
            }
            
            return cell
            
        }
            
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = messageManager.messages?.count {
            return count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width
        
        if let message = messageManager.messages?[indexPath.row].message {
            
            let maxWidth = view.frame.width * 2.0 / 3.0
            
            let height = message.dimmensionsWithMaximumWidth(maxWidth: maxWidth, font: messageFont).height
            
            return CGSize(width: width, height: height + 20)
        }
        
        return CGSize(width: width, height: 100.0)
     
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        view.endEditing(true)
        
    }
    
    //MARK: - Private functions
    private func setKeyboardObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    private func repositionCollectionView(animated: Bool) {
        
        var indexPath = IndexPath(row: 0, section: 0)
        
        if let count = messageManager.messages?.count, count > 0 {
            indexPath = IndexPath(row: count - 1, section: 0)
            
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: animated)
        }
    }
}

//MARK: - String extension functions
extension String {
    
    //Given a maximum width and a font, returns the dimmensions that a given string would have
    //in a 2-tuple
    func dimmensionsWithMaximumWidth(maxWidth: CGFloat, font: UIFont) -> (width: CGFloat, height: CGFloat) {
        
        var constraintRect = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let boundedBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        let height = boundedBox.height
        
        constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        
        var width = boundedBox.width
        
        if width > maxWidth {
            width = maxWidth
        }
        
        return (width, height)
    }
    
}

//MARK: - UICollectionView extension functions
extension UICollectionView {
    
    func reloadData(completion: @escaping ()->()) {
        
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
    
}


















