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

struct CommentHistory: Codable{
    let song: String
    let comment: String
    let rating: String

//
//    init(snapshot: QueryDocumentSnapshot) {
//        let snapshotValue = snapshot.data()
//        song = snapshotValue["musicID"] as? String ?? "not found"
//        comment = snapshotValue["comment"] as? String ?? "not found"
//        rating = snapshotValue["rating"] as? String ?? "not found"
//    }
}

class CommentHistoryCell : UITableViewCell {
    
    @IBOutlet weak var songLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    

}


class LoggedInViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    static let CELL_STYLE = "commentHistoryTC"
    @IBOutlet weak var commentHisTable: UITableView!
    var uid:String = ""
    public var fName : String = ""
    public var lName : String = ""
//    public var musics : [String] = []
//    public var ratings : [String] = []
//    public var comments : [String] = []
    
//    public var cid : [String] = []

    public var songs: [String] = []
    public var ratings: [String] = []
    public var comments: [String] = []
    public var cnt = 0
    override func viewDidLoad() {
        
   
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.commentHisTable.dataSource = self
        self.commentHisTable.delegate = self
        self.commentHisTable.rowHeight = 80
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
//                    self.cid = document.data()?["cid"] as! [String]
                
                // display User info
                self.setWelcome()
                    self.fetchComment(fetchString: self.uid)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("printing count songs")
//        print(self.cnt)
        return self.cnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("printing comment history source songs")
//        print(songs)
        let cell = tableView.dequeueReusableCell(withIdentifier: LoggedInViewController.CELL_STYLE, for: indexPath) as! CommentHistoryCell
        
  
        cell.songLabel?.text = self.songs[indexPath.row]
        cell.ratingLabel?.text = self.ratings[indexPath.row]
        cell.commentLabel?.text = self.comments[indexPath.row]
        return cell
    }
    
    @IBOutlet weak var welcomeMsg: UILabel!

    
    func setWelcome() {
        self.welcomeMsg.alpha = 1
        self.welcomeMsg.text = "Welcome, " + self.fName
    }
    
    func fetchComment(fetchString: String) {

        let db = Firestore.firestore()
        db.collection("CommentHistory").whereField("userID", isEqualTo: fetchString).getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if (querySnapshot!.documents == []) {
                    print("No comments here")
                }
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    print("printing self.data.songs")
                    print(self.songs)
                    self.songs.append(document.data()["musicID"] as! String)
                    self.ratings.append(document.data()["rating"] as! String)
                    self.comments.append(document.data()["comment"] as! String)
                }
                
                self.cnt = self.songs.count
//                print("count before calling table count:")
//                print(self.cnt)
                DispatchQueue.main.async{
                    self.commentHisTable.reloadData()
                }
            }
        }
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


//class CommentHistorySource : NSObject, UITableViewDataSource {
////    public var fullData: [CommentHistory] = []
//    public var songs: [String] = []
//    public var ratings: [String] = []
//    public var comments: [String] = []
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return songs.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell : CommentHistoryCell = tableView.dequeueReusableCell(withIdentifier: LoggedInViewController.CELL_STYLE, for: indexPath) as! CommentHistoryCell
//        print("printing comment history source songs")
//        print(songs)
//
//        cell.songLabel?.text = songs[indexPath.row]
//        cell.ratingLabel?.text = ratings[indexPath.row]
//        cell.commentLabel?.text = comments[indexPath.row]
//        return cell
//    }
//}
//
//class CommentHistorySelector: NSObject, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 10.0
//    }
//}
//
//class LoggedInViewController: UIViewController {
//    var data = CommentHistorySource()
//    let actor = CommentHistorySelector()
//    static let CELL_STYLE = "commentHistoryTC"
//    @IBOutlet weak var commentHisTable: UITableView!
//    var uid:String = ""
//    public var fName : String = ""
//    public var lName : String = ""
////    public var musics : [String] = []
////    public var ratings : [String] = []
////    public var comments : [String] = []
//
////    public var cid : [String] = []
//
//
//    @IBOutlet weak var welcomeMsg: UILabel!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        self.commentHisTable.dataSource = data
//        self.commentHisTable.delegate = actor
//            self.uid = UserInfo.sharedInstance.uid
//            if !self.uid.isEmpty {
//                let db = Firestore.firestore()
//                //get user info
//                let docRef = db.collection("users").document(self.uid)
//
//                docRef.getDocument { (document, error) in
//                    if let document = document, document.exists {
//
//                    // recording user info
//                    self.uid = document.documentID
//                    self.fName = document.data()?["fName"] as! String
//                    self.lName = document.data()?["lName"] as! String
////                    self.cid = document.data()?["cid"] as! [String]
//
//                    // display User info
//                    self.setWelcome()
//                        self.fetchComment(fetchString: self.uid)
////                    self.printInfos()
//
//                    } else {
//                        print("Document does not exist")
//                    }
//                }
//
//
////                registerBtn.isHidden = true
////                loginBtn.isHidden = true
//            } else {
//                welcomeMsg.alpha = 0
//            }
//
//
//
//    }
//
//    func setWelcome() {
//        self.welcomeMsg.alpha = 1
//        self.welcomeMsg.text = "Welcome, " + self.fName
//    }
//
//    func fetchComment(fetchString: String) {
//        self.data.songs.append("hahahahahahhaa")
//        self.data.ratings.append("hahahahahahhaa")
//        self.data.comments.append("hahahahahahhaa")
//
//        let db = Firestore.firestore()
//        db.collection("CommentHistory").whereField("userID", isEqualTo: fetchString).getDocuments{ (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                if (querySnapshot!.documents == []) {
//                    print("No comments here")
//                }
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                    print("printing self.data.songs")
//                    print(self.data.songs)
//                    self.data.songs.append(document.data()["musicID"] as! String)
//                    self.data.ratings.append(document.data()["rating"] as! String)
//                    self.data.comments.append(document.data()["comment"] as! String)
//                }
//                self.commentHisTable.reloadData()
////                DispatchQueue.main.async{
////                    self.result.text = self.songs + "                  " + self.authors
////                }
//            }
//        }
//    }
//
////    func printInfos() {
////        print(self.cid)
////
////    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}



