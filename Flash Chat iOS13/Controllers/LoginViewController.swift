//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        
        guard let email = emailTextfield.text, !(email.isEmpty) else{
            print("email is empty, Enter something ")
            emailTextfield.placeholder = "Email required"
            return
        }
        guard let password = passwordTextfield.text, !(password.isEmpty) else{
            print("enter some password please...")
            passwordTextfield.placeholder = "Password required"
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error{
                print("Ohh!! there is some login problem: \(error.localizedDescription)")
                return
            }
            guard let authResult = authResult else{
                print(" something wrong, no error and no authRequest....? weired right!")
                return
            }
            print("the authResult: \(authResult)")
            self.performSegue(withIdentifier: K.loginSegue, sender: self)
            
        }
    }
    
}
