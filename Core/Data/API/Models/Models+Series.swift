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

class SeriesDataWrapper: Object, Codable, Model {
    var code: Int? //The HTTP status code of the returned result.,
    var status: String? //A string description of the call status.,
    var copyright: String? //The copyright notice for the returned result.,
    var attributionText: String? //The attribution notice for this result. Please display either this notice or the contents of the attributionHTML field on all screens which contain data from the Marvel Comics API.,
    var attributionHTML: String? //An HTML representation of the attribution notice for this result. Please display either this notice or the contents of the attributionText field on all screens which contain data from the Marvel Comics API.,
    var data: SeriesDataContainer? //The results returned by the call.,
    var etag: String? //A digest value of the content returned by the call.
    
    typealias Entity = Entities.SeriesDataWrapper
    
    func generateEntity() throws -> Entities.SeriesDataWrapper {
        return try Entities.SeriesDataWrapper(code: code, status: status, copyright: copyright, attributionText: attributionText, attributionHTML: attributionHTML, data: data?.generateEntity(), etag: etag)
    }
    
    required init(from entity: Entities.SeriesDataWrapper) throws {
        code = entity.code
        status = entity.status
        copyright = entity.copyright
        attributionText = entity.attributionText
        attributionHTML = entity.attributionHTML
        if let t = entity.data {
            data = try SeriesDataContainer(from: t)
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

class SeriesDataContainer: Object, Codable, Model {
    var offset: Int? //The requested offset (number of skipped results) of the call.,
    var limit: Int? //The requested result limit.,
    var total: Int? //The total number of resources available given the current filter set.,
    var count: Int? //The total number of results returned by this call.,
    var results: [Series]? //The list of series returned by the call
    
    typealias Entity = Entities.SeriesDataContainer
    
    func generateEntity() throws -> Entities.SeriesDataContainer {
        return Entities.SeriesDataContainer(offset: offset,
                                               limit: limit,
                                               total: total,
                                               count: count,
                                               results: try results?.compactMap { try $0.generateEntity() })
    }
    
    required init(from entity: Entities.SeriesDataContainer) throws {
        offset = entity.offset
        limit = entity.limit
        total = entity.total
        count = entity.count
        results = try entity.results?.compactMap { try Series(from: $0) }
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
class Series: Object, Codable, Model {
    var id: Int? //The unique ID of the series resource.,
    var title: String? //The canonical title of the series.,
    var desc: String? //A description of the series.,
    var resourceURI: String? //The canonical URL identifier for this resource.,
    var urls: [Url]? //A set of web site URLs for the resource.,
    var startYear: Int? //The first year of publication for the series.,
    var endYear: Int? //The last year of publication for the series (conventionally, 2099 for ongoing series) .,
    var rating: String? //The age-appropriateness rating for the series.,
    var modified: String? //The date the resource was most recently modified.,
    var thumbnail: Image? //The representative image for this series.,
    var comics: ComicList? //A resource list containing comics in this series.,
    var stories: StoryList? //A resource list containing stories which occur in comics in this series.,
    var events: EventList? //A resource list containing events which take place in comics in this series.,
    var characters: CharacterList? //A resource list containing characters which appear in comics in this series.,
    var creators: CreatorList? //A resource list of creators whose work appears in comics in this series.,
    var next: SeriesSummary? //A summary representation of the series which follows this series.,
    var previous: SeriesSummary? //A summary representation of the series which preceded this series.
    
    typealias Entity = Entities.Series
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case desc = "description"
        case resourceURI
        case urls
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
    
    func generateEntity() throws -> Entities.Series {
        return Entities.Series(id: id,
                               title: title,
                               description: desc,
                               resourceURI: resourceURI,
                               urls: try urls?.compactMap { try $0.generateEntity() },
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
        id = entity.id
        title = entity.title
        desc = entity.description
        resourceURI = entity.resourceURI
        urls = try entity.urls?.compactMap { try Url(from: $0) }
        startYear = entity.startYear
        endYear = entity.endYear
        rating = entity.rating
        modified = entity.modified
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
