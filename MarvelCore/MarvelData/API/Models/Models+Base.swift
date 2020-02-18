//
//  Models+Super.swift
//  Data
//
//  Created by Marton Kerekes on 10/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Domain
import Realm
import RealmSwift
import MarvelDomain

class SummaryList: Object, Codable {
    @objc dynamic var available: Int = 0 // The number of total available creators in this list. Will always be greater than or equal to the "returned" value.,
    @objc dynamic var returned: Int = 0 // The number of creators returned in this collection (up to 20).,
    @objc dynamic var collectionURI = "" // The path to the full list of creators in this collection.,
    
    init(available: Int?,
         returned: Int?,
         collectionURI: String?
    ) {
        self.available = available ?? 0
        self.returned = returned ?? 0
        self.collectionURI = collectionURI ?? ""
        super.init()
    }
    
    required init() {
        super.init()
    }
    
}

class Summary: Object, Codable {
    @objc dynamic var resourceURI = "" // The path to the individual series resource.,
    @objc dynamic var name = "" // The canonical name of the series.
    
    init(resourceURI: String?,
         name: String?
    ) {
        self.resourceURI = resourceURI ?? ""
        self.name = name ?? ""
        super.init()
    }
    
    required init() {
        super.init()
    }
    
}

class Wrapper: Object, Codable {
    @objc dynamic var code: Int = 0 // The HTTP status code of the returned result.,
    @objc dynamic var status = "" // A string description of the call status.,
    @objc dynamic var copyright = "" // The copyright notice for the returned result.,
    @objc dynamic var attributionText = "" // The attribution notice for this result. Please display either this notice or the contents of the attributionHTML field on all screens which contain data from the Marvel Comics API.,
    @objc dynamic var attributionHTML = "" // An HTML representation of the attribution notice for this result. Please display either this notice or the contents of the attributionText field on all screens which contain data from the Marvel Comics API.,
    @objc dynamic var etag = "" // A digest value of the content returned by the call.
    
    init(code: Int?,
         status: String?,
         copyright: String?,
         attributionText: String?,
         attributionHTML: String?,
         etag: String? = ""
    ) {
        self.code = code ?? 0
        self.status = status ?? ""
        self.copyright = copyright ?? ""
        self.attributionText = attributionText ?? ""
        self.attributionHTML = attributionHTML ?? ""
        self.etag = etag ?? ""
        super.init()
    }
    
    required init() {
        super.init()
    }
    
}

class Container: Object, Codable {
    @objc dynamic var offset: Int = 0 // The requested offset (number of skipped results) of the call.,
    @objc dynamic var limit: Int = 0 // The requested result limit.,
    @objc dynamic var total: Int = 0 // The total number of resources available given the current filter set.,
    @objc dynamic var count: Int = 0 // The total number of results returned by this call.,
    
    init(offset: Int?,
         limit: Int?,
         total: Int?,
         count: Int?
    ) {
        self.offset = offset ?? 0
        self.limit = limit ?? 0
        self.total = total ?? 0
        self.count = count ?? 0
        super.init()
    }
    
    required init() {
        super.init()
    }
    
}
