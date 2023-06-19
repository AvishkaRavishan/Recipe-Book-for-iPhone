//
//  RecipeDetailView.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var recipeImage: UIImage?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let image = recipeImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text(recipe.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    Section(header: Text("Ingredients").font(.title).fontWeight(.bold).padding(.top)) {
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            Text("• \(ingredient)")
                        }
                    }
                    .padding(.horizontal)

                    Divider()

                    Section(header: Text("Instructions").font(.title).fontWeight(.bold).padding(.top)) {
                        Text(recipe.instructions)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                }
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitle(recipe.title)
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let imageURL = recipe.imageURL, let url = URL(string:imageURL.absoluteString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to load image: \(error)")
                return
            }
            
            if let imageData = data, let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    recipeImage = image
                }
            }
        }.resume()
    }
}
