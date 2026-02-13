//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        guard let email = emailTextfield.text, !(email.isEmpty) else{
            emailTextfield.placeholder = "Email is required"
            print("email is empty Enter something ")
            return
        }
        
        guard let password = passwordTextfield.text, !(password.isEmpty) else{
            passwordTextfield.placeholder = "Password is required"
            print("password is empty Enter something ")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error{
                print("Some Error while registering \(error)")
                return
            }
            guard let authResult = authResult else{
                print("Failed to create user")
                return
            }
            print("User Created \(authResult.user)")
            self.performSegue(withIdentifier: K.registerSegue, sender: self)
        }
    }
    
}
