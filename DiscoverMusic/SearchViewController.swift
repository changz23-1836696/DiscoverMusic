//
//  ViewController.swift
//  DiscoverMusic
//
//  Created by Chang Zeng on 5/30/21.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SearchResult: Codable{
    let resultCount: UInt
    let results: [Song]
}

struct Song: Codable{
    let artistName: String
    let collectionName: String
    let trackName: String
    let artworkUrl100: String
}

class SongResultCell : UITableViewCell {
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var author: UILabel!
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    public var db: Firestore!
    static let CELL_STYLE = "songCellType"
    public var songs : [String] = []
    public var authors : [String] = []
    public var rating: [UInt] = []
    public var searchTime: [UInt] = []


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBar: UITextField!
    
    public var screenHeight = UIScreen.main.bounds.height
    public var scrollViewContentHeight = 1200 as CGFloat
    public var resultInfo : SearchResult? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SongResultCell = self.tableView.dequeueReusableCell(withIdentifier: SearchViewController.CELL_STYLE) as! SongResultCell
        cell.name?.text = songs[indexPath.row]
        cell.author?.text = authors[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            tableView.isScrollEnabled = (self.scrollView.contentOffset.y >= 200)
        }

        if scrollView == self.tableView {
            self.tableView.isScrollEnabled = (tableView.contentOffset.y > 0)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func alertMessage(mess: String) {
        let controller = UIAlertController(title: "Error", message: mess, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Good to go"), style: .default, handler: {
            _ in NSLog("k")
        }))
        present(controller, animated: true, completion: {NSLog("kk")})
    }
    
    func fetchData(_ fetchString: String) {
        db.collection("MusicCollections").document(fetchString).getDocument { (querySnapshot, err) in
            if let document = querySnapshot, document.exists {
                self.songs.append(document.documentID)
                self.authors.append(document.data()?["artist"] as! String)
                self.rating.append(document.data()?["rating"] as! UInt)
                self.searchTime.append(document.data()?["searchTime"] as! UInt)
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            } else {
                self.alertMessage(mess: "Song not found")
                }
        }
//        NSLog("\(String(describing: fetchString))")
//        let url = URL(string: fetchString)
//
//        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//        let fileName = "data.json"
//        guard url != nil else {
//            self.alertMessage(mess: "Empty JSON Error")
//            return
//        }
//        if Reachability().isInternetAvailable() {
//            let session = URLSession.shared
//                let dataTask = session.dataTask(with: url!) {
//                (data, response, error) in
//                if error == nil && data != nil {
//                    do {
//                        let decoder = JSONDecoder()
//                        let newSongs = try decoder.decode(SearchResult.self, from: data!)
////                        self.defaults.set(fetchString, forKey: "url")
////                        self.defaults.set(data, forKey:"data")
//                        self.resultInfo = newSongs
//                        self.songs = []
//                        self.authors = []
//                        for song in newSongs.results {
//                            self.songs.append(song.trackName)
//                            self.authors.append(song.artistName)
//                        }
//                        if directory != nil {
//                            let filePath = directory?.appendingPathComponent(fileName)
//                            do {
//                                try data!.write(to: filePath!, options: Data.WritingOptions.atomic)
//                            }
//                            catch { self.alertMessage(mess: "cannot save data")}
//                        } else {
//                            self.alertMessage(mess: "cannot download data")
//                        }
//                    } catch{
//                        self.alertMessage(mess: "Error on Parsing Data")
//                    }
//                }
//                DispatchQueue.main.async{
//                    self.tableView.reloadData()
//                }
//            }
//            dataTask.resume()
//        } else {
//            alertMessage(mess: "Cannot connect to internet")
//        }
    }
    
    @IBAction func search(_ sender: UIButton) {
        let song = String(searchBar.text ?? "")
        NSLog((String(describing: song)))
        fetchData(song)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let questionSet = indexPath.row
            let questionView = segue.destination as! DetailViewController
            questionView.song = songs[questionSet]
            questionView.author = authors[questionSet]
            questionView.rating = rating[questionSet]
        }
    }
    
    private func getCollection() {
        db.collection("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        songs = []
        authors = []
        rating = []
        searchTime = []
        scrollView.delegate = self
        self.scrollView.bounces = false
        self.tableView.bounces = true
        tableView.isScrollEnabled = false
        self.tableView.register(UINib(nibName: "SongResultCell", bundle: nil), forCellReuseIdentifier: "SongResultCell")
        tableView.dataSource = self
        tableView.delegate = self
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    


}

