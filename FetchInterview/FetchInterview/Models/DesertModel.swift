//
//  DesertModel.swift
//  FetchInterview
//
//  Created by Nemanja Risteski on 3/5/23.
//

import Foundation

// Initial general information about the downloaded desert used to represent it in the starting list
// includes name and picture, and mealID is later used to obtain specific information about the desert
struct Desert : Codable, Comparable, Identifiable {
    var id = UUID()
    
    let strMeal: String
    let strMealThum: String
    let idMeal: String
    
    static func < (d1: Desert, d2: Desert) -> Bool {
        return d1.strMeal < d2.strMeal
    }
}

