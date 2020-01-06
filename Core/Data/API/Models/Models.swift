//
//  Models.swift
//  Data
//
//  Created by Marton Kerekes on 03/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Domain
import Realm
import RealmSwift

class Character: Object, Codable, Model {
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
    
    var id: Int? // The unique ID of the character resource.,
    var name: String? // The name of the character.,
    var desc: String? // A short bio or description of the character.,
    var modified: String? // The date the resource was most recently modified.,
    var resourceURI: String? // The canonical URL identifier for this resource.,
    var urls: [Url]? // A set of public web site URLs for the resource.,
    var thumbnail: Image? //The representative image for this character.,
    var comics: ComicList? // A resource list containing comics which feature this character.,
    var stories: StoryList? // A resource list of stories in which this character appears.,
    var events: EventList? // A resource list of events in which this character appears.,
    var series: SeriesList? // A resource list of series in which this character appears.
    
    typealias Entity = Entities.Character
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case desc = "description"
        case modified = "modified"
        case resourceURI = "resourceURI"
        case urls = "urls"
        case thumbnail = "thumbnail"
        case comics = "comics"
        case stories = "stories"
        case events = "events"
        case series = "series"
    }
}

class Url: Object, Codable, Model {
    func generateEntity() throws -> Entities.Url {
        return Entities.Url(type: type, url: url)
    }
    
    required init(from entity: Entities.Url) throws {
        type = entity.type
        url = entity.url
        super.init()
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return url == parameters["url"]
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
    
    var type: String? // A text identifier for the URL.,
    var url: String? // A full URL (including scheme, domain, and path).
    
    typealias Entity = Entities.Url
}

class Image: Object, Codable, Model {
    func generateEntity() throws -> Entities.Image {
        return Entities.Image(path: path, extension: `extension`)
    }
    
    required init(from entity: Entities.Image) throws {
        path = entity.path
        `extension` = entity.extension
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return path == parameters["path"]
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init()
    }
    
    var path: String? // The directory path of to the image.,
    var `extension`: String? // The file extension for the image.
    
    typealias Entity = Entities.Image
}

class ComicList: Object, Codable, Model {
    func generateEntity() throws -> Entities.ComicList {
        let summaries = try items?.compactMap { try $0.generateEntity() }
        return Entities.ComicList(available: available, returned: returned, collectionURI: collectionURI, items: summaries)
    }
    
    required init(from entity: Entities.ComicList) throws {
        available = entity.available
        returned = entity.returned
        collectionURI = entity.collectionURI
        items = try entity.items?.compactMap { try ComicSummary(from: $0) }
        super.init()
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return collectionURI == parameters["collectionURI"]
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
    
    var available: Int? // The number of total available issues in this list. Will always be greater than or equal to the "returned" value.,
    var returned: Int? // The number of issues returned in this collection (up to 20).,
    var collectionURI: String? // The path to the full list of issues in this collection.,
    var items: [ComicSummary]? // The list of returned issues in this collection.
    
    typealias Entity = Entities.ComicList
}

class ComicSummary: Object, Codable, Model {
    func generateEntity() throws -> Entities.ComicSummary {
        return Entities.ComicSummary(resourceURI: resourceURI, name: name)
    }
    
    required init(from entity: Entities.ComicSummary) throws {
        resourceURI = entity.resourceURI
        name = entity.name
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
    
    var resourceURI: String? // The path to the individual comic resource.,
    var name: String? // The canonical name of the comic.
    
    typealias Entity = Entities.ComicSummary
}

class StoryList: Object, Codable, Model {
    func generateEntity() throws -> Entities.StoryList {
        let summaries = try items?.compactMap { try $0.generateEntity() }
        return Entities.StoryList(available: available, returned: returned, collectionURI: collectionURI, items: summaries)
    }
    
