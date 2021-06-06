//
//  RatingViewController.swift
//  DiscoverMusic
//
//  Created by Chang Zeng on 6/4/21.
//

import UIKit
import Firebase
import FirebaseAuth

struct post {
    var rating: Int
    var postText: String
    init(rate: Int, text: String){
        rating = rate
        postText = text
    }
    func printPost(){
        print("this is music is commented as '\(postText)' with as rating of \(rating)") 
    }
    func uploadPost(Ref: CollectionReference, userID: String, MusicID: String){
        let dataToSave : [String: Any] = ["comment": postText, "rating": String(rating), "musicID": MusicID, "userID": userID]
        Ref.addDocument(data: dataToSave) {(error) in
            if let error = error {
                print("Oh no! Got an error: \(error.localizedDescription)")
            } else {
                print("Data have been saved!")
            }
        }
    }
}

class RatingViewController: UIViewController {
    
    @IBOutlet var starButtons: [UIButton]!
    @IBOutlet weak var ratingMessage: UILabel!
    @IBOutlet weak var musicName: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var musicID: String = ""
    var userID: String = ""
    var newRate:Int = 0
    var docRef : CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicName.text = "Music: \(musicID)"
        docRef = Firestore.firestore().collection("CommentHistory")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
              // The user's ID, unique to the Firebase project.
              // Do NOT use this value to authenticate with your backend server,
              // if you have one. Use getTokenWithCompletion:completion: instead.
                self.userID = user.uid
                print(self.userID)
            }

        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        print("Rated \(sender.tag) stars")
        ratingMessage.text = ("You rated this music \(sender.tag) stars")
        newRate = sender.tag
        for button in starButtons{
            if button.tag <= sender.tag{
                button.setBackgroundImage(UIImage.init(named: "starFill"), for: .normal) //selected
            }else{
                button.setBackgroundImage(UIImage.init(named: "star"), for: .normal) //not selected
            }
        }
    }
    @IBAction func uploadButton(_ sender: UIButton) {
        let newPost = post(rate: newRate, text: textView.text)
        newPost.printPost()
        newPost.uploadPost(Ref: docRef, userID: userID, MusicID: musicID)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
