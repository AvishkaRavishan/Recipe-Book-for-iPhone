//
//  RecipeManager.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import Foundation

class RecipeManager {
    var recipes: [Recipe] = []

    func toggleLanguage() {
        let locale = Locale.current
        let newLocale = locale.identifier == "si" ? Locale(identifier: "en") : Locale(identifier: "si")
        UserDefaults.standard.set([newLocale.identifier], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}
