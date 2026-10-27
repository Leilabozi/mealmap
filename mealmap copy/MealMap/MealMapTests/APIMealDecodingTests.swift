import Foundation
import XCTest
@testable import MealMap

final class APIMealDecodingTests: XCTestCase {
    func testDecodesMealAndIngredientPairs() throws {
        let json = """
        {
          "meals": [
            {
              "idMeal": "52772",
              "strMeal": "Teriyaki Chicken Casserole",
              "strMealThumb": "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg",
              "strInstructions": "Preheat oven to 350.",
              "strArea": "Japanese",
              "strCategory": "Chicken",
              "strIngredient1": "soy sauce",
              "strMeasure1": "3/4 cup",
              "strIngredient2": "water",
              "strMeasure2": "1/2 cup",
              "strIngredient3": "  ",
              "strMeasure3": "1 cup",
              "strIngredient4": null,
              "strMeasure4": null
            }
          ]
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(MealResponse.self, from: json)
        let meal = try XCTUnwrap(response.meals?.first)
        XCTAssertEqual(meal.idMeal, "52772")
        XCTAssertEqual(meal.strMeal, "Teriyaki Chicken Casserole")
        XCTAssertEqual(meal.ingredients.count, 2)
        XCTAssertEqual(meal.ingredients[0].name, "soy sauce")
        XCTAssertEqual(meal.ingredients[0].measure, "3/4 cup")
        XCTAssertEqual(meal.ingredients[1].name, "water")
    }

    func testNullMealsBecomesEmptyList() throws {
        let json = #"{"meals":null}"#.data(using: .utf8)!
        let response = try JSONDecoder().decode(MealResponse.self, from: json)
        XCTAssertNil(response.meals)
    }
}
