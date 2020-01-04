//
//  APIs.swift
//  Data
//
//  Created by Marton Kerekes on 03/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain

extension NetworkDataServiceFactory {

    public static func GetCharacterListDataService(_ config: Configurable) -> SpecialisedDataService {
        let requestBuilder = GetCharacterListRequestBuilder(store: config.userProfileStore, config: config.settings)
        let parser = CharacterDataParser()
        return NetworkDataService(requestBuilder: requestBuilder, dataParser: parser, dataEncoder: GenericDataEncoder(), session: config.session, dataPersistence: DataPersistence<Entities.CharacterDataWrapper, CharacterDataWrapper>())
    }
}

class GetCharacterListRequestBuilder: RequestBuilding {
    var httpBody: Data?
    var method: HTTPMethod? = HTTPMethod(rawValue: "GET")
    var parameters = [String:String]()
    lazy var uri: URL = {
        return settings.environment.baseUrl
    }()
    var token: String? {
        return store.token
    }
    private let store: UserProfileStoring
    private let settings: SettingsConfigurable
    init(store: UserProfileStoring, config: SettingsConfigurable) {
        self.store = store
        self.settings = config
    }

    func createUrl() throws -> URL {
        let path = "/v1/public/characters"
        return uri.appendingPathComponent(path)
    }

    func preprocess(parameters: inout [String:String]) -> [String:String] {
        return parameters
    }

    func persistenceRequest(parameters: [String:String]) -> [String:String] {
        return [:]
    }
        
}


extension NetworkDataServiceFactory {

    public static func GetCharacterDataService(_ config: Configurable) -> SpecialisedDataService {
        let requestBuilder = GetCharacterListRequestBuilder(store: config.userProfileStore, config: config.settings)
        let parser = CharacterDataParser()
        return NetworkDataService(requestBuilder: requestBuilder, dataParser: parser, dataEncoder: GenericDataEncoder(), session: config.session, dataPersistence: DataPersistence<Entities.CharacterDataWrapper, CharacterDataWrapper>())
    }
}

class GetCharacterRequestBuilder: RequestBuilding {
    var httpBody: Data?
    var method: HTTPMethod? = HTTPMethod(rawValue: "GET")
    var parameters = [String:String]()
    lazy var uri: URL = {
        return settings.environment.baseUrl
    }()
    var token: String? {
        return store.token
    }
    private let store: UserProfileStoring
    private let settings: SettingsConfigurable
    init(store: UserProfileStoring, config: SettingsConfigurable) {
        self.store = store
        self.settings = config
    }

    var characterId: String?

    func createUrl() throws -> URL {        
        guard let characterId = characterId else {
            throw ServiceError.parsing("characterId not defined")
        }
        
        var path = "/v1/public/characters"
        let profileIdPreEscape = "\(characterId)"
        let profileIdPostEscape = profileIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{characterId}", with: profileIdPostEscape, options: .literal, range: nil)
        return uri.appendingPathComponent(path)
    }

    func preprocess(parameters: inout [String:String]) -> [String:String] {
        if let characterId = String(safe: parameters["characterId"])  {
            self.characterId = characterId
            parameters["characterId"] = nil
        }
        return parameters
    }

    func persistenceRequest(parameters: [String:String]) -> [String:String] {
        if let id = parameters["characterId"] {
            return ["id":id]
        }        
        return [:]
    }
        
}
