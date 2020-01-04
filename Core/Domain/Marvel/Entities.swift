//
//  Entities.swift
//  Domain
//
//  Created by Marton Kerekes on 03/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation

public class Entities {
}

extension Entities{
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
    
    public class Character {
        public var id: Int? // The unique ID of the character resource.,
        public var name: String? // The name of the character.,
        public var description: String? // A short bio or description of the character.,
        public var modified: Date? // The date the resource was most recently modified.,
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
                    modified: Date?,
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
    
    public class Url {
        public var type: String? // A text identifier for the URL.,
        public var url: String? // A full URL (including scheme, domain, and path).
        
        public init(type: String?, url: String?) {
            self.type = type
            self.url = url
        }
    }
    
    public class Image {
        public var path: String? // The directory path of to the image.,
        public var `extension`: String? // The file extension for the image.
        
        public init(path: String?, `extension`: String?) {
            self.path = path
            self.`extension` = `extension`
        }
    }
    
    public class ComicList {
        public var available: Int? // The number of total available issues in this list. Will always be greater than or equal to the "returned" value.,
        public var returned: Int? // The number of issues returned in this collection (up to 20).,
        public var collectionURI: String? // The path to the full list of issues in this collection.,
        public var items: [ComicSummary]? // The list of returned issues in this collection.
        
        public init(available: Int?,
                    returned: Int?,
                    collectionURI: String?,
                    items: [ComicSummary]?) {
            self.available = available
            self.returned = returned
            self.collectionURI = collectionURI
            self.items = items
        }
    }
    
    public class ComicSummary {
        public var resourceURI: String? // The path to the individual comic resource.,
        public var name: String? // The canonical name of the comic.
        
        
        public init(resourceURI: String?, name: String?) {
            self.resourceURI = resourceURI
            self.name = name
        }
    }
    
    
    public class StoryList {
        public var available: Int? // The number of total available stories in this list. Will always be greater than or equal to the "returned" value.,
        public var returned: Int? // The number of stories returned in this collection (up to 20).,
        public var collectionURI: String? // The path to the full list of stories in this collection.,
        public var items: [StorySummary]? // The list of returned stories in this collection.
        
        public init(available: Int?,
                    returned: Int?,
                    collectionURI: String?,
                    items: [StorySummary]?) {
            self.available = available
            self.returned = returned
            self.collectionURI = collectionURI
            self.items = items
        }
    }
    
    public class StorySummary {
        public var resourceURI: String? // The path to the individual story resource.,
        public var name: String? // The canonical name of the story.,
        public var type: String? // The type of the story (interior or cover).
        
        public init(resourceURI: String?,
                    name: String?,
                    type: String?
        ) {
            self.resourceURI = resourceURI
            self.name = name
            self.type = type
        }
    }
    
    public class EventList {
        public var available: Int? // The number of total available events in this list. Will always be greater than or equal to the "returned" value.,
        public var returned: Int? // The number of events returned in this collection (up to 20).,
        public var collectionURI: String? // The path to the full list of events in this collection.,
        public var items: [EventSummary]? // The list of returned events in this collection.
        
        public init(available: Int?,
                    returned: Int?,
                    collectionURI: String?,
                    items: [EventSummary]?) {
            self.available = available
            self.returned = returned
            self.collectionURI = collectionURI
            self.items = items
        }
    }
    
    public class EventSummary {
        public var resourceURI: String? // The path to the individual event resource.,
        public var name: String? // The name of the event.
        
        public init(resourceURI: String?, name: String?) {
            self.resourceURI = resourceURI
            self.name = name
        }
    }
    
    public class SeriesList {
        public var available: Int? // The number of total available series in this list. Will always be greater than or equal to the "returned" value.,
        public var returned: Int? // The number of series returned in this collection (up to 20).,
        public var collectionURI: String? // The path to the full list of series in this collection.,
        public var items: [SeriesSummary]? // The list of returned series in this collection.
        
        public init(available: Int?,
                    returned: Int?,
                    collectionURI: String?,
                    items: [SeriesSummary]?) {
            self.available = available
            self.returned = returned
            self.collectionURI = collectionURI
            self.items = items
        }
    }
    
    public class SeriesSummary {
        public var resourceURI: String? // The path to the individual series resource.,
        public var name: String? // The canonical name of the series.
        
        public init(resourceURI: String?, name: String?) {
            self.resourceURI = resourceURI
            self.name = name
        }
    }
    
}
