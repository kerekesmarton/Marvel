//
//  EntitiesFactory.swift
//  Domain
//
//  Created by Marton Kerekes on 07/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation

public extension Entities {
    
    static func characters(_ results: [Character]) -> Entities.CharacterDataWrapper {
        
        let container = CharacterDataContainer(offset: nil, limit: nil, total: nil, count: nil, results: results)
        
        return CharacterDataWrapper(code: nil,
                                    status: nil,
                                    copyright: nil,
                                    attributionText: nil,
                                    attributionHTML: nil,
                                    data: container,
                                    etag: nil)
    }
    
    static var johnAppleseed: Entities.Character {
        return Entities.Character(id: nil,
                                  name: "John Appleseed",
                                  description: "This is John",
                                  modified: nil,
                                  resourceURI: "http://gateway.marvel.com/v1/public/comics/55093",
                                  urls: [Url(type: "detail", url: "http://marvel.com/comics/series/20359/a-force_presents_vol_1_2015?utm_campaign=apiRef&utm_source=4b3d281d06587a0d8d0c8d0b3c3b2628")],
                                  thumbnail: Entities.Image(path: "http://i.annihil.us/u/prod/marvel/i/mg/5/a0/570bde5514b01", extension: "jpg"),
                                  comics: nil,
                                  stories: nil,
                                  events: nil,
                                  series: nil)
    }
    
    static var billAppleseed: Entities.Character {
        return Entities.Character(id: nil,
                                  name: "Bill Appleseed",
                                  description: "This is Bill",
                                  modified: nil,
                                  resourceURI: "http://gateway.marvel.com/v1/public/comics/55094",
                                  urls: [Url(type: "detail", url: "http://marvel.com/comics/series/20359/a-force_presents_vol_1_2015?utm_campaign=apiRef&utm_source=4b3d281d06587a0d8d0c8d0b3c3b2628")],
                                  thumbnail: Entities.Image(path: "http://i.annihil.us/u/prod/marvel/i/mg/5/a0/570bde5514b01", extension: "jpg"),
                                  comics: nil,
                                  stories: nil,
                                  events: nil,
                                  series: nil)
    }
    
    static var adamAppleseed: Entities.Character {
        return Entities.Character(id: nil,
                                  name: "Adam Appleseed",
                                  description: "This is Bill",
                                  modified: nil,
                                  resourceURI: "http://gateway.marvel.com/v1/public/comics/55095",
                                  urls: [Url(type: "detail", url: "http://marvel.com/comics/series/20359/a-force_presents_vol_1_2015?utm_campaign=apiRef&utm_source=4b3d281d06587a0d8d0c8d0b3c3b2628")],
                                  thumbnail: Entities.Image(path: "http://i.annihil.us/u/prod/marvel/i/mg/5/a0/570bde5514b01", extension: "jpg"),
                                  comics: nil,
                                  stories: nil,
                                  events: nil,
                                  series: nil)
    }
    
    
}
