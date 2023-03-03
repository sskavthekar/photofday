//
//  PhotoDetails.swift
//  photofday
//
//  Created by Siddharth on 02/03/23.
//

import Foundation

struct PhotoDetails: Decodable {
    var title: String!
    var explanation: String!
    var url: String!
    var hdurl: String!
    var date: String
    
    enum Category: String, Decodable {
        case hdurl, url, title, explanation, date
    }
    
    enum CodingKeys: CodingKey {
        case title
        case explanation
        case url
        case hdurl
        case date
    }
    
    public var isValid: Bool {
        return !title.isEmpty && !explanation.isEmpty &&  !hdurl.isEmpty
    }
}
