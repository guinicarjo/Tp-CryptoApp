//
//  RegisterController.swift
//  CryptoApp
//
//  Created by stagiaire on 16/05/2017.
//  Copyright © 2017 guinicarji. All rights reserved.
//

import UIKit
import CoreData

class RegisterController: UIViewController {
    @IBOutlet weak var btn_register: UIButton!
    let userDefaults = UserDefaults.standard
    var b64Key:String = ""
    var b64encoded:String = ""
    @IBOutlet weak var password: UITextField!
    
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
                        let publicKeyRef = AsymmetricCryptoManager.sharedInstance.getPublicKeyReference();
                        
                        var error:Unmanaged<CFError>?
                        if let cfdata = SecKeyCopyExternalRepresentation(publicKeyRef!, &error) {
                            let data:Data = cfdata as Data
                            self.b64Key = data.base64EncodedString()
                            print("public key : ")
                            print("\(self.b64Key)")
                        }
                        
                        
                        //self.b64encoded = publicKeyRef.base64EncodedString(options: [])

                        // Push to database here
                        self.APIRequest()
                    } else {
                        print("An error happened while generating a keypair: \(error)")
                    }
                })
                
            }
        }
        
    }
    
    
    func APIRequest() {

        btn_register.isHidden = true
        DispatchQueue.main.async {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "IDController") as! IDController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        let todosEndpoint: String = "http://192.168.33.10:8080/api/signup"
        
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"

        let postString = "password=\(self.password.text!)&publickey=\(self.b64Key)"
        print("\(postString)")
        todosUrlRequest.httpBody = postString.data(using: .utf8)
        
        
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
                
                guard let name = receivedTodo["name"] as? String else {
                    print("Could not get token as string from JSON")
                    return
                }
                guard let success = receivedTodo["success"] as? Bool else {
                    print("Could not get success as bool from JSON")
                    return
                }
                self.userDefaults.set("\(name)", forKey: "name")
               self.userDefaults.set("\(success)", forKey: "success")
                
                print("\(name)")
                print("\(self.userDefaults.value(forKey: "success"))")
                
                
            

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
