//
//  Composer.swift
//  Composers
//
//  Created by Enoch Chan on 4/8/21.
//

import Foundation

class Composer: CustomDebugStringConvertible, Codable {
    var debugDescription: String {
        // this code will be called each time debugDescription is accessed
        return "Composer(name: \(self.name), period: \(self.period))"
    }
    
    var name: String
    var period: String
    var country: String
    var favorite: Bool = false
    var imageUrl: String
    var biography: String
    var pieceNames: Array<String>
    var pieceUrls: Array<String>
    
    private enum CodingKeys: String, CodingKey {
        // used in conjunction with Codable to determine which keys should Codable be looking for in the JSON to hydrate our object from JSON to a composer class
        case name, period, country, imageUrl, biography, pieceNames, pieceUrls
    }
    
    init(named name: String, period: String, country: String, imageUrl: String, biography: String, pieceNames: Array<String>, pieceUrls: Array<String>) {
        self.name = name
        self.period = period
        self.country = country
        self.imageUrl = imageUrl
        self.biography = biography
        self.pieceNames = pieceNames
        self.pieceUrls = pieceUrls
    }
}

struct ComposerResult: Codable {
    // Codable is a tool provided to make it easy to encode/decode classes and structs between their class/struct representation (the object you are used to seeing in SWIFT), and  JSON representation (used to pass objects over HTTP)
    let composers: [Composer]
}
