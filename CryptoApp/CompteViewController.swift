//
//  CompteViewController.swift
//  CryptoApp
//
//  Created by stagiaire on 15/05/2017.
//  Copyright © 2017 guinicarji. All rights reserved.
//

import UIKit
import LocalAuthentication

class CompteViewController: UIViewController {

    @IBOutlet weak var monSwitch: UISwitch!
    @IBOutlet weak var infoLabel: UILabel!
    
    let maVariableIneffacable:UserDefaults = UserDefaults.standard
    override func viewDidLoad() {
       
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        monSwitch.addTarget(self, action: #selector(verifSwitch), for: UIControlEvents.valueChanged)
    }
    func verifSwitch(){
        if monSwitch.isOn{
            print("ON")
            if #available(iOS 9.0, *) {
                //A partir de iOS 9
                
                let authenticationContext = LAContext()
                var error: NSError?
                
                if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Posez votre doigt sur le capteur d'empreinte pour dévérouiller votre application", reply: { (success: Bool, error: Error?) in
                        
                        if success {
                            //Empreinte OK
                            self.infoLabel.text = "empreinte OK"
                            self.maVariableIneffacable.set(true, forKey: "deverouillerParTouchID")
                                                    } else {
                            //L'utilisateur à annulé ou choisi de rentrer un mot de passe à la place
                            self.infoLabel.text = "empreinte NOK"
                            self.monSwitch.setOn(false, animated: true)
                        }
                        
                    })
                } else {
                    //Si il n'y a pas pas de lecteur d'empreinte digitale
                    self.infoLabel.text = "PAS DE CAPTEUR"
                    self.monSwitch.setOn(false, animated: true)
                }
            } else {
                //Si on est dans iOS inférieur à la version 9.0
                self.infoLabel.text = "Pas géré sur votre version iOS"
                self.monSwitch.setOn(false, animated: true)
            }

        }else {
            print("OFF")
            self.maVariableIneffacable.set(false, forKey: "deverouillerParTouchID")        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
    
}
