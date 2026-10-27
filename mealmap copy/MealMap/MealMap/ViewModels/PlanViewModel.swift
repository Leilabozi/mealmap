import Foundation
import SwiftData
import SwiftUI

@MainActor
final class PlanViewModel: ObservableObject {
    @Published var selectedWeekStart: Date
    @Published var selectedDate: Date

    init(referenceDate: Date = .now) {
        let weekStart = CalendarWeek.startOfWeek(containing: referenceDate)
        selectedWeekStart = weekStart
        selectedDate = CalendarWeek.startOfDay(referenceDate)
        if !CalendarWeek.days(inWeekContaining: weekStart).contains(where: {
            CalendarWeek.isSameDay($0, referenceDate)
        }) {
            selectedDate = weekStart
        }
    }

    var weekDates: [Date] {
        CalendarWeek.days(inWeekContaining: selectedWeekStart)
    }

    func goToPreviousWeek() {
        shiftWeek(by: -1)
    }

    func goToNextWeek() {
        shiftWeek(by: 1)
    }

    func select(date: Date) {
        selectedDate = CalendarWeek.startOfDay(date)
        selectedWeekStart = CalendarWeek.startOfWeek(containing: date)
    }

    func meal(_ meals: [PlannedMeal], on date: Date, type: MealType) -> PlannedMeal? {
        meals.first { planned in
            CalendarWeek.isSameDay(planned.date, date) && planned.mealType == type
        }
    }

    @discardableResult
    func assign(
        _ recipe: APIMeal,
        to date: Date,
        mealType: MealType,
        meals: [PlannedMeal],
        in context: ModelContext,
        replace: Bool
    ) throws -> Bool {
        if let existing = meal(meals, on: date, type: mealType) {
            if !replace {
                return false
            }
            try GroceryListService.removeSources(for: existing.mealID, in: context)
            context.delete(existing)
        }

        let planned = PlannedMeal(date: date, mealType: mealType, recipe: recipe)
        context.insert(planned)
        try GroceryListService.addIngredients(from: planned, in: context)
        try context.save()
        return true
    }

    func remove(_ plannedMeal: PlannedMeal, in context: ModelContext) throws {
        try GroceryListService.removeSources(for: plannedMeal.mealID, in: context)
        context.delete(plannedMeal)
        try context.save()
    }

    private func shiftWeek(by weeks: Int) {
        let index = CalendarWeek.weekdayIndex(of: selectedDate, inWeekStarting: selectedWeekStart)
        selectedWeekStart = CalendarWeek.addingWeeks(weeks, to: selectedWeekStart)
        let days = CalendarWeek.days(inWeekContaining: selectedWeekStart)
        selectedDate = days[index]
    }
}
