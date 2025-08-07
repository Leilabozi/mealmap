// Models.swift
import Foundation

enum MealType: String, CaseIterable, Codable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case snack = "Snack"
    case dinner = "Dinner"
}

struct DayPlan: Codable {
    let day: String
    var meals: [MealType: [APIMeal]]
    
    init(day: String) {
        self.day = day
        self.meals = [
            .breakfast: [],
            .lunch: [],
            .snack: [],
            .dinner: []
        ]
    }
}
