import Foundation
import SwiftUI
import Combine

@MainActor
final class GroceriesViewModel: ObservableObject {
    @Published var checkedItems: Set<String> = []
    private let mealPlanStore: MealPlanStore
    private var cancellable: AnyCancellable?

    init(mealPlanStore: MealPlanStore? = nil) {
        let store = mealPlanStore ?? MealPlanStore.shared
        self.mealPlanStore = store
        cancellable = store.$mealPlan.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    var groceriesByCategory: [GroceryCategory: [String]] {
        var categoryDict: [GroceryCategory: Set<String>] = [:]

        for day in mealPlanStore.mealPlan {
            for mealList in day.meals.values {
                for recipe in mealList {
                    for ingredient in recipe.ingredients {
                        let display = ingredient.measure.isEmpty
                            ? ingredient.name
                            : "\(ingredient.measure) \(ingredient.name)"
                        let category = GroceryCategory.categorize(ingredient: ingredient.name)
                        categoryDict[category, default: []].insert(display)
                    }
                }
            }
        }

        return categoryDict.mapValues { Array($0).sorted() }
    }

    var categories: [GroceryCategory] {
        GroceryCategory.allCases.filter { groceriesByCategory[$0]?.isEmpty == false }
    }

    func toggle(item: String) {
        if checkedItems.contains(item) {
            checkedItems.remove(item)
        } else {
            checkedItems.insert(item)
        }
    }
}
