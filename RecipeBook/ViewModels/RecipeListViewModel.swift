////
////  RecipeListViewModel.swift
////  RecipeBook
////
////  Created by AVISHKA RAVISHAN on 2023-06-16.
////
//
//import Foundation
//
//class RecipeListViewModel: ObservableObject {
//    static let shared = RecipeListViewModel()
//
//    @Published var recipes: [Recipe] = []
//    @Published var searchText: String = ""
//    @Published var searchResults: [Recipe] = []
//
//    private let recipeManager = RecipeManager()
//
//    init() {
//        // Example recipe data with images
//        let recipe1 = Recipe(id:UUID().uuidString,title: "Pasta Carbonara", ingredients: ["Spaghetti", "Eggs", "Bacon", "Parmesan"], instructions: "1. Cook spaghetti. 2. Fry bacon. 3. Beat eggs with Parmesan. 4. Combine all ingredients.", imageURL:URL(string:  "https://www.photobox.co.uk/blog/wp-content/uploads/2019/07/recipe-book-2-UK-1600x1200.jpg"))
//        let recipe2 = Recipe(id:UUID().uuidString,title: "Chicken Stir-Fry", ingredients: ["Chicken breast", "Vegetables", "Soy sauce", "Garlic", "Ginger"], instructions: "1. Stir-fry chicken. 2. Add vegetables. 3. Mix soy sauce, garlic, and ginger. 4. Combine all ingredients.", imageURL:URL(string:  "https://houseofbread.com/wp-content/uploads/recipebook.jpg"))
//        let recipe3 = Recipe(id:UUID().uuidString,title: "Supari Stir-Fry", ingredients: ["Chicken breast", "Vegetables", "Soy sauce", "Garlic", "Ginger"], instructions: "1. Stir-fry chicken. 2. Add vegetables. 3. Mix soy sauce, garlic, and ginger. 4. Combine all ingredients.", imageURL:URL(string:  "https://houseofbread.com/wp-content/uploads/recipebook.jpg"))
//        let recipe4 = Recipe(id:UUID().uuidString,title: "Buwabuwa Stir-Fry", ingredients: ["Chicken breast", "Vegetables", "Soy sauce", "Garlic", "Ginger"], instructions: "1. Stir-fry chicken. 2. Add vegetables. 3. Mix soy sauce, garlic, and ginger. 4. Combine all ingredients.", imageURL:URL(string:  "https://houseofbread.com/wp-content/uploads/recipebook.jpg"))
//
//        recipeManager.addRecipe(recipe1)
//        recipeManager.addRecipe(recipe2)
//        recipeManager.addRecipe(recipe3)
//        recipeManager.addRecipe(recipe4)
//
//        recipes = recipeManager.recipes
//    }
//
//    func addRecipe(_ recipe: Recipe) {
//        recipeManager.addRecipe(recipe)
//        recipes = recipeManager.recipes
//    }
//
//    func searchRecipes(with keyword: String) -> [Recipe] {
//        let lowercasedKeyword = keyword.lowercased()
//        return recipes.filter { $0.title.lowercased().contains(lowercasedKeyword) }
//    }
//}
//
