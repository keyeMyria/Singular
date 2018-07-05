//
//  MessageComposer.swift
//  Singular
//
//  Created by dlr4life on 7/21/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit
import MessageUI

let textMessageRecipients = [""] // for pre-populating the recipients list (optional, depending on your needs)

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    static var scoreData:String!
    static var finalscorelbl: UILabel!
    static var scoreLbl: UILabel!

    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
//        MessageComposer.scoreData = MessageComposer.scoreLbl.text

        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.recipients = textMessageRecipients
        messageComposeVC.body = "I scored xxxx points in the Singular App! Download now to challenge yourself and friends!"
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
