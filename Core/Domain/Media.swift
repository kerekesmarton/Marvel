//
//  Media.swift
//  Domain
//
//  Created by Marton Kerekes on 04/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation

public class Media {
    
    public enum ModelType: String {
        case image = "IMAGE"
        case video = "VIDEO"
    }
    public var _id: String
    
    public var type: ModelType
    
    public var url: String
    
    public init(_id: String, type: ModelType, url: String) {
        self._id = _id
        self.type = type
        self.url = url
    }
    
    public class Image {
        public var data: Data
        public init(data: Data) {
            self.data = data
        }
    }

    public class Video {
        public let data: Data
        public var previewData: Data?
        public let url: URL
        public init(url: URL, data: Data) {
            self.url = url
            self.data = data
        }
    }
}


