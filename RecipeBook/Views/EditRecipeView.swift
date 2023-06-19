//
//  EditRecipeView.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import SwiftUI

struct EditRecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var recipeViewModel = FirebaseManager()
    @State private var editedRecipeTitle: String
    @State private var editedRecipeIngredients: [String]
    @State private var editedRecipeInstructions: String
    @State private var newIngredient: String = ""
    @State private var showSuccessMessage: Bool = false

    let recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
        _editedRecipeTitle = State(initialValue: recipe.title)
        _editedRecipeIngredients = State(initialValue: recipe.ingredients)
        _editedRecipeInstructions = State(initialValue: recipe.instructions)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Recipe Title", text: $editedRecipeTitle)
                        .font(.headline)
                        .padding(.vertical, 8)

                    Text("Ingredients")
                        .font(.headline)
                        .padding(.top)

                    ForEach(editedRecipeIngredients.indices, id: \.self) { index in
                        HStack {
                            Image(systemName: "circle")
                                .foregroundColor(.blue)
                            TextField("Ingredient", text: $editedRecipeIngredients[index])
                                .font(.headline)
                                .padding(.vertical, 8)
                            Button(action: {
                                removeIngredient(at: index)
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                            }
                        }
                    }

                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                        TextField("New Ingredient", text: $newIngredient)
                            .font(.headline)
                            .padding(.vertical, 8)
                        Button(action: {
                            addIngredient()
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.blue)
                        }
                    }

                    Text("Instructions")
                        .font(.headline)
                        .padding(.top)

                    TextEditor(text: $editedRecipeInstructions)
                        .frame(height: 150)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .padding(.vertical, 8)
                }

                Section {
                    Button(action: {
                        saveChanges()
                    }, label: {
                        Text("Save Changes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                    .listRowBackground(Color.blue)
                }
            }
            .navigationBarTitle("Edit Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
//                        Text("Cancel")
                    }
                }
            }
            .alert(isPresented: $showSuccessMessage) {
                Alert(
                    title: Text("Success"),
                    message: Text("Recipe updated successfully"),
                    dismissButton: .default(Text("OK"), action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                )
            }
        }
        .accentColor(.blue) // Enhance the accent color to blue
    }

    private func saveChanges() {
        // Create a new Recipe instance with the edited values
        let editedRecipe = Recipe(
            id: recipe.id,
            title: editedRecipeTitle,
            ingredients: editedRecipeIngredients,
            instructions: editedRecipeInstructions,
            imageURL: recipe.imageURL
        )

        // Call the updateRecipe function in the FirebaseManager to update the recipe
        FirebaseManager().updateRecipe(editedRecipe) { error in
            if let error = error {
                // Handle the error
                print("Error updating recipe: \(error.localizedDescription)")
            } else {
                // Recipe updated successfully
                showSuccessMessage = true
            }
        }
    }

    private func addIngredient() {
        guard !newIngredient.isEmpty else {
            return
        }
        editedRecipeIngredients.append(newIngredient)
        newIngredient = ""
    }

    private func removeIngredient(at index: Int) {
        editedRecipeIngredients.remove(at: index)
    }
}
