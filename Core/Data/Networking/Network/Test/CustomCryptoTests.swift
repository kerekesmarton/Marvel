//
//  CustomCryptoTests.swift
//  DataTests
//
//  Created by Marton Kerekes on 05/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import XCTest
@testable import Data

class CustomCryptoTests: XCTestCase {

    func testCrypto() {
        let md5Hex = CustomCrypto().md5Hex(from: "Hello")

        XCTAssertEqual(md5Hex, "8b1a9953c4611296a827abf8c47804d7")

        let md5Base64 = CustomCrypto().md5Base64(from: "Hello")
        XCTAssertEqual(md5Base64, "ixqZU8RhEpaoJ6v4xHgE1w==")

    }

}
