//
//  Entities+Character.swift
//  Domain
//
//  Created by Marton Kerekes on 07/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
 
extension Entities {
    public class CharacterDataWrapper {
        public var code: Int? // The HTTP status code of the returned result.,
        public var status: String? // A string description of the call status.,
        public var copyright: String? // The copyright notice for the returned result.,
        public var attributionText: String? // The attribution notice for this result. Please display either this notice or the contents of the attributionHTML field on all screens which contain data from the Marvel Comics API.,
        public var attributionHTML: String? // An HTML representation of the attribution notice for this result. Please display either this notice or the contents of the attributionText field on all screens which contain data from the Marvel Comics API.,
        public var data: CharacterDataContainer? //The results returned by the call.,
        public var etag: String? // A digest value of the content returned by the call.
        
        public init(code: Int?,
                    status: String?,
                    copyright: String?,
                    attributionText: String?,
                    attributionHTML: String?,
                    data: CharacterDataContainer?,
                    etag: String?) {
            
            self.code = code
            self.status = status
            self.copyright = copyright
            self.attributionText = attributionText
            self.data = data
            self.etag = etag
        }
    }
    
    public class CharacterDataContainer {
        public var offset: Int? // The requested offset (number of skipped results) of the call.,
        public var limit: Int? // The requested result limit.,
        public var total: Int? // The total number of resources available given the current filter set.,
        public var count: Int? // The total number of results returned by this call.,
        public var results: [Character]? // The list of characters returned by the call.
        
        public init(offset: Int?,
                    limit: Int?,
                    total: Int?,
                    count: Int?,
                    results: [Character]?) {
            self.offset = offset
            self.limit = limit
            self.total = total
            self.count = count
            self.results = results
        }
        
    }
    
    public class Character: Equatable {
        public static func == (lhs: Entities.Character, rhs: Entities.Character) -> Bool {
            return lhs.resourceURI == rhs.resourceURI
        }
        
        public var id: Int? // The unique ID of the character resource.,
        public var name: String? // The name of the character.,
        public var description: String? // A short bio or description of the character.,
        public var modified: String? // The date the resource was most recently modified.,
        public var resourceURI: String? // The canonical URL identifier for this resource.,
        public var urls: [Url]? // A set of public web site URLs for the resource.,
        public var thumbnail: Image? //The representative image for this character.,
        public var comics: ComicList? // A resource list containing comics which feature this character.,
        public var stories: StoryList? // A resource list of stories in which this character appears.,
        public var events: EventList? // A resource list of events in which this character appears.,
        public var series: SeriesList? // A resource list of series in which this character appears.
        
        public init(id: Int?,
                    name: String?,
                    description: String?,
                    modified: String?,
                    resourceURI: String?,
                    urls: [Url]?,
                    thumbnail: Image?,
                    comics: ComicList?,
                    stories: StoryList?,
                    events: EventList?,
                    series: SeriesList?
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.modified = modified
            self.resourceURI = resourceURI
            self.urls = urls
            self.thumbnail = thumbnail
            self.comics = comics
            self.stories = stories
            self.events = events
            self.series = series
        }
    }
}
