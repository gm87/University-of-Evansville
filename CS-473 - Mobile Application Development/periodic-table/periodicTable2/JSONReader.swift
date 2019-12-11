//
//  JSONReader.swift
//  periodicTable
//
//  Created by Graham Matthews on 9/22/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import Foundation

struct ElementArray: Codable {
    let elements: [Element]
}

struct Element: Codable {
    let name: String?
    let appearance: String?
    let atomic_mass: Double?
    let boil: Double?
    let category: String?
    let color: String?
    let density: Double?
    let discovered_by: String?
    let melt: Double?
    let molar_heat: Double?
    let named_by: String?
    let number: Int?
    let period: Int?
    let phase: String?
    let source: String?
    let spectral_img: String?
    let summary: String?
    let symbol: String?
    let xpos: Int?
    let ypos: Int?
    let shells: [Int]?
    let electron_configuration: String?
    let electron_affinity: Double?
    let electronegativity_pauling: Double?
    let ionizatoin_energies: Double?
}

class JSONReader{
    
    func readJSON (filename: String) -> ElementArray? {
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            let data = try? Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let result = try! decoder.decode(ElementArray.self, from: data!)
            
            return result
        }
        return nil
    }
}
