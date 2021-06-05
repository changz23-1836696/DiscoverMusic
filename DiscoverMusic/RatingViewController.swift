//
//  RatingViewController.swift
//  DiscoverMusic
//
//  Created by Chang Zeng on 6/4/21.
//

import UIKit

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
}

class RatingViewController: UIViewController {
    
    @IBOutlet var starButtons: [UIButton]!
    @IBOutlet weak var ratingMessage: UILabel!
    @IBOutlet weak var textView: UITextView!
    var newRate:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
