//
//  Models+Character.swift
//  Data
//
//  Created by Marton Kerekes on 07/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Domain
import Realm
import RealmSwift

class CharacterDataWrapper: Object, Codable, Model {
    var code: Int? // The HTTP status code of the returned result.,
    var status: String? // A string description of the call status.,
    var copyright: String? // The copyright notice for the returned result.,
    var attributionText: String? // The attribution notice for this result. Please display either this notice or the contents of the attributionHTML field on all screens which contain data from the Marvel Comics API.,
    var attributionHTML: String? // An HTML representation of the attribution notice for this result. Please display either this notice or the contents of the attributionText field on all screens which contain data from the Marvel Comics API.,
    var data: CharacterDataContainer? //The results returned by the call.,
    var etag: String? // A digest value of the content returned by the call.
    
    typealias Entity = Entities.CharacterDataWrapper
    
    func generateEntity() throws -> Entities.CharacterDataWrapper {
        return try Entities.CharacterDataWrapper(code: code, status: status, copyright: copyright, attributionText: attributionText, attributionHTML: attributionHTML, data: data?.generateEntity(), etag: etag)
    }
    
    required init(from entity: Entities.CharacterDataWrapper) throws {
        code = entity.code
        status = entity.status
        copyright = entity.copyright
        attributionText = entity.attributionText
        attributionHTML = entity.attributionHTML
        if let t = entity.data {
            data = try CharacterDataContainer(from: t)
        }
        etag = entity.etag
        super.init()
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return data?.matches(parameters: parameters) ?? false
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init()
    }
}

class CharacterDataContainer: Object, Codable, Model {
    var offset: Int? // The requested offset (number of skipped results) of the call.,
    var limit: Int? // The requested result limit.,
    var total: Int? // The total number of resources available given the current filter set.,
    var count: Int? // The total number of results returned by this call.,
    var results: [Character]? // The list of characters returned by the call.
    
    typealias Entity = Entities.CharacterDataContainer
    
    func generateEntity() throws -> Entities.CharacterDataContainer {
        return Entities.CharacterDataContainer(offset: offset,
                                               limit: limit,
                                               total: total,
                                               count: count,
                                               results: try results?.compactMap { try $0.generateEntity() })
    }
    
    required init(from entity: Entities.CharacterDataContainer) throws {
        offset = entity.offset
        limit = entity.limit
        total = entity.total
        count = entity.count
        results = try entity.results?.compactMap { try Character(from: $0) }
        super.init()
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return results?.reduce(true, { (result, character) -> Bool in
            return result && character.matches(parameters: parameters)
        }) ?? false
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init()
    }
}

class Character: Object, Codable, Model {
    var id: Int? // The unique ID of the character resource.,
    var name: String? // The name of the character.,
    var desc: String? // A short bio or description of the character.,
    var modified: String? // The date the resource was most recently modified.,
    var resourceURI: String? // The canonical URL identifier for this resource.,
    var urls: [Url]? // A set of web site URLs for the resource.,
    var thumbnail: Image? //The representative image for this character.,
    var comics: ComicList? // A resource list containing comics which feature this character.,
    var stories: StoryList? // A resource list of stories in which this character appears.,
    var events: EventList? // A resource list of events in which this character appears.,
    var series: SeriesList? // A resource list of series in which this character appears.
    
    typealias Entity = Entities.Character
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case desc = "description"
        case modified
        case resourceURI
        case urls
        case thumbnail
        case comics
        case stories
        case events
        case series
    }
    
    func generateEntity() throws -> Entities.Character {
        return Entities.Character(id: id,
                                  name: name,
                                  description: desc,
                                  modified: modified,
                                  resourceURI: resourceURI,
                                  urls: try urls?.compactMap { try $0.generateEntity() },
                                  thumbnail: try thumbnail?.generateEntity(),
                                  comics: try comics?.generateEntity(),
                                  stories: try stories?.generateEntity(),
                                  events: try events?.generateEntity(),
                                  series: try series?.generateEntity())
    }
    
    required init(from entity: Entities.Character) throws {
        id = entity.id
        name = entity.name
        desc = entity.description
        modified = entity.modified
        resourceURI = entity.resourceURI
        urls = try entity.urls?.compactMap { try Url(from: $0) }
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
        super.init()
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return resourceURI == parameters["resourceURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init()
    }
}
