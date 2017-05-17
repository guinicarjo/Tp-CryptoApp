//
//  ConnexionController.swift
//  CryptoApp
//
//  Created by stagiaire on 17/05/2017.
//  Copyright © 2017 guinicarji. All rights reserved.
//

import UIKit
import CoreData

class ConnexionController: UIViewController {
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var mdpLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBAction func btnLoging2(_ sender: UIButton) {
        
        APIRequest()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func APIRequest() {
     
        
        let todosEndpoint: String = "http://192.168.33.10:8080/api/authenticate"
        
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        let postString = "name=\(self.nameLabel.text!)&password=\(self.mdpLabel.text!)"
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
                
                guard let token = receivedTodo["token"] as? String else {
                    print("Could not get token as string from JSON")
                    return
                }
                self.userDefaults.set("\(token)", forKey: "token")
                print("The token is: \(token)")
                self.userDefaults.set("\(token)", forKey: "token")
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
