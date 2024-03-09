//
//  Product.swift
//  Check24OfflineTask
//
//  Created by Ali Görkem Aksöz on 9.03.2024.
//

import Foundation

// MARK: - Product
struct Product: Codable {
    let header: Header?
    let filters: [String]?
    let products: [ProductElement]?
}

// MARK: - Header
struct Header: Codable {
    let headerTitle, headerDescription: String?
}

// MARK: - ProductElement
struct ProductElement: Identifiable, Codable {
    let name: String?
    let type: TypeEnum?
    let id: Int?
    let color: Colour?
    let imageURL: String?
    let colorCode: ColorCode?
    let available: Bool?
    let releaseDate: Int?
    let description, longDescription: String?
    let rating: Double?
    let price: Price?
}

enum Colour: String, Codable {
    case blue = "Blue"
    case green = "Green"
    case red = "Red"
    case yellow = "Yellow"
}

enum ColorCode: String, Codable {
    case bbdefb = "BBDEFB"
    case c8E6C9 = "C8E6C9"
    case ffCDD2 = "ffCDD2"
    case ffecb3 = "FFECB3"
}

// MARK: - Price
struct Price: Codable {
    let value: Double?
    let currency: String?
}

enum TypeEnum: String, Codable {
    case circle = "Circle"
    case hexagon = "Hexagon"
    case square = "Square"
    case triangle = "Triangle"
}