    required init(from entity: Entities.StoryList) throws {
        available = entity.available
        returned = entity.returned
        collectionURI = entity.collectionURI
        items = try entity.items?.compactMap { try StorySummary(from: $0) }
        super.init()
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return collectionURI == parameters["collectionURI"]
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
    
    var available: Int? // The number of total available stories in this list. Will always be greater than or equal to the "returned" value.,
    var returned: Int? // The number of stories returned in this collection (up to 20).,
    var collectionURI: String? // The path to the full list of stories in this collection.,
    var items: [StorySummary]? // The list of returned stories in this collection.
    
    typealias Entity = Entities.StoryList
}

class StorySummary: Object, Codable, Model {
    func generateEntity() throws -> Entities.StorySummary {
        return Entities.StorySummary(resourceURI: resourceURI, name: name, type: type)
    }
    
    required init(from entity: Entities.StorySummary) throws {
        resourceURI = entity.resourceURI
        name = entity.name
        type = entity.type
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
    
    var resourceURI: String? // The path to the individual story resource.,
    var name: String? // The canonical name of the story.,
    var type: String? // The type of the story (interior or cover).
    
    typealias Entity = Entities.StorySummary
}

class EventList: Object, Codable, Model {
    func generateEntity() throws -> Entities.EventList {
        let summaries = try items?.compactMap { try $0.generateEntity() }
        return Entities.EventList(available: available, returned: returned, collectionURI: collectionURI, items: summaries)
    }
    
    required init(from entity: Entities.EventList) throws {
        available = entity.available
        returned = entity.returned
        collectionURI = entity.collectionURI
        items = try entity.items?.compactMap { try EventSummary(from: $0) }
        super.init()
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return collectionURI == parameters["collectionURI"]
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
    
    var available: Int? // The number of total available events in this list. Will always be greater than or equal to the "returned" value.,
    var returned: Int? // The number of events returned in this collection (up to 20).,
    var collectionURI: String? // The path to the full list of events in this collection.,
    var items: [EventSummary]? // The list of returned events in this collection.
    
    typealias Entity = Entities.EventList
}

class EventSummary: Object, Codable, Model {
    func generateEntity() throws -> Entities.EventSummary {
        return Entities.EventSummary(resourceURI: resourceURI, name: name)
    }
    
    required init(from entity: Entities.EventSummary) throws {
        resourceURI = entity.resourceURI
        name = entity.name
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
    
    var resourceURI: String? // The path to the individual event resource.,
    var name: String? // The name of the event.
    
    typealias Entity = Entities.EventSummary
}

class SeriesList: Object, Codable, Model {
    func generateEntity() throws -> Entities.SeriesList {
        let summaries = try items?.compactMap { try $0.generateEntity() }
        return Entities.SeriesList(available: available, returned: returned, collectionURI: collectionURI, items: summaries)
    }
    
    required init(from entity: Entities.SeriesList) throws {
        available = entity.available
        returned = entity.returned
        collectionURI = entity.collectionURI
        items = try entity.items?.compactMap { try SeriesSummary(from: $0) }
        super.init()
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return collectionURI == parameters["collectionURI"]
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
    
    var available: Int? // The number of total available series in this list. Will always be greater than or equal to the "returned" value.,
    var returned: Int? // The number of series returned in this collection (up to 20).,
    var collectionURI: String? // The path to the full list of series in this collection.,
    var items: [SeriesSummary]? // The list of returned series in this collection.
    
    typealias Entity = Entities.SeriesList
}

class SeriesSummary: Object, Codable, Model {
    func generateEntity() throws -> Entities.SeriesSummary {
        return Entities.SeriesSummary(resourceURI: resourceURI, name: name)
    }
    
    required init(from entity: Entities.SeriesSummary) throws {
        resourceURI = entity.resourceURI
        name = entity.name
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
    
    var resourceURI: String? // The path to the individual series resource.,
    var name: String? // The canonical name of the series.
    
    typealias Entity = Entities.SeriesSummary
}
