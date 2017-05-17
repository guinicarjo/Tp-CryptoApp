//
//  IDController.swift
//  CryptoApp
//
//  Created by stagiaire on 17/05/2017.
//  Copyright © 2017 guinicarji. All rights reserved.
//

import UIKit
import CoreData
class IDController: UIViewController {
    @IBOutlet weak var idLabel: UILabel!
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        var mavar = 0;
        while(mavar == 0 ){
            print("\(userDefaults.value(forKey: "success") as! String)")
            if(userDefaults.value(forKey: "success") as! String == "true"){
                idLabel.text = "\(userDefaults.value(forKey: "name") as! String)"
                mavar = 1
            }
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
