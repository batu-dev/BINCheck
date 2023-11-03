//
//  CardInfo.swift
//  BCCheck
//
//  Created by batu on 2.11.2023.
//

import Foundation

//MARK: - API Model stuffs
struct NumberInfo: Codable {
    let length: Int
    let luhn: Bool
}

struct CountryInfo: Codable {
    let numeric: String
    let alpha2: String
    let name: String
    let emoji: String
    let currency: String
    let latitude: Double
    let longitude: Double
}
struct BankInfo: Codable {
    let name: String?
}

struct CardInfo: Codable {
    let number: NumberInfo
    let scheme: String
    let type: String
    let brand: String
    let prepaid: Bool
    let country: CountryInfo
    let bank: BankInfo
}
