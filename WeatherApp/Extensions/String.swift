//
//  String.swift
//  WeatherApp
//
//  Created by Алексей on 26.06.2021.
//

import Foundation

extension String{
    var encodeUrl : String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String {
        return self.removingPercentEncoding!
    }
}
