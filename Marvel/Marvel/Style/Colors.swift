//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public enum Color {
    
    //OBS -> Style needs to be redesign so let's not focus on the color names ...
    public static let white             = UIColor.white
    public static let clear             = UIColor.clear
    public static let black             = UIColor.black
    public static let lightBlue         = UIColor(red: 50/255.0, green: 125/255.0, blue: 247/255.0, alpha: 1.0)
    
    public static let neutralDark       = #colorLiteral(red: 0.01, green: 0.02, blue: 0.04, alpha: 1) //#03050A
    public static let neutralGray       = #colorLiteral(red: 0.25, green: 0.28, blue: 0.36, alpha: 1) //#41485D
    public static let neutralMedium     = #colorLiteral(red: 0.44, green: 0.46, blue: 0.52, alpha: 1) //#707685
    public static let neutralLight      = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1) //#EBEBEB
    public static let lightGray         = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9607843137, alpha: 1) //#F3F3F5
    
    public static let neutralTint       = #colorLiteral(red: 0.87, green: 0.91, blue: 0.99, alpha: 1) //#DFE7FD
    
    public static let base              = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //#FFFFFF
    public static let primary           = #colorLiteral(red: 0.368627451, green: 0.5294117647, blue: 0.968627451, alpha: 1) //#5E87F7
    public static let success           = #colorLiteral(red: 0.4392156863, green: 0.7529411765, blue: 0.3137254902, alpha: 1) //#70C050
    public static let error             = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1) //FF0000
    
    public static let chatPrimary       = #colorLiteral(red: 0.9828278422, green: 0.5464739799, blue: 0.1651305854, alpha: 1) //F47921
    
    public static let inactiveLight     = #colorLiteral(red: 0.81, green: 0.82, blue: 0.84, alpha: 1) //#CFD1D6
    public static let alternativeBase   = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1) //#F9F9F9
    
    //NEW TO BE Renamed or reused
    public static let primaryText       = #colorLiteral(red: 0.02352941176, green: 0.03137254902, blue: 0.0862745098, alpha: 1) //#060816
    public static let primaryTextDark   = #colorLiteral(red: 0.02745098039, green: 0.03921568627, blue: 0.08235294118, alpha: 1) //#070A15
    public static let secondaryText     = #colorLiteral(red: 0.4862745098, green: 0.5058823529, blue: 0.568627451, alpha: 1) //#7C8191
    public static let terciaryText      = #colorLiteral(red: 0.4509803922, green: 0.4549019608, blue: 0.5294117647, alpha: 1) //#737487
    
    public static let primaryButtonText   = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //#FFFFFF
    public static let secondaryButtonText = #colorLiteral(red: 0.02352941176, green: 0.03137254902, blue: 0.0862745098, alpha: 1) //#060816
    public static let tertiaryButtonText  = #colorLiteral(red: 0.568627451, green: 0.6078431373, blue: 0.6705882353, alpha: 1) //#919BAB
    
    public static let primaryButtonBackground = primary
    public static let secondaryButtonBackground = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //#FFFFFF
    
    public static let tintDark          = #colorLiteral(red: 0.6431372549, green: 0.6666666667, blue: 0.7019607843, alpha: 1) //#A4AAB3
    public static let separatorDark     = #colorLiteral(red: 0.6274509804, green: 0.6392156863, blue: 0.6784313725, alpha: 1) //#A0A3AD
    public static let terciary          = #colorLiteral(red: 0.9137254902, green: 0.9215686275, blue: 0.9411764706, alpha: 1) //#E9EBF0
    
    public static func color(_ color: UIColor, alpha: CGFloat) -> UIColor {
        return color.withAlphaComponent(alpha)
    }
}
