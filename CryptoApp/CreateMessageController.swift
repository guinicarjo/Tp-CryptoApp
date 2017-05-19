//
//  CreateMessageController.swift
//  CryptoApp
//
//  Created by stagiaire on 17/05/2017.
//  Copyright © 2017 guinicarji. All rights reserved.

import UIKit
import CoreData

class CreateMessageController: UIViewController {
    private let kAsymmetricCryptoManagerApplicationTag = "com.AsymmetricCrypto.keypair"
    let userDefaults = UserDefaults.standard
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
    
    @IBAction func submit(_ sender: UIButton) {
        print("\(userDefaults.value(forKey: "token") as? String)")
        let text = messageText.text!
        let dest = contactIdField.text!
        self.APIRequest2(dest: dest);
        let publickeyvar = userDefaults.value(forKey: "publickey") as! String
        let newpublickeyvar = publickeyvar.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        print("\(newpublickeyvar)")
        
        guard let data2 = Data.init(base64Encoded: newpublickeyvar) else {
            return
        }
        
        let keyDict = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrApplicationTag as String: kAsymmetricCryptoManagerApplicationTag,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecReturnRef as String: true,
            ] as [String : Any]
        
        guard let publicKey = SecKeyCreateWithData(data2 as CFData, keyDict as CFDictionary, nil) else {
            return
        }
        print("publicKey2:")
        print("\(publicKey)")
        var cypheredText=""
        AsymmetricCryptoManager.sharedInstance.customEncryptMessageWithPublicKey(text, publickey: publicKey as! SecKey) { (success, data, error) -> Void in
            if success {
                let b64encoded = data!.base64EncodedString(options: [])
                cypheredText = b64encoded
                self.messageText.text = cypheredText
                self.APIRequest(dest: dest,cypheredText: cypheredText);
                guard let encryptedData = Data(base64Encoded: cypheredText, options: [])
                    else
                {
                    
                    return
                }
            }else{
                print("\(error)")
            }
        }
    }
    
    func APIRequest(dest:String,cypheredText:String) {
        let todosEndpoint: String = "http://192.168.33.10:8080/api/message/send"
        
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        let postString = "dest=\(dest)&message=\(cypheredText)"
        todosUrlRequest.httpBody = postString.data(using: .utf8)
               todosUrlRequest.setValue("\(userDefaults.value(forKey: "token") as! String)", forHTTPHeaderField: "Authorization")
        todosUrlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        print("\(cypheredText)")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The todo is: " + receivedTodo.description)
                
                guard let msg = receivedTodo["msg"] as? String else {
                    print("Could not get msg as string from JSON")
                    return
                }
                guard let success = receivedTodo["success"] as? Bool else {
                    print("Could not get success as bool from JSON")
                    return
                }
                self.userDefaults.set("\(msg)", forKey: "msg")
                self.userDefaults.set("\(success)", forKey: "success")
                
                
                
                
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
    }
    func APIRequest2(dest:String) {
        let todosEndpoint: String = "http://192.168.33.10:8080/api/publickey"
        
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        let postString = "name=\(dest)"
        todosUrlRequest.httpBody = postString.data(using: .utf8)
        todosUrlRequest.setValue("\(userDefaults.value(forKey: "token") as! String)", forHTTPHeaderField: "Authorization")
        todosUrlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The todo is: " + receivedTodo.description)
                
                guard let publickey = receivedTodo["publickey"] as? String else {
                    print("Could not get msg as string from JSON")
                    return
                }
                guard let success = receivedTodo["success"] as? Bool else {
                    print("Could not get success as bool from JSON")
                    return
                }
                self.userDefaults.set("\(publickey)", forKey: "publickey")
                self.userDefaults.set("\(success)", forKey: "success")
                print("\(self.userDefaults.value(forKey: "publickey") as! String)")
                
                
                
                
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
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
