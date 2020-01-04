//
//  Presentation
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public typealias Tap = () -> Void
public typealias LinkTap = (String) -> Void
public typealias TapWithIndex = (IndexPath) -> Void
public typealias Edit = (String) -> ()
public typealias EditAtPosition = (Any, NSRange, String, CGRect) -> ()
public typealias EditWithFont = (FontCalculable) -> Void
public typealias SelectAtIndex = (Int) -> ()
public typealias Switch = (Bool) -> ()

public enum ContentInteractionType {
    case tap(URL)
    case tapNormal(String)
    case preview(URL)
}

public typealias ContentInteraction = (ContentInteractionType)->Void


