//
//  RegisterController.swift
//  CryptoApp
//
//  Created by stagiaire on 16/05/2017.
//  Copyright © 2017 guinicarji. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btn_register: UIButton!
    @IBOutlet weak var password_confirmation: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        if ( password.text == password_confirmation.text){
            if(password.text != nil){
                //print("\(String(describing: password.text))")
                
                // Generate key pair
                AsymmetricCryptoManager.sharedInstance.createSecureKeyPair({ (success, error) -> Void in
                    if success {
                        print("RSA-2048 keypair successfully generated.")
                        let publicKey = AsymmetricCryptoManager.sharedInstance.getPublicKeyReference();
                        print(publicKey!)
                    } else {
                        print("An error happened while generating a keypair: \(error)")
                    }
                })
            }
        }
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
