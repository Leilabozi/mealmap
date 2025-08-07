// MealPlanProtocols.swift
import Foundation

protocol MealRecipeSelectionDelegate: AnyObject {
    func didSelectRecipe(_ recipe: APIMeal, for day: String, mealType: MealType)
}

protocol MealPlanCellDelegate: AnyObject {
    func didTapAddRecipe(for day: String, mealType: MealType)
}

protocol DayPlanCellDelegate: AnyObject {
    func didTapAddRecipe(for day: String, mealType: MealType)
}
