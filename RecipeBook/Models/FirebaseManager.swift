//
//  FirebaseManager.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager: ObservableObject {
    @Published var recipes: [Recipe] = []

    private let db = Firestore.firestore()

    // Fetch all recipes
    func fetchRecipes() {
        db.collection("recipes").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching recipes: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                return
            }

            let recipes = documents.compactMap { document -> Recipe? in
                guard let data = document.data() as? [String: Any] else {
                    return nil
                }
                return self?.recipe(from: data, withID: document.documentID)
            }

            DispatchQueue.main.async {
                self?.recipes = recipes
            }
        }
    }

    // Add a new recipe
    func addRecipe(_ recipe: Recipe) {
        do {
            let data = try self.recipeData(from: recipe)
            _ = db.collection("recipes").addDocument(data: data)
        } catch {
            print("Error adding recipe: \(error)")
        }
    }

    // Update an existing recipe
    func updateRecipe(_ recipe: Recipe, completion: @escaping (Error?) -> Void) {
        do {
            let data = try self.recipeData(from: recipe)
            guard let recipeID = recipe.id else {
                completion(nil) // Recipe ID is nil, return early
                return
            }

            db.collection("recipes").document(recipeID).setData(data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }

    // Delete a recipe
    func deleteRecipe(_ recipe: Recipe, completion: @escaping (Error?) -> Void) {
        guard let recipeID = recipe.id else {
            return
        }

        db.collection("recipes").document(recipeID).delete { error in
            completion(error)
        }
    }

    // Search recipes with a keyword
    func searchRecipes(with keyword: String, completion: @escaping ([Recipe]) -> Void) {
        db.collection("recipes")
            .whereField("title", isGreaterThanOrEqualTo: keyword)
            .whereField("title", isLessThan: keyword + "z")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    completion([])
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }

                let recipes = documents.compactMap { document -> Recipe? in
                    guard let data = document.data() as? [String: Any] else {
                        return nil
                    }
                    return self.recipe(from: data, withID: document.documentID)
                }

                completion(recipes)
            }
    }



    // Convert a recipe to dictionary representation
    private func recipeData(from recipe: Recipe) throws -> [String: Any] {
        var data: [String: Any] = [:]
        data["title"] = recipe.title
        data["ingredients"] = recipe.ingredients
        data["instructions"] = recipe.instructions
        data["imageURL"] = recipe.imageURL?.absoluteString
        return data
    }

    // Convert a dictionary to a recipe with the given ID
    private func recipe(from data: [String: Any], withID id: String) -> Recipe? {
        guard let title = data["title"] as? String,
              let ingredients = data["ingredients"] as? [String],
              let instructions = data["instructions"] as? String else {
            return nil
        }

        let imageURLString = data["imageURL"] as? String
        let imageURL = URL(string: imageURLString ?? "")

        let recipe = Recipe(id: id, title: title, ingredients: ingredients, instructions: instructions, imageURL: imageURL)
        return recipe
    }
}
