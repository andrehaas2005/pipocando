//
//  ProductionCountry.swift
//  Pipocando
//
//  Created by Andre  Haas on 20/02/26.
//


struct ProductionCountry: Codable {
    let iso3166_1, name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}