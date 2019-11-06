//
//  Album.swift
//  AppleMusic
//
//  Created by Lambda_School_Loaner_56 on 11/4/19.
//  Copyright © 2019 David Flack. All rights reserved.
//

import Foundation
import UIKit

struct AlbumResponse:Decodable {
    var feed:Albums
}

struct Albums: Decodable {
    var results:[AlbumDetail]
}

struct AlbumDetail: Decodable {
    var name: String
    var artistName: String
    var releaseDate: String
    var artworkUrl100: URL
    var genres: [GenreInfo]
}

struct GenreInfo: Decodable {
    var name: String
}
