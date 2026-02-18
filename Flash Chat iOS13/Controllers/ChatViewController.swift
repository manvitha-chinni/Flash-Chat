//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
  
    var messages: [Messages] = [
        Messages(sender: "mvt@ok.com", message: "hey!"),
        Messages(sender: "lokkit@ok.com", message: "hello! how are you?"),
        Messages(sender: "mvt@ok.com", message: "doing wwell, Thanks. a very very very very big message here. let's see how long a message goes and how it will be displayed in the app!!!")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        title = K.appTitle
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            print("firebaseAuth: \(firebaseAuth)")
           try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        Task{
            
            guard let messageBody = messageTextfield.text else{
                print("no message typed")
                return
            }
            guard let messageSender = Auth.auth().currentUser?.email else{
                print("Error: No user logged in currely!!")
                return
            }
            
            do {
                let ref = try await db.collection(K.FStore.collectionName).addDocument(data: [
                    K.FStore.senderField: messageSender,
                    K.FStore.bodyField: messageBody
                ])
                print("Document added with ID: \(ref.documentID)")
            } catch{
                print("Error adding document: \(error)")
            }
        }
    }
    
    

}

extension ChatViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        cell.messageLabel?.text = messages[indexPath.row].message
        return cell
    }
    
}

