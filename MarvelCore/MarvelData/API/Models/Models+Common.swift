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
import MarvelDomain
import Data

class Url: Object, Codable, Model {
    @objc dynamic var type = "" // A text identifier for the URL.,
    @objc dynamic var url = "" // A full URL (including scheme, domain, and path).
    
    typealias Entity = Entities.Url
    
    func generateEntity() throws -> Entities.Url {
        return Entities.Url(type: type, url: url)
    }
    
    required init(from entity: Entities.Url) throws {
        type = entity.type ?? ""
        url = entity.url ?? ""
        super.init()
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return url == parameters["url"]
    }
    
    required init() {
        super.init()
    }
    
}

class Image: Object, Codable, Model {
    @objc dynamic var path = "" // The directory path of to the image.,
    @objc dynamic var `extension` = "" // The file extension for the image.
    
    typealias Entity = Entities.Image
    
    func generateEntity() throws -> Entities.Image {
        return Entities.Image(path: path, extension: `extension`)
    }
    
    required init(from entity: Entities.Image) throws {
        path = entity.path ?? ""
        `extension` = entity.extension ?? ""
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return path == parameters["path"]
    }
}

class CreatorList: SummaryList, Model {
    let items = List<CreatorSummary>() // The list of returned creators in this collection.
    
    typealias Entity = Entities.CreatorList
    
    func generateEntity() throws -> Entities.CreatorList {
        let summaries = try items.compactMap { try $0.generateEntity() }
        return Entities.CreatorList(available: available, returned: returned, collectionURI: collectionURI, items: summaries)
    }
    
    required init(from entity: Entities.CreatorList) throws {
        if let t = try entity.items?.compactMap { try CreatorSummary(from: $0) } {
            items.append(objectsIn: t)
        }
        super.init(available: entity.available, returned: entity.returned, collectionURI: entity.collectionURI)
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return collectionURI == parameters["collectionURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let temp = try container.decodeIfPresent([CreatorSummary].self, forKey: .items) {
            items.append(objectsIn: temp)
        }
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items.compactMap { $0 }, forKey: .items)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
}

class CreatorSummary: Summary, Model {
    @objc dynamic var role = "" // The role of the creator in the parent entity.
    
    typealias Entity = Entities.CreatorSummary
    
    func generateEntity() throws -> Entities.CreatorSummary {
        return Entities.CreatorSummary(resourceURI: resourceURI, name: name, role: role)
    }
    
    required init(from entity: Entities.CreatorSummary) throws {
        role = entity.role ?? ""
        super.init(resourceURI: entity.resourceURI, name: entity.name)
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return resourceURI == parameters["resourceURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        role = try container.decodeIfPresent(String.self, forKey: .role) ?? ""
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(role, forKey: .role)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case role
    }
}

class CharacterList: SummaryList, Model {
    let items = List<CharacterSummary>() // The list of returned characters in this collection.
    
    typealias Entity = Entities.CharacterList
    
    func generateEntity() throws -> Entities.CharacterList {
        let summaries = try items.compactMap { try $0.generateEntity() }
        return Entities.CharacterList(available: available, returned: returned, collectionURI: collectionURI, items: summaries)
    }
    
    required init(from entity: Entities.CharacterList) throws {
        if let t = try entity.items?.compactMap { try CharacterSummary(from: $0) } {
            items.append(objectsIn: t)
        }
        super.init(available: entity.available, returned: entity.returned, collectionURI: entity.collectionURI)
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return collectionURI == parameters["collectionURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let temp = try container.decodeIfPresent([CharacterSummary].self, forKey: .items) {
            items.append(objectsIn: temp)
        }
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items.compactMap { $0 }, forKey: .items)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
}

class CharacterSummary: Summary, Model {
    @objc dynamic var role = "" // The role of the creator in the parent entity.
    
    typealias Entity = Entities.CharacterSummary
    
    func generateEntity() throws -> Entities.CharacterSummary {
        return Entities.CharacterSummary(resourceURI: resourceURI, name: name, role: role)
    }
    
    required init(from entity: Entities.CharacterSummary) throws {
        role = entity.role ?? ""
        super.init(resourceURI: entity.resourceURI, name: entity.name)
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return resourceURI == parameters["resourceURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        role = try container.decodeIfPresent(String.self, forKey: .role) ?? ""
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(role, forKey: .role)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case role
    }
    
}

class ComicList: SummaryList, Model {
    let items = List<ComicSummary>() // The list of returned issues in this collection.
    
    typealias Entity = Entities.ComicList
    
    func generateEntity() throws -> Entities.ComicList {
        let summaries = try items.compactMap { try $0.generateEntity() }
        return Entities.ComicList(available: available, returned: returned, collectionURI: collectionURI, items: summaries)
    }
    
