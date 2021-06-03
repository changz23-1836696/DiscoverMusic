//
//  ViewController.swift
//  DiscoverMusic
//
//  Created by Chang Zeng on 5/30/21.
//

import UIKit

class SongResultCell : UITableViewCell {
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var author: UILabel!
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    static let CELL_STYLE = "songCellType"
    public var songs : [String] = ["a", "b", "c", "b", "c", "b", "c", "b", "c", "b", "c", "c", "b", "c", "b", "c"]
    public var authors : [String] = ["a", "b", "c", "b", "c", "b", "c", "b", "c", "b", "c", "c", "b", "c", "b", "c"]

    @IBOutlet weak var searchMusic: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    public var screenHeight = UIScreen.main.bounds.height
    public var scrollViewContentHeight = 1200 as CGFloat
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        scrollView.delegate = self
        tableView.delegate = self
        self.scrollView.bounces = false
        self.tableView.bounces = true
        tableView.isScrollEnabled = false
        self.tableView.register(UINib(nibName: "SongResultCell", bundle: nil), forCellReuseIdentifier: "SongResultCell")
        tableView.dataSource = self
        tableView.delegate = self
    }


}

