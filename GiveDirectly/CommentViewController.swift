//
//  CommentViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/1/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    
    var commentIsVisible = false
    var commentTextField = UITextView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        commentTextField.hidden = true
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func commentButtonDidTouch(sender: UIButton) {
        
        
        if commentIsVisible == false {
            
            println(view.frame)
            
            let viewWidth = view.frame.width
            let viewHeight = view.frame.height
            let commentView = UIView()
            let flushYPosition = (viewHeight - 44)
            let flushKeyboardYPosition = (flushYPosition - 253)
            commentView.backgroundColor = UIColor.blueColor()
            commentView.frame = CGRect(x: 320, y: flushKeyboardYPosition, width: viewWidth, height: 44)
            commentTextField.frame = CGRect(x: 8, y: 7, width: viewWidth - 20, height: 30)
            commentTextField.backgroundColor = UIColor.whiteColor()
            
            view.addSubview(commentView)
            commentView.addSubview(commentTextField)
            
            self.commentTextField.hidden = false
            self.commentTextField.becomeFirstResponder()
            self.commentIsVisible = !self.commentIsVisible
            
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
                
                commentView.frame = CGRect(x: 0, y: flushKeyboardYPosition, width: self.view.frame.width, height: 44)
                
                
                }, completion: { finished in
                    println("You did it.")
                    
            })
            
        } else {
            println("Sorry, no.")
            
        }
        
    }
    
}