    required init(from entity: Entities.ComicList) throws {
        if let t = try entity.items?.compactMap { try ComicSummary(from: $0) } {
            items.append(objectsIn: t)
        }
        super.init(available: entity.available, returned: entity.returned, collectionURI: entity.collectionURI)
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return collectionURI == parameters["collectionURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let temp = try container.decodeIfPresent([ComicSummary].self, forKey: .items) {
            items.append(objectsIn: temp)
        }
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items.compactMap { $0 }, forKey: .items)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
}

class ComicSummary: Summary, Model {
    typealias Entity = Entities.ComicSummary
    
    func generateEntity() throws -> Entities.ComicSummary {
        return Entities.ComicSummary(resourceURI: resourceURI, name: name)
    }
    
    required init(from entity: Entities.ComicSummary) throws {
        super.init(resourceURI: entity.resourceURI, name: entity.name)
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return resourceURI == parameters["resourceURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
    
}

class StoryList: SummaryList, Model {
    let items = List<StorySummary>() // The list of returned stories in this collection.
    
    typealias Entity = Entities.StoryList
    
    func generateEntity() throws -> Entities.StoryList {
        let summaries = try items.compactMap { try $0.generateEntity() }
        return Entities.StoryList(available: available, returned: returned, collectionURI: collectionURI, items: summaries)
    }
    
    required init(from entity: Entities.StoryList) throws {
        if let t = try entity.items?.compactMap { try StorySummary(from: $0) } {
            items.append(objectsIn: t)
        }
        super.init(available: entity.available, returned: entity.returned, collectionURI: entity.collectionURI)
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return collectionURI == parameters["collectionURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let temp = try container.decodeIfPresent([StorySummary].self, forKey: .items) {
            items.append(objectsIn: temp)
        }
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items.compactMap { $0 }, forKey: .items)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
}

class StorySummary: Summary, Model {
    @objc dynamic var type = "" // The type of the story (interior or cover).
    
    typealias Entity = Entities.StorySummary
    
    func generateEntity() throws -> Entities.StorySummary {
        return Entities.StorySummary(resourceURI: resourceURI, name: name, type: type)
    }
    
    required init(from entity: Entities.StorySummary) throws {
        type = entity.type ?? ""
        super.init(resourceURI: entity.resourceURI, name: entity.name)
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return resourceURI == parameters["resourceURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case type
    }
    
}

class EventList: SummaryList, Model {
    let items = List<EventSummary>() // The list of returned events in this collection.
    
    typealias Entity = Entities.EventList
    
    func generateEntity() throws -> Entities.EventList {
        let summaries = try items.compactMap { try $0.generateEntity() }
        return Entities.EventList(available: available, returned: returned, collectionURI: collectionURI, items: summaries)
    }
    
    required init(from entity: Entities.EventList) throws {
        if let t = try entity.items?.compactMap { try EventSummary(from: $0) } {
            items.append(objectsIn: t)
        }
        super.init(available: entity.available, returned: entity.returned, collectionURI: entity.collectionURI)
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return collectionURI == parameters["collectionURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let temp = try container.decodeIfPresent([EventSummary].self, forKey: .items) {
            items.append(objectsIn: temp)
        }
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items.compactMap { $0 }, forKey: .items)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
}

class EventSummary: Summary, Model {
    typealias Entity = Entities.EventSummary
    
    func generateEntity() throws -> Entities.EventSummary {
        return Entities.EventSummary(resourceURI: resourceURI, name: name)
    }
    
    required init(from entity: Entities.EventSummary) throws {
        super.init(resourceURI: entity.resourceURI, name: entity.name)
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return resourceURI == parameters["resourceURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
    
}

class SeriesList: SummaryList, Model {
    let items = List<SeriesSummary>() // The list of returned series in this collection.
    
    typealias Entity = Entities.SeriesList
    
    func generateEntity() throws -> Entities.SeriesList {
        let summaries = try items.compactMap { try $0.generateEntity() }
        return Entities.SeriesList(available: available, returned: returned, collectionURI: collectionURI, items: summaries)
    }
    
    required init(from entity: Entities.SeriesList) throws {
        if let t = try entity.items?.compactMap { try SeriesSummary(from: $0) } {
            items.append(objectsIn: t)
        }
        super.init(available: entity.available, returned: entity.returned, collectionURI: entity.collectionURI)
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return collectionURI == parameters["collectionURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let t = try container.decodeIfPresent([SeriesSummary].self, forKey: .items) {
            items.append(objectsIn: t)
        }
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items.compactMap { $0 }, forKey: .items)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
}

class SeriesSummary: Summary, Model {
    typealias Entity = Entities.SeriesSummary
    
    func generateEntity() throws -> Entities.SeriesSummary {
        return Entities.SeriesSummary(resourceURI: resourceURI, name: name)
    }
    
    required init(from entity: Entities.SeriesSummary) throws {
        super.init(resourceURI: entity.resourceURI, name: entity.name)
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return resourceURI == parameters["resourceURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
