//
//  CommentViewController.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 7/1/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITextFieldDelegate {
    
    var updateInfo: AnyObject = ""
    var recipientInfo: AnyObject = ""
    var respondingToUpdate = ""
    
    // if done programmatically...
//    var commentIsVisible = false
//    var commentTextField = UITextView()
//    var submitCommentButton = UIButton()
    
    // will the real version only be a UITextField instead?

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet var masterView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    

    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        

        let updateTopic:String? = (updateInfo as AnyObject)["updateTitle"] as? String
        let recipientName:String? = (recipientInfo as AnyObject)["name"] as? String
        let recipientProfilePhoto = recipientInfo["profileSquarePhoto"] as! PFFile
//        let respondingToUpdate:String? = (updateInfo.objectId)
        

        
        // when this view loads, the recipient's update objectId should be passed here
        // via segue, so that it can be used to create a relational link
        
//        println(updateInfo)
//        println(recipientInfo)
        
        
        // load profile photo
        recipientProfilePhoto.getDataInBackgroundWithBlock({
            (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                let image = UIImage(data: imageData!)
                self.commentImageView.image = image
            }
        })
        
        
        
        self.recipientNameLabel.text = recipientName
        self.timeLabel.text = "31m"
        self.topicLabel.text = updateTopic
        
        
        // make updater's profile image round
        commentImageView.layer.cornerRadius = self.commentImageView.frame.size.width / 2
        commentImageView.clipsToBounds = true
        commentImageView.layer.borderWidth = 2.0
        commentImageView.layer.borderColor = UIColor.clearColor().CGColor
        commentImageView.layer.backgroundColor = UIColor.blackColor().CGColor

        
        
        // set self as the delegate for the text field
        // so that the view controller can listen to text field events
        self.commentTextField.delegate = self
        
        
        // gesture recognizer that detects if user taps outside the text view
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "masterViewTapped")
        self.masterView.addGestureRecognizer(tapGesture)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // check if any text exists in the view, and disable the submit button if not
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = commentTextField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        submitButton.enabled = (newText.length > 0)
        print("Text length = \(newText.length).")
        return true
        
    }

    
    
    
    
    
    @IBAction func submitButtonDidTouch(sender: UIButton) {
        
        // dismiss the keyboard, etc.
        self.masterView.endEditing(true)


        // send the text data to the Parse backend with the comment
        let newComment:PFObject = PFObject(className: "Comments")
        let respondingToUpdate:String? = (updateInfo.objectId)
        let currentUser = PFUser.currentUser()
        newComment["text"] = self.commentTextField.text
        newComment["author"] = currentUser
        newComment["relatedUpdate"] = PFObject(withoutDataWithClassName: "RecipientUpdate", objectId: respondingToUpdate)
//        println("This post is registered as: \(respondingToUpdate)")
        newComment.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            if (success == true) {
                
                // comment has been saved successfully
                print("Comment successfully submitted.")
                
            } else {
                
                // something has gone awry
                NSLog(error!.description)
            }
        }
        
        // clear the text view
        self.commentTextField.text = ""
        self.submitButton.enabled = false
        
        // unwind
        self.performSegueWithIdentifier("unwindToNewsfeed", sender: self)
        

    }
    
    func masterViewTapped() {
        
        // force the text view to end editing
        self.masterView.endEditing(true)
    }
    
    
    // MARK: TextField Delegate Methods
    func textViewDidBeginEditing(textView: UITextView) {
        
        // enable submit button once text has been entered into the text view
        
        
        // just for fun
        masterView.backgroundColor = UIColor.cyanColor()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        masterView.backgroundColor = UIColor.lightGrayColor()
    }
    

    
    
//    @IBAction func commentButtonDidTouch(sender: UIButton) {
    
        
//        if commentIsVisible == false {
//            
//            println(view.frame)
//            
//            let viewWidth = view.frame.width
//            let viewHeight = view.frame.height
//            let commentView = UIView()
//            let flushYPosition = (viewHeight - 44)
//            let flushKeyboardYPosition = (flushYPosition - 253)
//            
//            // prepare the comment button
//            commentView.backgroundColor = UIColor.blueColor()
//            commentView.frame = CGRect(x: 320, y: flushKeyboardYPosition, width: viewWidth, height: 44)
//            
//            commentTextField.frame = CGRect(x: 8, y: 7, width: viewWidth - 80, height: 30)
//            commentTextField.backgroundColor = UIColor.whiteColor()
//
//
//            submitCommentButton.frame = CGRect(x: viewWidth - 40, y: 7, width: 30, height: 30)
//            submitCommentButton.backgroundColor = UIColor.whiteColor()
//            
//            view.addSubview(commentView)
//            commentView.addSubview(commentTextField)
//            commentView.addSubview(submitCommentButton)
//            
//            self.commentTextField.hidden = false
//            self.commentTextField.becomeFirstResponder()
//            self.commentIsVisible = !self.commentIsVisible
//            
//            
//            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
//                
//                commentView.frame = CGRect(x: 0, y: flushKeyboardYPosition, width: self.view.frame.width, height: 44)
//                
//                
//                }, completion: { finished in
//                    println("You did it.")
//                    
//            })
//            
//        } else {
//            println("Sorry, no.")
//            
//        }
//        
//    }
    
}
