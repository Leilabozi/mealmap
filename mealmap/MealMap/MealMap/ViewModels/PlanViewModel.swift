import Foundation
import SwiftUI
import Combine

@MainActor
final class PlanViewModel: ObservableObject {
    let mealPlanStore: MealPlanStore
    private var cancellable: AnyCancellable?

    var mealPlan: [DayPlan] { mealPlanStore.mealPlan }

    init(mealPlanStore: MealPlanStore? = nil) {
        let store = mealPlanStore ?? MealPlanStore.shared
        self.mealPlanStore = store
        cancellable = store.$mealPlan.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    func addRecipe(_ recipe: APIMeal, to day: String, mealType: MealType) {
        mealPlanStore.addRecipe(recipe, to: day, mealType: mealType)
    }

    func removeRecipe(_ recipe: APIMeal, from day: String, mealType: MealType) {
        mealPlanStore.removeRecipe(recipe, from: day, mealType: mealType)
    }
}
