//
//  ViewController.swift
//  CryptoApp
//
//  Created by stagiaire on 15/05/2017.
//  Copyright © 2017 guinicarji. All rights reserved.
//

import UIKit
import LocalAuthentication
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var btnInscription: UIButton!
    @IBOutlet weak var btnConnexion: UIButton!
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        userDefaults.set("", forKey: "token")
        userDefaults.set("", forKey: "success")
        userDefaults.set("", forKey: "name")
        userDefaults.set("", forKey: "mapublickey")

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnConnexion.isHidden = true
        btnInscription.isHidden = true
       
        touchID()
             
    }    
    func touchID(){
        if #available(iOS 9.0, *) {
            //A partir de iOS 9
            
            let authenticationContext = LAContext()
            var error: NSError?
            
            if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Posez votre doigt sur le capteur d'empreinte pour dévérouiller votre application", reply: { (success: Bool, error: Error?) in
                    
                    if success {
                        //Empreinte OK
                        self.btnConnexion.isHidden = false
                        self.btnInscription.isHidden = false
                    } else {
                        //L'utilisateur à annulé ou choisi de rentrer un mot de passe à la place
                        self.touchID()
                    }
                
                })
            } else {
                //Si il n'y a pas pas de lecteur d'empreinte digitale
                btnConnexion.isHidden = false
                btnInscription.isHidden = false            }
        } else {
            //Si on est dans iOS inférieur à la version 9.0
            btnConnexion.isHidden = false
            btnInscription.isHidden = false        }    }
    
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

