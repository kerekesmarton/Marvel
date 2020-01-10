//
//  Models+Series.swift
//  Data
//
//  Created by Marton Kerekes on 07/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Domain
import Realm
import RealmSwift

class SeriesDataWrapper: Wrapper, Model {
    @objc dynamic var data: SeriesDataContainer? //The results returned by the call.,
    @objc dynamic var id = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    typealias Entity = Entities.SeriesDataWrapper
    
    func generateEntity() throws -> Entities.SeriesDataWrapper {
        return try Entities.SeriesDataWrapper(code: code, status: status, copyright: copyright, attributionText: attributionText, attributionHTML: attributionHTML, data: data?.generateEntity(), etag: etag)
    }
    
    required init(from entity: Entities.SeriesDataWrapper) throws {
        if let t = entity.data {
            data = try SeriesDataContainer(from: t)
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
        let container = try decoder.container(keyedBy: SeriesCodingKeys.self)
        data = try container.decodeIfPresent(SeriesDataContainer.self, forKey: .data)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SeriesCodingKeys.self)
        try container.encode(data, forKey: .data)
        try super.encode(to: encoder)
    }
    
    enum SeriesCodingKeys: String, CodingKey {
        case data
    }
}

class SeriesDataContainer: Container, Model {
    let results = List<Series>() //The list of series returned by the call
    
    typealias Entity = Entities.SeriesDataContainer
    
    func generateEntity() throws -> Entities.SeriesDataContainer {
        return Entities.SeriesDataContainer(offset: offset,
                                               limit: limit,
                                               total: total,
                                               count: count,
                                               results: try results.compactMap { try $0.generateEntity() })
    }
    
    required init(from entity: Entities.SeriesDataContainer) throws {
        if let t = try entity.results?.compactMap { try Series(from: $0) } {
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
        if let t = try container.decodeIfPresent([Series].self, forKey: .results) {
            results.append(objectsIn: t)
        }
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(results, forKey: .results)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

class Series: CodableSeries, Model {
    let urls = List<Url>() //A set of web site URLs for the resource.,
    typealias Entity = Entities.Series
    
    func generateEntity() throws -> Entities.Series {
        return Entities.Series(id: id,
                               title: title,
                               description: desc,
                               resourceURI: resourceURI,
                               urls: try urls.compactMap { try $0.generateEntity() },
                               startYear: startYear,
                               endYear: endYear,
                               rating: rating,
                               modified: modified,
                               thumbnail: try thumbnail?.generateEntity(),
                               comics: try comics?.generateEntity(),
                               stories: try stories?.generateEntity(),
                               events: try events?.generateEntity(),
                               characters: try characters?.generateEntity(),
                               creators: try creators?.generateEntity(),
                               next: try next?.generateEntity(),
                               previous: try previous?.generateEntity())
    }
    
    required init(from entity: Entities.Series) throws {
        if let t = try entity.urls?.compactMap { try Url(from: $0) } {
            urls.append(objectsIn: t)
        }
        super.init()
        id = entity.id ?? 0
        title = entity.title ?? ""
        desc = entity.description ?? ""
        resourceURI = entity.resourceURI ?? ""
        startYear = entity.startYear ?? 0
        endYear = entity.endYear ?? 0
        rating = entity.rating ?? ""
        modified = entity.modified ?? ""
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
        if let t = entity.characters {
            characters = try CharacterList(from: t)
        }
        if let t = entity.creators {
            creators = try CreatorList(from: t)
        }
        if let t = entity.next {
            next = try SeriesSummary(from: t)
        }
        if let t = entity.previous {
            previous = try SeriesSummary(from: t)
        }
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return resourceURI == parameters["resourceURI"]
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SeriesCodingKeys.self)
        if let t = try container.decodeIfPresent([Url].self, forKey: .urls) {
            urls.append(objectsIn: t)
        }
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SeriesCodingKeys.self)
        try container.encode(urls.compactMap { $0 }, forKey: .urls)
        try super.encode(to: encoder)
    }
    
    enum SeriesCodingKeys: String, CodingKey {
        case urls
    }
}

class CodableSeries: Object, Codable {
    @objc dynamic var id: Int = 0 //The unique ID of the series resource.,
    @objc dynamic var title = "" //The canonical title of the series.,
    @objc dynamic var desc: String? = "" //A description of the series.,
    @objc dynamic var resourceURI = "" //The canonical URL identifier for this resource.,
    @objc dynamic var startYear: Int = 0 //The first year of publication for the series.,
    @objc dynamic var endYear: Int = 0 //The last year of publication for the series (conventionally, 2099 for ongoing series) .,
    @objc dynamic var rating = "" //The age-appropriateness rating for the series.,
    @objc dynamic var modified = "" //The date the resource was most recently modified.,
    @objc dynamic var thumbnail: Image? //The representative image for this series.,
    @objc dynamic var comics: ComicList? //A resource list containing comics in this series.,
    @objc dynamic var stories: StoryList? //A resource list containing stories which occur in comics in this series.,
    @objc dynamic var events: EventList? //A resource list containing events which take place in comics in this series.,
    @objc dynamic var characters: CharacterList? //A resource list containing characters which appear in comics in this series.,
    @objc dynamic var creators: CreatorList? //A resource list of creators whose work appears in comics in this series.,
    @objc dynamic var next: SeriesSummary? //A summary representation of the series which follows this series.,
    @objc dynamic var previous: SeriesSummary? //A summary representation of the series which preceded this series.
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case desc = "description"
        case resourceURI
        case startYear
        case endYear
        case rating
        case modified
        case thumbnail
        case comics
        case stories
        case events
        case characters
        case creators
        case next
        case previous
    }
}
