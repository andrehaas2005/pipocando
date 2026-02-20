//
//  ProductionCompany.swift
//  Pipocando
//
//  Created by Andre  Haas on 20/02/26.
//


struct ProductionCompany: Codable {
    let id: Int
    let logoPath, name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}
