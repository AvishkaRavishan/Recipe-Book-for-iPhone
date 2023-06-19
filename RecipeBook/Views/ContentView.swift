//
//  ContentView.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var recipeViewModel = FirebaseManager()
    @State private var searchText = ""
    @State private var searchResults: [Recipe] = []

    var body: some View {
        TabView {
            RecipeListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text(NSLocalizedString("recipes", comment: ""))
                }
            
            SearchView(searchText: $searchText, searchResults: $searchResults)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text(NSLocalizedString("search", comment: ""))
                }

            AddRecipeView()
                .tabItem {
                    Image(systemName: "plus.square")
                    Text(NSLocalizedString("addRecipe", comment: ""))
                }

        }
        .onAppear {
            recipeViewModel.fetchRecipes()
        }
    }
}
