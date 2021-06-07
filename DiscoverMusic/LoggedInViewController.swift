//
//  LoggedInViewController.swift
//  DiscoverMusic
//
//  Created by Danfeng Yang on 6/5/21.
//

import UIKit
import Firebase

//struct user {
//
//    var uid: String
//    var fName: String
//    var lName: String
//    init(uidUser: String, fNameUser: String, lNameUser: String){
//        uid = uidUser
//        fName = fNameUser
//        lName = lNameUser
//    }
//
//}

class LoggedInViewController: UIViewController {
    var uid:String = ""
    public var fName : String = ""
    public var lName : String = ""
    public var cid : [String] = []

    
    @IBOutlet weak var welcomeMsg: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
            self.uid = UserInfo.sharedInstance.uid
            if !self.uid.isEmpty {
                let db = Firestore.firestore()
                //get user info
                let docRef = db.collection("users").document(self.uid)

                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        
                    // recording user info
                    self.uid = document.documentID
                    self.fName = document.data()?["fName"] as! String
                    self.lName = document.data()?["lName"] as! String
                    self.cid = document.data()?["cid"] as! [String]
                    
                    // display User info
                    self.setWelcome()
//                    self.printInfos()

                    } else {
                        print("Document does not exist")
                    }
                }
                
                
//                registerBtn.isHidden = true
//                loginBtn.isHidden = true
            } else {
                welcomeMsg.alpha = 0
            }
        
        
        
    }
    
    func setWelcome() {
        self.welcomeMsg.alpha = 1
        self.welcomeMsg.text = "Welcome, " + self.fName
    }
//    func printInfos() {
//        print(self.cid)
//
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
