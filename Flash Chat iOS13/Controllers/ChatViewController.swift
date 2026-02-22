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
  
    var messages: [Messages] = []
    
    private var listener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //keyborad

        
        //Table
        tableView.dataSource = self
        title = K.appTitle
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        
        loadMessages()
        
    }
    private func loadMessages() {
        listener = db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener(){ [weak self] snapshot, error in
                
            guard let self = self else { return }
                
            if let error = error{
                print("Firestore listener error: \(error)")
                return
            }
                
            guard let snapshotDocs = snapshot?.documents else {return }
            self.messages = []
            for document in snapshotDocs{
                let item = document.data()
                if let sender = item[K.FStore.senderField] as? String,  let msg = item[K.FStore.bodyField] as? String{
                    self.messages.append(Messages(sender: sender, message: msg))
                }
                else{
                    print("I see some error here")
                }
            }
//            print("All the messages: \(self.messages)")
            Task { @MainActor in
                self.tableView.reloadData()
            }
        }
        
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
            
            guard let messageBody = messageTextfield.text, !messageBody.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else{
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
                    K.FStore.bodyField: messageBody,
                    K.FStore.dateField: Date().timeIntervalSince1970
                ])
                print("Document added with ID: \(ref.documentID)")
                await MainActor.run{
//                    self.loadMessages()
                    self.messageTextfield.text = ""
                }
            } catch{
                print("Error adding document: \(error)")
            }
        }
        

    }
    
    
    deinit {
        listener?.remove()
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

