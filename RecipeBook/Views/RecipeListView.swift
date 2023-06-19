//
//  RecipeListView.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI

struct RecipeListView: View {
    @ObservedObject private var recipeViewModel = FirebaseManager()
    @State private var selectedRecipe: Recipe?
    @State private var isEditingRecipe = false

    var body: some View {
        NavigationView {
            VStack {
                if let url = URL(string: "https://houseofbread.com/wp-content/uploads/recipebook.jpg"),
                   let imageData = try? Data(contentsOf: url),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                }
                
                List {
                    ForEach(recipeViewModel.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            HStack {
                                if let imageURL = recipe.imageURL {
                                    WebImage(url: imageURL)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(5)
                                        .padding(.trailing, 10) // Add padding to create consistent spacing
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(5)
                                        .padding(.trailing, 10) // Add padding to create consistent spacing
                                }

                                VStack(alignment: .leading) {
                                    Text(recipe.title)
                                        .font(.headline)
                                }
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button(action: {
                                // Navigate to EditRecipeView
                                selectedRecipe = recipe
                                isEditingRecipe = true
                            }) {
                                Label(NSLocalizedString("edit", comment: ""), systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                    .onDelete { indexSet in
                        guard let index = indexSet.first else {
                            return
                        }
                        let recipeToDelete = recipeViewModel.recipes[index]
                        recipeViewModel.deleteRecipe(recipeToDelete) { error in
                            if let error = error {
                                // Handle the error
                                print("Error deleting recipe: \(error.localizedDescription)")
                            } else {
                                // Recipe deleted successfully
                                recipeViewModel.fetchRecipes() // Refresh the recipe list
                            }
                        }
                    }
                    .onMove { indices, newOffset in
                        recipeViewModel.recipes.move(fromOffsets: indices, toOffset: newOffset)
                        // TODO: Update the order of recipes in Firebase or perform any necessary actions
                    }
                }
                .listStyle(PlainListStyle())
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                .sheet(item: $selectedRecipe) { recipe in
                    NavigationView {
                        EditRecipeView(recipe: recipe)
                            .navigationBarItems(leading: Button("Cancel") {
                                isEditingRecipe = false
                                selectedRecipe = nil
                            })
                    }
                }
                .onAppear {
                    recipeViewModel.fetchRecipes()
                }
                .navigationTitle(NSLocalizedString("recipes", comment: ""))
            }
        }
        .accentColor(.blue)
    }
}
