//
//  AddRecipeView.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import SwiftUI

struct AddRecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var recipeViewModel = FirebaseManager()
//    @State private var viewManager = RecipeManager()
    @State private var newRecipeTitle = ""
    @State private var newIngredient = ""
    @State private var newRecipeIngredients: [String] = []
    @State private var newRecipeInstructions = ""
    @State private var newRecipeImageURL = ""
    @State private var showError = false
    @State private var showSuccess = false
    @State private var navigateToRecipeList = false

    var body: some View {
        NavigationView {
                    Form {
                        Section(header: Text(LocalizedStringKey("Recipe Details"))) {
                            TextField(LocalizedStringKey("Recipe Title"), text: $newRecipeTitle)
                                .font(.headline)
                                .padding(.vertical, 8)

                            TextField(LocalizedStringKey("Image URL"), text: $newRecipeImageURL)
                                .font(.headline)
                                .padding(.vertical, 8)

                            Text(LocalizedStringKey("Ingredients"))
                                .font(.headline)
                                .padding(.top)

                            ForEach(newRecipeIngredients.indices, id: \.self) { index in
                                HStack {
                                    Image(systemName: "circle")
                                        .foregroundColor(.blue)
                                    TextField(LocalizedStringKey("Ingredient"), text: $newRecipeIngredients[index])
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
                                TextField(LocalizedStringKey("New Ingredient"), text: $newIngredient)
                                    .font(.headline)
                                    .padding(.vertical, 8)
                                Button(action: {
                                    addIngredient()
                                }) {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical, 8)

                            Text(LocalizedStringKey("Instructions"))
                                .font(.headline)
                                .padding(.top)

                            TextEditor(text: $newRecipeInstructions)
                                .frame(height: 150)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                                .padding(.vertical, 8)
                        }

                        Section {
                            Button(action: {
                                addRecipe()
                            }, label: {
                                Text(LocalizedStringKey("Add Recipe"))
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            })
                            .listRowBackground(Color.blue)
                            .disabled(newRecipeTitle.isEmpty || newRecipeIngredients.isEmpty)
                        }
                    }
            
            
                    .navigationBarTitle(LocalizedStringKey("Add Recipe"))

            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text("Recipe title is required."), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showSuccess) {
                Alert(
                    title: Text("Success"),
                    message: Text("Recipe added successfully"),
                    dismissButton: .default(Text("OK"), action: {
                        navigateToRecipeList = true
                    })
                )
            }
            .background(
                NavigationLink(
                    destination: RecipeListView(),
                    isActive: $navigateToRecipeList,
                    label: { EmptyView() }
                )
            )
        }
    }

    private func addIngredient() {
        let ingredient = newIngredient.trimmingCharacters(in: .whitespacesAndNewlines)
        if !ingredient.isEmpty {
            newRecipeIngredients.append(ingredient)
            newIngredient = ""
        }
    }

    private func removeIngredient(at index: Int) {
        newRecipeIngredients.remove(at: index)
    }

    private func addRecipe() {
        guard !newRecipeTitle.isEmpty else {
            showError = true
            return
        }

        let recipe = Recipe(
            id: UUID().uuidString,
            title: newRecipeTitle,
            ingredients: newRecipeIngredients,
            instructions: newRecipeInstructions,
            imageURL: URL(string: newRecipeImageURL)
        )

        recipeViewModel.addRecipe(recipe)

        showSuccess = true

        // Clear the fields
        newRecipeTitle = ""
        newIngredient = ""
        newRecipeIngredients = []
        newRecipeInstructions = ""
        newRecipeImageURL = ""
    }

    private func navigateBack() {
        presentationMode.wrappedValue.dismiss()
    }
}
