//
//  MessageCell.swift
//  Messenger
//
//  Created by Dillon Baker on 2/8/17.
//  Copyright © 2017 JDCollaboration. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    private let INSET_FROM_SIDES: CGFloat = 10.0
    private let INSET_FROM_BUBBLE: CGFloat = 10.0
    
    //extra horizontal padding to keep text from spilling over
    //to the next line before it really needs to
    private let EXTRA_PADDING: CGFloat = 14.0
    
    //nice looking blue color
    private let SENDING_COLOR = UIColor(displayP3Red: 14.0/255.0, green: 122.0/255.0, blue: 254.0/255.0, alpha: 1.0)
    
    //very light gray color
    private let RECEIVING_COLOR = UIColor(displayP3Red: 235.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    
    private var _message: TestMessage!
    
    var message: TestMessage {
        get {
            return _message ?? TestMessage(message: "", sending: true)
        } set {
            _message = newValue
        }
    }
    
    private func cleanup() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func drawMessageBubble(width: CGFloat, height: CGFloat, font: UIFont) {
        
        cleanup()
        
        //width of the UICollectionViewCell
        let totalWidth = self.frame.width
        
        //define a UIView that will become the bubble
        let view = UIView()
        
        //define a UITextView that will hold the contents of the message
        let textView = UITextView()
        
        //give the bubble rounded corners
        view.layer.cornerRadius = 20.0
        
        //set the background to clear so the UIView will be visible
        textView.backgroundColor = UIColor.clear
        
        textView.font = font
        textView.text = _message.message
        
        if _message.sending! {
            
            view.frame = CGRect(x: totalWidth - width - EXTRA_PADDING - INSET_FROM_BUBBLE - INSET_FROM_SIDES - INSET_FROM_SIDES, y: 0, width: width + INSET_FROM_SIDES + INSET_FROM_BUBBLE +  EXTRA_PADDING, height: height)
            
            view.backgroundColor = SENDING_COLOR
            textView.textColor = UIColor.white
            
            textView.frame = CGRect(x: totalWidth - width - INSET_FROM_SIDES - INSET_FROM_BUBBLE - EXTRA_PADDING, y: 0, width: width + EXTRA_PADDING, height: height)
            
        } else {
            
            view.frame = CGRect(x: INSET_FROM_SIDES, y: 0, width: width + INSET_FROM_SIDES + INSET_FROM_BUBBLE + EXTRA_PADDING, height: height)
            
            view.backgroundColor = RECEIVING_COLOR
            textView.textColor = UIColor.black
            
            textView.frame = CGRect(x: INSET_FROM_SIDES + INSET_FROM_BUBBLE, y: 0, width: width + INSET_FROM_BUBBLE + EXTRA_PADDING, height: height)
            
        }
        
        //add views to the view hierarchy
        self.addSubview(view)
        self.addSubview(textView)
    }
    
}

