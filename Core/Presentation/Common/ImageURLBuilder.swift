//
//  ImageURLBuilder.swift
//  Presentation
//
//  Created by Marton Kerekes on 05/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain

extension Entities.Image {
    public enum Size: String {
        case portrait_small
        case portrait_medium
        case portrait_xlarge
        case portrait_fantastic
        case portrait_uncanny
        case portrait_incredible
        
        case standard_small
        case standard_medium
        case standard_large
        case standard_xlarge
        case standard_fantastic
        case standard_amazing
        
        case landscape_small
        case landscape_medium
        case landscape_large
        case landscape_xlarge
        case landscape_amazing
        case landscape_incredible
        
        case detail
        
        case full = ""
    }

    public func createURL(size: Size) -> URL?{
        guard var path = path, let ext = `extension` else {
            return nil
        }
        switch size {
        case .full:
            path.append(contentsOf:"."+ext)
            path = path.replacingOccurrences(of: "http:", with: "https:")
            return URL(string: path)
        default:
            path.append(contentsOf: "/"+size.rawValue+"."+ext)
            path = path.replacingOccurrences(of: "http:", with: "https:")
            return URL(string: path)
        }
        
    }
}
