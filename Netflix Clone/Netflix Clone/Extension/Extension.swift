//
//  Extension.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/28.
//
import UIKit

extension UIColor {
    static func colorRGBA(_ red: CGFloat,_ green: CGFloat,_ blue: CGFloat,a: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: a)
    }
    
    static func colorRGB(_ red: CGFloat,_ green: CGFloat,_ blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    class func hex(_ hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = String(cString.dropFirst())
        }
        
        assert(cString.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension String {
    static func movieDBImagePath(imagePath: String) -> String {
        "https://image.tmdb.org/t/p/w500\(imagePath)"
    }
    
    static func youtubeURLPath(videoId: String) -> String {
        "https://www.youtube.com/embed/\(videoId)"
    }
}
