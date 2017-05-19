//
//  ReceiveMessageController.swift
//  CryptoApp
//
//  Created by stagiaire on 19/05/2017.
//  Copyright © 2017 guinicarji. All rights reserved.
//

import UIKit
import CoreData

class ReceiveMessageController: UIViewController {
    let userDefaults = UserDefaults.standard
    var monMessage = ""
    private let kAsymmetricCryptoManagerApplicationTag = "com.AsymmetricCrypto.keypair"
    @IBOutlet weak var messageReceiveLabel: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        APIRequest()
         DispatchQueue.main.async {
            
            guard let encryptData = Data(base64Encoded: self.monMessage, options: []) else {
                print("base64")
                return
            }
            AsymmetricCryptoManager.sharedInstance.decryptMessageWithPrivateKey(encryptData) { (success, result, error) -> Void in
                if success {
                    self.messageReceiveLabel.text = result!
                } else {
                    print("\(error)")
                }
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func APIRequest() {
        let todosEndpoint: String = "http://192.168.33.10:8080/api/message/receive"
        
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
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
                
                guard let msg = receivedTodo["message"] as? String else {
                    print("Could not get msg as string from JSON")
                    return
                }
                
                let newmsgvar2 = msg.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
                self.monMessage = newmsgvar2
                print("\(newmsgvar2)")
                
                
                
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
