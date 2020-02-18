//
//  Models+Character.swift
//  Data
//
//  Created by Marton Kerekes on 07/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Domain
import Data
import MarvelDomain
import Realm
import RealmSwift


class CharacterDataWrapper: Wrapper, Model {
    @objc dynamic var data: CharacterDataContainer? //The results returned by the call.,
    @objc dynamic var id = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    typealias Entity = Entities.CharacterDataWrapper
    
    func generateEntity() throws -> Entities.CharacterDataWrapper {
        return try Entities.CharacterDataWrapper(code: code, status: status, copyright: copyright, attributionText: attributionText, attributionHTML: attributionHTML, data: data?.generateEntity(), etag: etag)
    }
    
    required init(from entity: Entities.CharacterDataWrapper) throws {
        if let t = entity.data {
            data = try CharacterDataContainer(from: t)
        }
        super.init(code: entity.code,
                   status: entity.status,
                   copyright: entity.copyright,
                   attributionText: entity.attributionText,
                   attributionHTML: entity.attributionHTML,
                   etag: entity.etag)
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return id == parameters["id"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CharacterCodingKeys.self)
        data = try container.decodeIfPresent(CharacterDataContainer.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CharacterCodingKeys.self)
        try container.encode(data, forKey: .data)
        try super.encode(to: encoder)
    }
    
    enum CharacterCodingKeys: String, CodingKey {
        case data
    }
    
}

class CharacterDataContainer: Container, Model {
    let results = List<Character>() // The list of characters returned by the call.
    
    typealias Entity = Entities.CharacterDataContainer
    
    func generateEntity() throws -> Entities.CharacterDataContainer {
        return Entities.CharacterDataContainer(offset: offset,
                                               limit: limit,
                                               total: total,
                                               count: count,
                                               results: try results.compactMap { try $0.generateEntity() })
    }
    
    required init(from entity: Entities.CharacterDataContainer) throws {
        if let t = try entity.results?.compactMap { try Character(from: $0) } {
            results.append(objectsIn: t)
        }
        super.init(offset: entity.offset, limit: entity.limit, total: entity.total, count: entity.count)
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return results.reduce(true, { (result, character) -> Bool in
            return result && character.matches(parameters: parameters)
        })
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let t = try container.decodeIfPresent([Character].self, forKey: .results) {
            results.append(objectsIn: t)
        }
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(results.compactMap { $0 }, forKey: .results)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
}

class Character: CodableCharacter, Model {
    let urls = List<Url>() // A set of web site URLs for the resource.,
    
    typealias Entity = Entities.Character
    
    func generateEntity() throws -> Entities.Character {
        
        return Entities.Character(id: id,
                                  name: name,
                                  description: desc,
                                  modified: modified,
                                  resourceURI: resourceURI,
                                  urls: try urls.compactMap { try $0.generateEntity() },
                                  thumbnail: try thumbnail?.generateEntity(),
                                  comics: try comics?.generateEntity(),
                                  stories: try stories?.generateEntity(),
                                  events: try events?.generateEntity(),
                                  series: try series?.generateEntity())
    }
    
    required init(from entity: Entities.Character) throws {
        if let t = try entity.urls?.compactMap { try Url(from: $0) } {
            urls.append(objectsIn: t)
        }
        super.init()
        
        id = entity.id ?? 0
        name = entity.name ?? ""
        desc = entity.description ?? ""
        modified = entity.modified ?? ""
        resourceURI = entity.resourceURI ?? ""
        if let t = entity.thumbnail {
            thumbnail = try Image(from: t)
        }
        if let t = entity.comics {
            comics = try ComicList(from: t)
        }
        if let t = entity.stories {
            stories = try StoryList(from: t)
        }
        if let t = entity.events {
            events = try EventList(from: t)
        }
        if let t = entity.series {
            series = try SeriesList(from: t)
        }
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return resourceURI == parameters["resourceURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CharacterCodingKeys.self)
        if let t = try container.decodeIfPresent([Url].self, forKey: .urls) {
            urls.append(objectsIn: t)
        }
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CharacterCodingKeys.self)
        try container.encode(urls.compactMap { $0 }, forKey: .urls)
        try super.encode(to: encoder)
    }
    
    enum CharacterCodingKeys: String, CodingKey {
        case urls        
    }
    
    
}

class CodableCharacter: Object, Codable {
    @objc dynamic var id: Int = 0 // The unique ID of the character resource.,
    @objc dynamic var name = "" // The name of the character.,
    @objc dynamic var desc = "" // A short bio or description of the character.,
    @objc dynamic var modified = "" // The date the resource was most recently modified.,
    @objc dynamic var resourceURI = "" // The canonical URL identifier for this resource.,
    @objc dynamic var thumbnail: Image? //The representative image for this character.,
    @objc dynamic var comics: ComicList? // A resource list containing comics which feature this character.,
    @objc dynamic var stories: StoryList? // A resource list of stories in which this character appears.,
    @objc dynamic var events: EventList? // A resource list of events in which this character appears.,
    @objc dynamic var series: SeriesList? // A resource list of series in which this character appears.
    
    override class func primaryKey() -> String? {
        return "resourceURI"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case desc = "description"
        case modified
        case resourceURI
        case thumbnail
        case comics
        case stories
        case events
        case series
    }
}
