//
//  Song.swift
//  Albums
//
//  Created by Samantha Gatt on 9/1/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation

struct Song: Codable {
    
    // MARK: - Coding keys
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case duration
        
        enum TitleCodingKeys: String, CodingKey {
            case title
        }
        
        enum DurationCodingKeys: String, CodingKey {
            case duration
        }
    }
    
    
    // MARK: - Properties
    
    var title: String
    var duration: String
    
    
    // MARK: - Decoadable
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let titleContainer = try container.nestedContainer(keyedBy: CodingKeys.TitleCodingKeys.self, forKey: .title)
        let durationContainer = try container.nestedContainer(keyedBy: CodingKeys.DurationCodingKeys.self, forKey: .duration)
        
        let title = try titleContainer.decode(String.self, forKey: .title)
        let duration = try durationContainer.decode(String.self, forKey: .duration)
        
        self.title = title
        self.duration = duration
    }
    
    
    // MARK: - Encodable
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var titleContainer = container.nestedContainer(keyedBy: CodingKeys.TitleCodingKeys.self, forKey: .title)
        var durationContainer = container.nestedContainer(keyedBy: CodingKeys.DurationCodingKeys.self, forKey: .duration)
        
        try titleContainer.encode(title, forKey: .title)
        try durationContainer.encode(duration, forKey: .duration)
    }
}
