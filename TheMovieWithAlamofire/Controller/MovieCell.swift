//
//  MovieCell.swift
//  TheMovieWithAlamofire
//
//  Created by MM on 7/24/20.
//  Copyright © 2020 MM. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var imvPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblVoteAverage: UILabel!
    @IBOutlet weak var lblVoteCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imvPoster.image = nil
    }
    
    func setupCell() {
        self.selectionStyle = .none
    }
    
    func configWithResult(_ result: Results?) {
        guard let result = result else {
            return
        }
        guard let average = result.vote_average else {
            return
        }
        guard let count = result.vote_count else {
            return
        }
        guard let posterPath = result.poster_path else {
            return
        }
        lblTitle.text = result.title
        lblVoteAverage.text =  String(describing: average)
        lblVoteCount.text =  String(describing: count)
        let string = "https://image.tmdb.org/t/p/w185\(posterPath)"
        imvPoster.downloaded(from: string)
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
