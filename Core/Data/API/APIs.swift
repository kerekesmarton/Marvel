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
        let requestBuilder = GetCharacterListRequestBuilder(store: config.userProfileStore, config: config.settings, crypto: crypto, uniqueStringProviding: config.uniqueStringProviding)
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

    public static func GetSeriesListDataService(_ config: Configurable) -> SpecialisedDataService {
        let crypto: CustomCrypto = CustomCrypto()
        let requestBuilder = GetSeriesListRequestBuilder(store: config.userProfileStore, config: config.settings, crypto: crypto, uniqueStringProviding: config.uniqueStringProviding)
        let parser = SeriesDataParser()
        return NetworkDataService(requestBuilder: requestBuilder, dataParser: parser, dataEncoder: GenericDataEncoder(), session: config.session, dataPersistence: DataPersistence<Entities.SeriesDataWrapper, SeriesDataWrapper>())
    }
}

class GetSeriesListRequestBuilder: BaseRequestBuilder, RequestBuilding {
    func createUrl() throws -> URL {
        let path = "/v1/public/series"
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
