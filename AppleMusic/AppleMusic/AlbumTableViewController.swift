//
//  ViewController.swift
//  AppleMusic
//
//  Created by Lambda_School_Loaner_56 on 11/4/19.
//  Copyright © 2019 David Flack. All rights reserved.
//

import UIKit

class AlbumTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    let networkController = AlbumRequest()
    var listOfAlbums = [AlbumDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.listOfAlbums.count) Albums Found"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView (_ tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int {
        return listOfAlbums.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        let album = listOfAlbums[indexPath.row]
        cell.textLabel?.text = album.name
        cell.detailTextLabel?.text = album.artistName
        networkController.getImage(at: album.artworkUrl100) { result in
            do {
                let albumImage = try result.get()
                DispatchQueue.main.async {
                    cell.imageView?.image = albumImage
                    cell.layoutSubviews()
                }
            } catch {
                print(error)
            }
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailView" {
            if let albumDetailVC = segue.destination as? AlbumDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                
                let album = listOfAlbums[indexPath.row]
                albumDetailVC.album = album
            }
        }
    }
    
    
}

extension AlbumTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        networkController.getXTopAlbums(searchBarText) { [weak self] result in
    
            switch result {
            case .failure(let error):
                print(error)
            case .success(let albums):
                self?.listOfAlbums = albums
            }
             
        }
    }
}

