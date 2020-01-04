///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import XCTest
@testable import Data
@testable import Domain

class TokenParserTests: XCTestCase {

    let parser = TokenParser()
    
    func test_GivenJWT_WhenParsing_ThenValuesReturned() {
        let string = "eyJraWQiOiJzekVRaThLMG5yN0RNcEhmREdYV040Tk9hSHlpWEJFWmxyQnNuUlZITThzPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiJjNGY0NDAyMC0yMmUwLTRiMTItYjYzMi1hMWI3MmNlNjhkNTYiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwidGVuYW50S2V5IjoiY29ubmVjdHQuc29jaWFsLmRldjAxLmNvbm5lY3R0LmNsb3VkIiwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLmV1LXdlc3QtMS5hbWF6b25hd3MuY29tXC9ldS13ZXN0LTFfQTZhYjRJVXJpIiwiY29nbml0bzp1c2VybmFtZSI6ImM0ZjQ0MDIwLTIyZTAtNGIxMi1iNjMyLWExYjcyY2U2OGQ1NiIsInVzZXJJZCI6ImY4ZGQ5ZmU2LTJkNmUtNDNmYS05MGJhLTYyMTM3ZGFkZDU5MyIsImF1ZCI6IjZpMjNkNzhoMjBoM2tmNDFvNmhjaTNlaWhiIiwiZXZlbnRfaWQiOiJjZjE3YTUyNy03ZDViLTExZTktOWMzNC0wMTQ3OWNjMGRkYmMiLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTU1ODYxNjg4OCwidGVuYW50SWQiOiI5MzU1NmM1NS1hNzc0LTRkZGYtODVjMi00MTY3YjAzNmVlNDQiLCJleHAiOjE1NTg2MjA0ODgsImlhdCI6MTU1ODYxNjg4OCwiZW1haWwiOiJtaWNoYWVsLm5haGtpZXNAY29ubmVjdHQudXMifQ.mgDtr6vjaqGUk3T44cpVcO0FPI2PZ4Ve6TSkjaYnrM_fesBJD0Aw9A8FXNdFk_oobYut4-9DjYiMwjaTxxN2kABy6qS5L1-1_6mxZV36jUICUjQdf7N0N-SyRWNBZzoWD3F9dEHvsfw183UwWll5DODSaJXxR8DYdAtLTCKrM6uf_g0wELJO7fIYwZns56ehgtS2o0TlFdrfAgW6OUnFD36KyPRKd9eAyP0ZQQmXvRL-rov6Ve_PoqsP9aKzoqQx9aCQ0gzczs_xvOrXr5u_Jg-7OErq3lW4S6LB5sxvLVP_ORSgwkIAa1a1v1Rx6IfS7cA5IJ5tVwHmWftipJwVLA"
        
        do {
            let token = try parser.parse(token: string)
            XCTAssertEqual(token.body.userId, "f8dd9fe6-2d6e-43fa-90ba-62137dadd593")
            XCTAssertEqual(token.body.tenantId, "93556c55-a774-4ddf-85c2-4167b036ee44")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
