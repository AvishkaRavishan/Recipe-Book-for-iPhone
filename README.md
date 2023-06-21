New App: Localisation added; Sinhala Language
link: https://github.com/AvishkaRavishan/RecipeBook.git

This iOS App is built for study purposes at the university - MADD Module

# Project Name - RecipeBook
#### 01. Brief Description of Project - 
The project is called "RecipeBook," and it appears to be an iOS application for managing and discovering recipes. The app allows users to view a list of recipes, search for specific recipes, add new recipes, and edit existing recipes. The recipes are fetched from Firebase and displayed in a list format, along with their respective images and titles.

#### 02. Users of the System - 
Professional Chefs, Food Enthusiasts, Home Cooks, Cooking Enthusiasts

#### 03. What is unique about your solution -
* Combination of recipe management, localization, and search functionality
* Supports multiple languages for recipe viewing and interaction
* Comprehensive recipe management feature with add, edit, and delete capabilities
* Organized and user-friendly list view for browsing recipes
* Robust search functionality based on keywords and ingredients
* Clean and intuitive user interface for seamless navigation
* Integration with Firebase for reliable data storage and synchronization
* Convenient access to recipes from any device with internet connection
* User-centric approach focused on enhancing cooking and recipe exploration experience.

#### 04. Briefly document the functionality of the screens you have (Include screen shots of images)
e.g. The first screen is used to capture a photo and it will be then processed for identifying the landmarks in the photo.

![simulator_screenshot_5000B8E1-C409-48D2-9174-39943E842081](https://github.com/SE4020/assignment-02-AvishkaRavishan/assets/101692241/ec2079d0-e4b3-45d7-b1c9-dd81c1ad511e)


#### 05. Give examples of best practices used when writing code

```

struct Recipe: Identifiable, Equatable {
    var id :UUID
    var title: String
    var ingredients: [String]
    var instructions: String
    var imageURL: String?
}


    
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

```

#### 06. UI Components used
NavigationView, Form, Section, TextField, Text, TextEditor, List, NavigationLink, Image, Button, Alert, ToolbarItem, Sheet


#### 07. Testing carried out

e.g. The following classes implemented unit testing for the ```Landmark struct``` and ```Location struct```. 

```
    struct TestLandMarks {
       let name: String
```

#### 08. Documentation 

(a) Design Choices
* User-Centered Design: Prioritize the needs and preferences of the target users. Conduct user research to understand their behavior, goals, and pain points. Design the app in a way that aligns with user expectations and provides a seamless and intuitive experience.
* Consistency: Maintain a consistent design throughout the app to create a cohesive and polished look. Use consistent typography, color schemes, and visual elements across screens. This helps users navigate the app easily and builds familiarity.
* Simplified Interface: Strive for simplicity and avoid clutter. Streamline the user interface by removing unnecessary elements and providing clear navigation. Use whitespace to create breathing room and enhance readability.

(b) Implementation Decisions
* Error Handling and Validation: Establish a robust error handling and validation mechanism to handle potential issues such as network errors, input validation, and data inconsistencies. Provide meaningful error messages and appropriate feedback to the user.
* Localization: Decide on the approach for implementing localization and supporting multiple languages within the app. This involves creating localized string files and implementing the necessary logic to switch between different language versions of the app.
* Data Management: Determine how data will be managed within the app. This includes decisions on data storage, retrieval, and synchronization. In this case, Firebase was used as the backend service to store and retrieve recipe data.

(c) Challenges
* Integration Issues: Integrating third-party libraries or services, such as Firebase, can sometimes be challenging. Configuring the libraries correctly, handling dependencies, and resolving any compatibility issues could have posed difficulties.
* Performance Optimization: Ensuring the app performs well, loads data efficiently, and responds promptly to user interactions can be challenging. Optimizing resource usage, minimizing network requests, and caching data effectively are tasks that require careful implementation and testing.
* User Interface Design: Designing an intuitive and visually appealing user interface can be challenging. Ensuring consistent layout, handling different screen sizes and orientations, and incorporating user feedback can be time-consuming.


#### 09. Additional iOS Library used

SDWebImageSwiftUI: This library is used to asynchronously load and display images from remote URLs in the RecipeListView view. It provides a convenient way to handle image caching, loading, and rendering.

#### 10. Reflection of using SwiftUI compared to UIKit
Declarative UI
Less boilerplate code
Live preview and interactive development
Cross-platform compatibility
Built-in state management
Simplified animation and transitions
Native support for Dark Mode and accessibility
Seamless integration with Swift programming language

#### 11. Reflection General

* Learning curve: If you are new to SwiftUI or any of the libraries used in the assignment, there might be a learning curve involved in understanding the concepts and best practices.
* API integration: Integrating Firebase, Firestore, or other external APIs can sometimes be challenging, especially if there are authentication or permission-related issues.
* Localization: Implementing localization in an app requires careful handling of string translations and managing different language files.
* Design consistency: Maintaining a consistent design throughout the app can be challenging, especially if there are different UI components and styles used in different views.
* Data management: Managing data flow, state management, and syncing data across views can be complex, especially in a larger app with multiple screens and interactions.

  


