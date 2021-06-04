//
//  ViewController.swift
//  DiscoverMusic
//
//  Created by Chang Zeng on 5/30/21.
//

import UIKit

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
    static let CELL_STYLE = "songCellType"
    public var songs : [String] = []
    public var authors : [String] = []


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
        NSLog("\(String(describing: fetchString))")
        let url = URL(string: fetchString)
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "data.json"
        guard url != nil else {
            self.alertMessage(mess: "Empty JSON Error")
            return
        }
        if Reachability().isInternetAvailable() {
            let session = URLSession.shared
                let dataTask = session.dataTask(with: url!) {
                (data, response, error) in
                if error == nil && data != nil {
                    do {
                        let decoder = JSONDecoder()
                        let newSongs = try decoder.decode(SearchResult.self, from: data!)
//                        self.defaults.set(fetchString, forKey: "url")
//                        self.defaults.set(data, forKey:"data")
                        self.resultInfo = newSongs
                        self.songs = []
                        self.authors = []
                        for song in newSongs.results {
                            self.songs.append(song.trackName)
                            self.authors.append(song.artistName)
                        }
                        if directory != nil {
                            let filePath = directory?.appendingPathComponent(fileName)
                            do {
                                try data!.write(to: filePath!, options: Data.WritingOptions.atomic)
                            }
                            catch { self.alertMessage(mess: "cannot save data")}
                        } else {
                            self.alertMessage(mess: "cannot download data")
                        }
                    } catch{
                        self.alertMessage(mess: "Error on Parsing Data")
                    }
                }
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
            dataTask.resume()
        } else {
            alertMessage(mess: "Cannot connect to internet, loading local data")
//            DispatchQueue.global(qos: .userInitiated).async {
//                if directory != nil {
//                    let fileurl = directory?.appendingPathComponent(fileName)
//                    var data: Data? = nil
//                    do {
//                        try data = Data(contentsOf: fileurl!)
//                    }
//                    catch { NSLog(error.localizedDescription) }
//                    if data != nil && data!.count > 0 {
//                        let decoder = JSONDecoder()
//                        do {
//                            let newQuiz = try decoder.decode([Quiz].self, from: data!)
//                            DispatchQueue.main.async {
////                                self.defaults.set(fetchString, forKey: "url")
////                                self.defaults.set(data, forKey:"data")
//                                self.questionInfo = newQuiz
//                                self.quizzes = []
//                                self.subtitle = []
//                                for quiz in newQuiz {
//                                    self.quizzes.append(quiz.title)
//                                    self.subtitle.append(quiz.desc)
//                                }
//                                self.tableView?.reloadData()
//                            }
//                        } catch {
//                            self.alertMessage(mess: "cannot load data from local")
//                        }
//                    }
//                    else {
//                        self.alertMessage(mess: "No internet and no local data")
//                    }
//                }
//            }
        }
    }
    
    @IBAction func search(_ sender: UIButton) {
        let song = String(searchBar.text ?? "")
        NSLog((String(describing: song)))
        fetchData("https://itunes.apple.com/search?limit=10&term=\(song)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let questionSet = indexPath.row
            let questionView = segue.destination as! DetailViewController
//            questionView.sectionNum = questionSet
//            questionView.questionData = questionInfo
//            questionView.url = urlString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        scrollView.delegate = self
        self.scrollView.bounces = false
        self.tableView.bounces = true
        tableView.isScrollEnabled = false
        self.tableView.register(UINib(nibName: "SongResultCell", bundle: nil), forCellReuseIdentifier: "SongResultCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    


}

