import Foundation
import SwiftUI

@MainActor
final class RecipesViewModel: ObservableObject {
    @Published private(set) var recipes: [APIMeal] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var searchText = ""

    var filteredRecipes: [APIMeal] {
        guard !searchText.isEmpty else { return recipes }
        return recipes.filter { $0.strMeal.localizedCaseInsensitiveContains(searchText) }
    }

    func loadRecipes() async {
        isLoading = true
        errorMessage = nil

        do {
            recipes = try await MealService.shared.fetchAllRecipes()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
