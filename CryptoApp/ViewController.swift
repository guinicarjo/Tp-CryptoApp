//
//  ViewController.swift
//  CryptoApp
//
//  Created by stagiaire on 15/05/2017.
//  Copyright © 2017 guinicarji. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    let maVariableIneffacable:UserDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let deverouillerParTouchID:Bool = maVariableIneffacable.bool(forKey: "deverouillerParTouchID") as Bool
        
        if deverouillerParTouchID {
            
            if #available(iOS 9.0, *) {
                //A partir de iOS 9
                
                let authenticationContext = LAContext()
                var error: NSError?
                
                if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Posez votre doigt sur le capteur d'empreinte pour dévérouiller votre application", reply: { (success: Bool, error: Error?) in
                        
                        if success {
                            //Empreinte OK
                            self.infoLabel.text = "empreinte OK"
                            self.performSegue(withIdentifier: "allerVers", sender: self)
                        } else {
                            //L'utilisateur à annulé ou choisi de rentrer un mot de passe à la place
                            self.infoLabel.text = "empreinte NOK"
                        }
                        
                    })
                } else {
                    //Si il n'y a pas pas de lecteur d'empreinte digitale
                    self.infoLabel.text = "PAS DE CAPTEUR"
                    performSegue(withIdentifier: "allerVers", sender: self)
                }
            } else {
                //Si on est dans iOS inférieur à la version 9.0
                self.infoLabel.text = "PAS DE GESTION DE L'EMPREINTE DIGITAL"
                performSegue(withIdentifier: "allerVers", sender: self)        }
            
        } else {
            
        }
        if #available(iOS 9.0, *) {
            //A partir de iOS 9
            
            let authenticationContext = LAContext()
            var error: NSError?
            
            if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Posez votre doigt sur le capteur d'empreinte pour dévérouiller votre application", reply: { (success: Bool, error: Error?) in
                    
                    if success {
                        //Empreinte OK
                        self.infoLabel.text = "empreinte OK"
                        self.performSegue(withIdentifier: "allerVers", sender: self)
                    } else {
                        //L'utilisateur à annulé ou choisi de rentrer un mot de passe à la place
                    self.infoLabel.text = "empreinte NOK"
                    }
                    
                })
            } else {
                //Si il n'y a pas pas de lecteur d'empreinte digitale
                self.infoLabel.text = "PAS DE CAPTEUR"
                performSegue(withIdentifier: "allerVers", sender: self)
            }
        } else {
            //Si on est dans iOS inférieur à la version 9.0
            self.infoLabel.text = "PAS DE GESTION DE L'EMPREINTE DIGITAL"
            performSegue(withIdentifier: "allerVers", sender: self)        }
        
        
    }
    
    func demanderMotDePasse() {
        infoLabel.text = "Entrez votre mot de passe"
        //Faire quelque chose pour demander le mot de passe à la place
        //Ce doit être votre propre systeme..
        //...
    }
    
    //Optionel, juste pour mettre des message personalisés, traduisez-les :)
    func getInfoAvecCode(code: Int) -> String {
        var message = ""
        
        /*
         Si code = -9, afficher "Authentication was cancelled by application"
         Si code = -1, afficher "The user failed to provide valid credentials"
         ...etc
         */
        
        switch code {
        case LAError.appCancel.rawValue://-9
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue://-1
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue://-10
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue://..etc
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            //message = "The user chose to use the fallback"
            message = "Entrez le mot de passe"
            
        default:
            message = "Did not find error code on LAError object"
        }
        
        return message    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

