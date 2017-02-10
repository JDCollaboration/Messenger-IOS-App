//
//  ConversationVC.swift
//  Messenger
//
//  Created by Dillon Baker on 2/6/17.
//  Copyright © 2017 JDCollaboration. All rights reserved.
//

import UIKit

class ConversationVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //needed to animate the text field and send button when the keyboard shows or hides
    @IBOutlet weak var textViewBottomLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var messages = [TestMessage]()
    
    var contact: Contact!
    
    private let messageFont = UIFont.systemFont(ofSize: 18)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = contact.name
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //needed to maintain bottom inset after repositioning the collectionView
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        populateMessages()
        
        setKeyboardObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        repositionCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        //get rid of the keyboard if it is out
        //the messages don't resize properly if the keyboard is out
        view.endEditing(true)
        
        collectionView.reloadData {
            self.repositionCollectionView()
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
            
                self.repositionCollectionView()
            
            })
        }
    }
    
    //MARK: - CollectionView functions
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as? MessageCell {
            
            cell.message = messages[indexPath.row]
            
            if let message = messages[indexPath.row].message {
                
                let maxWidth = view.frame.width * 2.0 / 3.0
                
                let widthAndHeight = message.dimmensionsWithMaximumWidth(maxWidth: maxWidth, font: messageFont)
                
                cell.drawMessageBubble(width: widthAndHeight.width, height: widthAndHeight.height + 20, font: messageFont)
            }
            
            return cell
            
        }
            
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width
        
        if let message = messages[indexPath.row].message {
            
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    private func repositionCollectionView() {
        
        var indexPath = IndexPath(row: 0, section: 0)
        
        if messages.count > 0 {
            indexPath = IndexPath(row: messages.count - 1, section: 0)
        }
        
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
        
    }
    
    private func populateMessages() {
        
        let message1 = TestMessage(message: "Hi how are you?", sending: true)
        let message2 = TestMessage(message: "Good, how about you?", sending: false)
        let message3 = TestMessage(message: "Purdy good. I went to the store today and ran into one of my friends from high school and he's gotten super fat. Then when I got back in my car it wouldn't start! Can you believe that? What luck, amirite? So anyway I had to get an uber to come get me and take me to auto zone to get a new battery. I tried calling my friend Bill but he never seems to pick up when I call anymore. I have no idea why. It's strange really.", sending: true)
        let message4 = TestMessage(message: "Dude, I just asked how you were. I didn't ask for your life's story", sending: false)
        let message5 = TestMessage(message: "I'm sorry. I'm just so lonely T~T", sending: true)
        let message6 = TestMessage(message: "I think I know why Bill doesn't answer anymore.", sending: false)
        let message7 = TestMessage(message: "What's that supposed to mean?", sending: true)
        let message8 = TestMessage(message: "Hello?", sending: true)
        let message9 = TestMessage(message: "Don't ignore me!", sending: true)
        let message10 = TestMessage(message: "I know where you live!!!", sending: true)
        
        messages.append(message1)
        messages.append(message2)
        messages.append(message3)
        messages.append(message4)
        messages.append(message5)
        messages.append(message6)
        messages.append(message7)
        messages.append(message8)
        messages.append(message9)
        messages.append(message10)
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


















