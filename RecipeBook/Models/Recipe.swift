//
//  Recipe.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-15.
//

import Foundation

struct Recipe: Identifiable {
    let id: String? // `id` property of type `String`
    let title: String
    let ingredients: [String]
    let instructions: String
    let imageURL: URL?
}
