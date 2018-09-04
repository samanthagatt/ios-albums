//
//  Album.swift
//  Albums
//
//  Created by Samantha Gatt on 8/31/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation

struct Album: Codable {
    
    // MARK: - Coding keys
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case artist
        case genres
        case urls = "coverArt"
        case songs
        
        enum URLsCodingKeys: String, CodingKey {
            case url
        }
    }
    
    
    // MARK: - Properties
    
    var title: String
    var artist: String
    var genres: [String]
    var urls: [URL]
    var songs: [Song]
    
    
    // MARK: - Decodable
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        let artist = try container.decode(String.self, forKey: .artist)
        
        var genres: [String] = []
        var genresContainer = try container.nestedUnkeyedContainer(forKey: .genres)
        while !genresContainer.isAtEnd {
            let genre = try genresContainer.decode(String.self)
            genres.append(genre)
        }
        
        var urlStrings: [String] = []
        var urlsContainer = try container.nestedUnkeyedContainer(forKey: .urls)
        while !urlsContainer.isAtEnd {
            let urlContainer = try urlsContainer.nestedContainer(keyedBy: CodingKeys.URLsCodingKeys.self)
            let urlString = try urlContainer.decode(String.self, forKey: .url)
            urlStrings.append(urlString)
        }
        let urls = urlStrings.compactMap { URL(string: $0) }
        
        var songs: [Song] = []
        var songsContainer = try container.nestedUnkeyedContainer(forKey: .songs)
        while !songsContainer.isAtEnd {
            let song = try songsContainer.decode(Song.self)
            songs.append(song)
        }
        
        self.title = title
        self.artist = artist
        self.genres = genres
        self.urls = urls
        self.songs = songs
    }
    
    
    // MARK: - Encodable
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(artist, forKey: .artist)
        
        var genreContainer = container.nestedUnkeyedContainer(forKey: .genres)
        for genre in genres {
            try genreContainer.encode(genre)
        }
        
        var urlsContainer = container.nestedUnkeyedContainer(forKey: .urls)
        for url in urls {
            var urlContainer = urlsContainer.nestedContainer(keyedBy: CodingKeys.URLsCodingKeys.self)
            try urlContainer.encode(url, forKey: .url)
        }
        
        var songsContainer = container.nestedUnkeyedContainer(forKey: .songs)
        for song in songs {
            try songsContainer.encode(song)
        }
    }
}
