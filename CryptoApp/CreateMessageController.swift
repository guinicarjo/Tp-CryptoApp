//
//  CreateMessageController.swift
//  CryptoApp
//
//  Created by stagiaire on 17/05/2017.
//  Copyright © 2017 guinicarji. All rights reserved.
//

import UIKit

class CreateMessageController: UIViewController {
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var contactIdField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: Any) {
        let text = messageText.text!
        
        var cypheredText=""
        AsymmetricCryptoManager.sharedInstance.encryptMessageWithPublicKey(text) { (success, data, error) -> Void in
            if success {
                let b64encoded = data!.base64EncodedString(options: [])
                cypheredText = b64encoded
                self.messageText.text = cypheredText
                print(cypheredText)
            
                guard let encryptedData = Data(base64Encoded: cypheredText, options: []) else {
                    print("pas bon")
                    return
                }
                                AsymmetricCryptoManager.sharedInstance.decryptMessageWithPrivateKey(encryptedData) { (success, result, error) -> Void in
                    if success {
                        print(result!)
                        
                    } else {
                        print( "\(error)")
                    }
                    
                }
            }else{
                print("\(error)")
            }
        }
        
        
        
        let contactId = contactIdField.text!
        print(contactId)
        
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
