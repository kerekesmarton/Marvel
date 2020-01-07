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

class Url: Object, Codable, Model {
    var type: String? // A text identifier for the URL.,
    var url: String? // A full URL (including scheme, domain, and path).
    
    typealias Entity = Entities.Url
    
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
}

class Image: Object, Codable, Model {
    var path: String? // The directory path of to the image.,
    var `extension`: String? // The file extension for the image.
    
    typealias Entity = Entities.Image
    
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
}

class CreatorList: Object, Codable, Model {
    var available: Int? // The number of total available creators in this list. Will always be greater than or equal to the "returned" value.,
    var returned: Int? // The number of creators returned in this collection (up to 20).,
    var collectionURI: String? // The path to the full list of creators in this collection.,
    var items: [CreatorSummary]? // The list of returned creators in this collection.
    
    typealias Entity = Entities.CreatorList
    
    func generateEntity() throws -> Entities.CreatorList {
        let summaries = try items?.compactMap { try $0.generateEntity() }
        return Entities.CreatorList(available: available, returned: returned, collectionURI: collectionURI, items: summaries)
    }
    
    required init(from entity: Entities.CreatorList) throws {
        available = entity.available
        returned = entity.returned
        collectionURI = entity.collectionURI
        items = try entity.items?.compactMap { try CreatorSummary(from: $0) }
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
}

class CreatorSummary: Object, Codable, Model {
    var resourceURI: String? // The path to the individual creator resource.,
    var name: String? // The full name of the creator.,
    var role: String? // The role of the creator in the parent entity.
    
    typealias Entity = Entities.CreatorSummary
    
    func generateEntity() throws -> Entities.CreatorSummary {
        return Entities.CreatorSummary(resourceURI: resourceURI, name: name, role: role)
    }
    
    required init(from entity: Entities.CreatorSummary) throws {
        resourceURI = entity.resourceURI
        name = entity.name
        role = entity.role
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

class CharacterList: Object, Codable, Model {
    var available: Int? // The number of total available characters in this list. Will always be greater than or equal to the "returned" value.,
    var returned: Int? // The number of characters returned in this collection (up to 20).,
    var collectionURI: String? // The path to the full list of characters in this collection.,
    var items: [CharacterSummary]? // The list of returned characters in this collection.
    
    typealias Entity = Entities.CharacterList
    
    func generateEntity() throws -> Entities.CharacterList {
        let summaries = try items?.compactMap { try $0.generateEntity() }
        return Entities.CharacterList(available: available, returned: returned, collectionURI: collectionURI, items: summaries)
    }
    
    required init(from entity: Entities.CharacterList) throws {
        available = entity.available
        returned = entity.returned
        collectionURI = entity.collectionURI
        items = try entity.items?.compactMap { try CharacterSummary(from: $0) }
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
}

class CharacterSummary: Object, Codable, Model {
    var resourceURI: String? // The path to the individual character resource.,
    var name: String? // The full name of the character.,
    var role: String? // The role of the creator in the parent entity.
    
    typealias Entity = Entities.CharacterSummary
    
    func generateEntity() throws -> Entities.CharacterSummary {
        return Entities.CharacterSummary(resourceURI: resourceURI, name: name, role: role)
    }
    
    required init(from entity: Entities.CharacterSummary) throws {
        resourceURI = entity.resourceURI
        name = entity.name
        role = entity.role
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

class ComicList: Object, Codable, Model {
    var available: Int? // The number of total available issues in this list. Will always be greater than or equal to the "returned" value.,
    var returned: Int? // The number of issues returned in this collection (up to 20).,
    var collectionURI: String? // The path to the full list of issues in this collection.,
    var items: [ComicSummary]? // The list of returned issues in this collection.
    
    typealias Entity = Entities.ComicList
    
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
}

class ComicSummary: Object, Codable, Model {
    var resourceURI: String? // The path to the individual comic resource.,
    var name: String? // The canonical name of the comic.
    
    typealias Entity = Entities.ComicSummary
    
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
}

class StoryList: Object, Codable, Model {
    var available: Int? // The number of total available stories in this list. Will always be greater than or equal to the "returned" value.,
    var returned: Int? // The number of stories returned in this collection (up to 20).,
    var collectionURI: String? // The path to the full list of stories in this collection.,
    var items: [StorySummary]? // The list of returned stories in this collection.
    
    typealias Entity = Entities.StoryList
    
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
    
    
}

class StorySummary: Object, Codable, Model {
    var resourceURI: String? // The path to the individual story resource.,
    var name: String? // The canonical name of the story.,
    var type: String? // The type of the story (interior or cover).
    
    typealias Entity = Entities.StorySummary
    
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
}

class EventList: Object, Codable, Model {
    var available: Int? // The number of total available events in this list. Will always be greater than or equal to the "returned" value.,
    var returned: Int? // The number of events returned in this collection (up to 20).,
    var collectionURI: String? // The path to the full list of events in this collection.,
    var items: [EventSummary]? // The list of returned events in this collection.
    
    typealias Entity = Entities.EventList
    
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
    
    
}

class EventSummary: Object, Codable, Model {
    var resourceURI: String? // The path to the individual event resource.,
    var name: String? // The name of the event.
    
    typealias Entity = Entities.EventSummary
    
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
}

class SeriesList: Object, Codable, Model {
    var available: Int? // The number of total available series in this list. Will always be greater than or equal to the "returned" value.,
    var returned: Int? // The number of series returned in this collection (up to 20).,
    var collectionURI: String? // The path to the full list of series in this collection.,
    var items: [SeriesSummary]? // The list of returned series in this collection.
    
    typealias Entity = Entities.SeriesList
    
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
}

class SeriesSummary: Object, Codable, Model {
    var resourceURI: String? // The path to the individual series resource.,
    var name: String? // The canonical name of the series.
    
    typealias Entity = Entities.SeriesSummary
    
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
}
