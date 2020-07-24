//
//  ListViewController.swift
//  TheMovieWithAlamofire
//
//  Created by MM on 7/23/20.
//  Copyright © 2020 MM. All rights reserved.
//

import UIKit
import Alamofire

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        
        getList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "List"
    }
    
    func getList() {
        let params = [
            "api_key": API().apiKey
        ]
        AF.request("https://api.themoviedb.org/3/movie/popular", method: .get, parameters: params).responseJSON { (response) in
            if let data = response.data {
                let json = JSONDecoder()
                var nowPlaying: NowPlaying? = nil
                do {
                    nowPlaying = try json.decode(NowPlaying.self, from: data)
                } catch {
                    print(error)
                }
                print(nowPlaying)
            }
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        return cell
    }
    
}
