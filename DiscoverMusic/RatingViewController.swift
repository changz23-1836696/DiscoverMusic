//
//  RatingViewController.swift
//  DiscoverMusic
//
//  Created by Chang Zeng on 6/4/21.
//

import UIKit
import Firebase

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
        let dataToSave : [String: Any] = ["comment": postText, "rating": rating, "musicID": MusicID, "userID": userID]
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
    @IBOutlet weak var textView: UITextView!
    var newRate:Int = 0
    var docRef : CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().collection("CommentHistory")
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
        newPost.uploadPost(Ref: docRef, userID: "test uid", MusicID: "test mid")
//        let dataToSave: [String: Any] = ["rating": 1, "comment": "test comment message"]
//        docRef = Firestore.firestore().document("CommentHistory/test")
//        docRef.setData(dataToSave) {(error) in
//            if let error = error {
//                print("Oh no! Got an error: \(error.localizedDescription)")
//            } else {
//                print("Data have been saved!")
//            }
//        }
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
