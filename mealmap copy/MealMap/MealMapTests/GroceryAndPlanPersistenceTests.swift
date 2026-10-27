import Foundation
import SwiftData
import XCTest
@testable import MealMap

@MainActor
final class GroceryAndPlanPersistenceTests: XCTestCase {
    private var container: ModelContainer!
    private var context: ModelContext!
    private var plan: PlanViewModel!

    override func setUp() async throws {
        container = try MealMapPersistence.container(inMemory: true)
        context = ModelContext(container)
        plan = PlanViewModel(referenceDate: sampleSunday())
    }

    func testAssignInsertsOneMealPerSlot() throws {
        let assigned = try plan.assign(
            chicken(),
            to: sampleSunday(),
            mealType: .breakfast,
            meals: [],
            in: context,
            replace: false
        )
        XCTAssertTrue(assigned)
        let meals = try context.fetch(FetchDescriptor<PlannedMeal>())
        XCTAssertEqual(meals.count, 1)
        XCTAssertEqual(meals.first?.mealType, .breakfast)
    }

    func testAssignDoesNotOverwriteWithoutReplace() throws {
        _ = try plan.assign(chicken(), to: sampleSunday(), mealType: .dinner, meals: [], in: context, replace: false)
        let existing = try context.fetch(FetchDescriptor<PlannedMeal>())
        let replaced = try plan.assign(
            oatmeal(),
            to: sampleSunday(),
            mealType: .dinner,
            meals: existing,
            in: context,
            replace: false
        )
        XCTAssertFalse(replaced)
        XCTAssertEqual(try context.fetch(FetchDescriptor<PlannedMeal>()).first?.recipeTitle, "Chicken")
    }

    func testReplaceAndRemoveUpdateGroceries() throws {
        _ = try plan.assign(chicken(), to: sampleSunday(), mealType: .lunch, meals: [], in: context, replace: false)
        var meals = try context.fetch(FetchDescriptor<PlannedMeal>())
        _ = try plan.assign(
            oatmeal(),
            to: sampleSunday(),
            mealType: .lunch,
            meals: meals,
            in: context,
            replace: true
        )

        var groceries = try context.fetch(FetchDescriptor<GroceryItem>())
        XCTAssertTrue(groceries.contains { $0.name == "Oats" })
        XCTAssertFalse(groceries.contains { $0.name == "Chicken Breast" })

        meals = try context.fetch(FetchDescriptor<PlannedMeal>())
        try plan.remove(try XCTUnwrap(meals.first), in: context)
        groceries = try context.fetch(FetchDescriptor<GroceryItem>())
        XCTAssertTrue(groceries.isEmpty)
    }

    func testManualGrocerySurvivesMealRemoval() throws {
        _ = try plan.assign(chicken(), to: sampleSunday(), mealType: .snacks, meals: [], in: context, replace: false)
        try GroceryListService.addManual(name: "Bananas", measure: "2", in: context)
        try context.save()

        let meals = try context.fetch(FetchDescriptor<PlannedMeal>())
        try plan.remove(try XCTUnwrap(meals.first), in: context)

        let groceries = try context.fetch(FetchDescriptor<GroceryItem>())
        XCTAssertEqual(groceries.map(\.name), ["Bananas"])
        XCTAssertTrue(try XCTUnwrap(groceries.first).isManual)
    }

    func testEditedGeneratedItemIsKept() throws {
        _ = try plan.assign(chicken(), to: sampleSunday(), mealType: .breakfast, meals: [], in: context, replace: false)
        let item = try XCTUnwrap(try context.fetch(FetchDescriptor<GroceryItem>()).first)
        GroceryListService.update(item, name: "Chicken thighs", measure: "1 lb")
        try context.save()

        let meals = try context.fetch(FetchDescriptor<PlannedMeal>())
        try plan.remove(try XCTUnwrap(meals.first), in: context)

        let groceries = try context.fetch(FetchDescriptor<GroceryItem>())
        XCTAssertEqual(groceries.first?.name, "Chicken thighs")
    }

    private func sampleSunday() -> Date {
        var components = DateComponents()
        components.year = 2026
        components.month = 10
        components.day = 25
        return CalendarWeek.calendar.date(from: components)!
    }

    private func chicken() -> APIMeal {
        APIMeal(
            idMeal: "1",
            strMeal: "Chicken",
            ingredients: [Ingredient(name: "Chicken Breast", measure: "1")]
        )
    }

    private func oatmeal() -> APIMeal {
        APIMeal(
            idMeal: "2",
            strMeal: "Oatmeal",
            ingredients: [Ingredient(name: "Oats", measure: "1 cup")]
        )
    }
}
