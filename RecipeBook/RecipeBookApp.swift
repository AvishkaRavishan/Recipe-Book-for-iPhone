//
//  RecipeBookApp.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import SwiftUI
import Firebase

@main
struct RecipeBookApp: App {
    @StateObject private var recipeViewModel = FirebaseManager()

    init() {
        FirebaseApp.configure() // Configure Firebase
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(recipeViewModel)
        }

    }
}
