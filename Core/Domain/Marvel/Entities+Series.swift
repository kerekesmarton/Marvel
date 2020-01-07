//
//  Entities+Series.swift
//  Domain
//
//  Created by Marton Kerekes on 07/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation

extension Entities {
    public class SeriesDataWrapper {
        public var code: Int? //The HTTP status code of the returned result.,
        public var status: String? //A string description of the call status.,
        public var copyright: String? //The copyright notice for the returned result.,
        public var attributionText: String? //The attribution notice for this result. Please display either this notice or the contents of the attributionHTML field on all screens which contain data from the Marvel Comics API.,
        public var attributionHTML: String? //An HTML representation of the attribution notice for this result. Please display either this notice or the contents of the attributionText field on all screens which contain data from the Marvel Comics API.,
        public var data: SeriesDataContainer? //The results returned by the call.,
        public var etag: String? //A digest value of the content returned by the call.
        
        public init(code: Int?,
                    status: String?,
                    copyright: String?,
                    attributionText: String?,
                    attributionHTML: String?,
                    data: SeriesDataContainer?,
                    etag: String?
        ) {
            self.code = code
            self.status = status
            self.copyright = copyright
            self.attributionText = attributionText
            self.attributionHTML = attributionHTML
            self.data = data
            self.etag = etag
        }
    }

    public class SeriesDataContainer {
        public var offset: Int? //The requested offset (number of skipped results) of the call.,
        public var limit: Int? //The requested result limit.,
        public var total: Int? //The total number of resources available given the current filter set.,
        public var count: Int? //The total number of results returned by this call.,
        public var results: [Series]? //The list of series returned by the call
        
        public init(offset: Int?,
                    limit: Int?,
                    total: Int?,
                    count: Int?,
                    results: [Series]?
        ){
            self.offset = offset
            self.limit = limit
            self.total = total
            self.count = count
            self.results = results
        }
    }
    
    public class Series {
        public var id: Int? //The unique ID of the series resource.,
        public var title: String? //The canonical title of the series.,
        public var description: String? //A description of the series.,
        public var resourceURI: String? //The canonical URL identifier for this resource.,
        public var urls: [Url]? //A set of public web site URLs for the resource.,
        public var startYear: Int? //The first year of publication for the series.,
        public var endYear: Int? //The last year of publication for the series (conventionally, 2099 for ongoing series) .,
        public var rating: String? //The age-appropriateness rating for the series.,
        public var modified: String? //The date the resource was most recently modified.,
        public var thumbnail: Image? //The representative image for this series.,
        public var comics: ComicList? //A resource list containing comics in this series.,
        public var stories: StoryList? //A resource list containing stories which occur in comics in this series.,
        public var events: EventList? //A resource list containing events which take place in comics in this series.,
        public var characters: CharacterList? //A resource list containing characters which appear in comics in this series.,
        public var creators: CreatorList? //A resource list of creators whose work appears in comics in this series.,
        public var next: SeriesSummary? //A summary representation of the series which follows this series.,
        public var previous: SeriesSummary? //A summary representation of the series which preceded this series.
        
        public init(id: Int?,
            title: String?,
            description: String?,
            resourceURI: String?,
            urls: [Url]?,
            startYear: Int?,
            endYear: Int?,
            rating: String?,
            modified: String?,
            thumbnail: Image?,
            comics: ComicList?,
            stories: StoryList?,
            events: EventList?,
            characters: CharacterList?,
            creators: CreatorList?,
            next: SeriesSummary?,
            previous: SeriesSummary?
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.resourceURI = resourceURI
            self.urls = urls
            self.startYear = startYear
            self.endYear = endYear
            self.rating = rating
            self.modified = modified
            self.thumbnail = thumbnail
            self.comics = comics
            self.stories = stories
            self.events = events
            self.characters = characters
            self.creators = creators
            self.next = next
            self.previous = previous
        }
    }
}
