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
    
    public class CreatorList {
        public var available: Int? // The number of total available creators in this list. Will always be greater than or equal to the "returned" value.,
        public var returned: Int? // The number of creators returned in this collection (up to 20).,
        public var collectionURI: String? // The path to the full list of creators in this collection.,
        public var items: [CreatorSummary]? // The list of returned creators in this collection.
        
        public init(available: Int?,
        returned: Int?,
        collectionURI: String?,
        items: [CreatorSummary]?
        ) {
            self.available = available
            self.returned = returned
            self.collectionURI = collectionURI
            self.items = items
        }
    }
    
    public class CharacterList {
        public var available: Int? // The number of total available characters in this list. Will always be greater than or equal to the "returned" value.,
        public var returned: Int? // The number of characters returned in this collection (up to 20).,
        public var collectionURI: String? // The path to the full list of characters in this collection.,
        public var items: [CharacterSummary]? // The list of returned characters in this collection.
        
        public init(available: Int?,
                    returned: Int?,
                    collectionURI: String?,
                    items: [CharacterSummary]?
        ) {
            self.available = available
            self.returned = returned
            self.collectionURI = collectionURI
            self.items = items
        }
    }
    
    public class CharacterSummary {
        public var resourceURI: String? // The path to the individual character resource.,
        public var name: String? // The full name of the character.,
        public var role: String? // The role of the creator in the parent entity.
        
        public init(resourceURI: String?,
                    name: String?,
                    role: String?
        ) {
            self.resourceURI = resourceURI
            self.name = name
            self.role = role
        }
    }
    
    public class CreatorSummary {
        public var resourceURI: String? // The path to the individual creator resource.,
        public var name: String? // The full name of the creator.,
        public var role: String? // The role of the creator in the parent entity.
        
        public init(resourceURI: String?,
                    name: String?,
                    role: String?
        ) {
            self.resourceURI = resourceURI
            self.name = name
            self.role = role
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
