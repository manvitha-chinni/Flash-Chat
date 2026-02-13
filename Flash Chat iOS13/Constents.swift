//
//  Untitled.swift
//  Flash Chat iOS13
//
//  Created by Manvitha on 13/02/26.
//  Copyright © 2026 Angela Yu. All rights reserved.
//



//enum Consts: String {
//    case RegisterToChat
//    case LoginToChat
//    case ReusableCell
//    case MessageCell
//}
//
//enum BrandColors: String {
//    case BrandPurple
//    case BrandLightPurple
//    case BrandBlue
//    case BrandLightBlue
//}
//enum FStore{
//    case messages
//    case sender
//    case body
//    case date
//}


struct K {
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let appTitle = "⚡️FlashChat⚡️"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}

