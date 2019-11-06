//
//  AlbumDetailViewController.swift
//  AppleMusic
//
//  Created by Lambda_School_Loaner_56 on 11/4/19.
//  Copyright © 2019 David Flack. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    @IBOutlet weak var albumDate: UILabel!
    @IBOutlet weak var albumGenre: UILabel!
    
    let networkController = AlbumRequest()
    
    var album: AlbumDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    func updateViews() {
        if let unwrappedAlbum = album {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"

            let date = dateFormatterGet.date(from: unwrappedAlbum.releaseDate)
            
            
            albumName.text = unwrappedAlbum.name
            albumArtist.text = "Album by " + unwrappedAlbum.artistName
            albumGenre.text = unwrappedAlbum.genres[0].name
            albumDate.text = dateFormatter.string(from: date!)
            networkController.getImage(at: unwrappedAlbum.artworkUrl100) { result in
                do {
                    let albumImg = try result.get()
                    DispatchQueue.main.async {
                        self.albumImage?.image = albumImg
                    }
                } catch {
                    print(error)
                }
            }
        }
    }

}
