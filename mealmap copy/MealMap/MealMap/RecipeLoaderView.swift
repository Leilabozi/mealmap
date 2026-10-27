import SwiftUI

struct RecipeLoaderView: View {
    let title: String
    let fallbackImageURL: URL?
    let fallbackCategory: String

    @State private var loaded: APIMeal?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let loaded {
                RecipeDetailView(recipe: loaded)
            } else if isLoading {
                ProgressView("Loading recipe…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage {
                ContentUnavailableView {
                    Label("Unable to Load", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(errorMessage)
                }
            } else {
                // Fallback minimal detail if no match
                RecipeDetailView(recipe: APIMeal(
                    idMeal: UUID().uuidString,
                    strMeal: title,
                    strMealThumb: fallbackImageURL?.absoluteString,
                    strInstructions: nil,
                    strArea: nil,
                    strCategory: fallbackCategory,
                    ingredients: []
                ))
            }
        }
        .task { await load() }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let results = try await MealService.shared.searchMeals(named: title)
            if let exact = results.first(where: { $0.strMeal.caseInsensitiveCompare(title) == .orderedSame }) {
                loaded = exact
            } else if let first = results.first {
                loaded = first
            } else {
                errorMessage = "No recipe found for \(title)."
            }
        } catch let apiError as RecipeAPIError {
            errorMessage = apiError.userMessage
        } catch {
            errorMessage = "Couldn't load recipe. Try again."
        }
    }
}

#Preview {
    NavigationStack {
        RecipeLoaderView(title: "Apple Pie", fallbackImageURL: nil, fallbackCategory: "Dessert")
    }
}
