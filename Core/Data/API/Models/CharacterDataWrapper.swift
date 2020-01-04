//
//  CharacterDataWrapper.swift
//  Data
//
//  Created by Marton Kerekes on 04/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Domain
import Realm
import RealmSwift

class CharacterDataWrapper: Object, Codable, Model {
    func generateEntity() throws -> Entities.CharacterDataWrapper {
        return try Entities.CharacterDataWrapper(code: code, status: status, copyright: copyright, attributionText: attributionText, attributionHTML: attributionHTML, data: data?.generateEntity(), etag: etag)
    }
    
    required init(from entity: Entities.CharacterDataWrapper) throws {
        code = entity.code
        status = entity.status
        copyright = entity.copyright
        attributionText = entity.attributionText
        attributionHTML = entity.attributionHTML
        if let t = entity.data {
            data = try CharacterDataContainer(from: t)
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
    
    var code: Int? // The HTTP status code of the returned result.,
    var status: String? // A string description of the call status.,
    var copyright: String? // The copyright notice for the returned result.,
    var attributionText: String? // The attribution notice for this result. Please display either this notice or the contents of the attributionHTML field on all screens which contain data from the Marvel Comics API.,
    var attributionHTML: String? // An HTML representation of the attribution notice for this result. Please display either this notice or the contents of the attributionText field on all screens which contain data from the Marvel Comics API.,
    var data: CharacterDataContainer? //The results returned by the call.,
    var etag: String? // A digest value of the content returned by the call.
    
    typealias Entity = Entities.CharacterDataWrapper
}
