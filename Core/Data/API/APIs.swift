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
        let crypto: CustomCrypto = CustomCrypto()
        let requestBuilder = GetCharacterListRequestBuilder(store: config.userProfileStore, config: config.settings, crypto: crypto)
        let parser = CharacterDataParser()
        return NetworkDataService(requestBuilder: requestBuilder, dataParser: parser, dataEncoder: GenericDataEncoder(), session: config.session, dataPersistence: DataPersistence<Entities.CharacterDataWrapper, CharacterDataWrapper>())
    }
}

class GetCharacterListRequestBuilder: BaseRequestBuilder, RequestBuilding {
    func createUrl() throws -> URL {
        let path = "/v1/public/characters"
        let url = uri.appendingPathComponent(path)
        return try url.add(queryItems: makeQueryItems())
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
        let crypto: CustomCrypto = CustomCrypto()
        let requestBuilder = GetCharacterListRequestBuilder(store: config.userProfileStore, config: config.settings, crypto: crypto)
        let parser = CharacterDataParser()
        return NetworkDataService(requestBuilder: requestBuilder, dataParser: parser, dataEncoder: GenericDataEncoder(), session: config.session, dataPersistence: DataPersistence<Entities.CharacterDataWrapper, CharacterDataWrapper>())
    }
}

class GetCharacterRequestBuilder: BaseRequestBuilder, RequestBuilding {

    var characterId: String?

    func createUrl() throws -> URL {
        guard let characterId = characterId else {
            throw ServiceError.parsing("characterId not defined")
        }
        
        var path = "/v1/public/characters"
        let profileIdPreEscape = "\(characterId)"
        let profileIdPostEscape = profileIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{characterId}", with: profileIdPostEscape, options: .literal, range: nil)
        let url = uri.appendingPathComponent(path)
        return try url.add(queryItems: makeQueryItems())
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
