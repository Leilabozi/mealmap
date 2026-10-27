import Foundation

struct MealResponse: Codable {
    let meals: [APIMeal]? // API returns null when no results
}

struct APIMeal: Codable, Hashable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String?
    let strInstructions: String?
    let strArea: String?
    let strCategory: String?
    var ingredients: [Ingredient] = []

    init(
        idMeal: String,
        strMeal: String,
        strMealThumb: String? = nil,
        strInstructions: String? = nil,
        strArea: String? = nil,
        strCategory: String? = nil,
        ingredients: [Ingredient] = []
    ) {
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strMealThumb = strMealThumb
        self.strInstructions = strInstructions
        self.strArea = strArea
        self.strCategory = strCategory
        self.ingredients = ingredients
    }
    
    private enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strMealThumb, strInstructions, strArea, strCategory
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        strArea = try container.decodeIfPresent(String.self, forKey: .strArea)
        strCategory = try container.decodeIfPresent(String.self, forKey: .strCategory)
        
        // Handle dynamic ingredient keys (1-20)
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKey.self)
        for i in 1...20 {
            guard let ingredientKey = DynamicCodingKey(stringValue: "strIngredient\(i)"),
                  let measureKey = DynamicCodingKey(stringValue: "strMeasure\(i)") else {
                continue
            }
            let rawName = try dynamicContainer.decodeIfPresent(String.self, forKey: ingredientKey) ?? ""
            let name = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !name.isEmpty else { continue }
            let measure = (try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey) ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            ingredients.append(Ingredient(name: name, measure: measure))
        }
    }
    
    private struct DynamicCodingKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) { self.stringValue = stringValue }
        var intValue: Int? { nil }
        init?(intValue: Int) { nil }
    }
    
    var id: String { idMeal }

    static func == (lhs: APIMeal, rhs: APIMeal) -> Bool {
        lhs.idMeal == rhs.idMeal
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(idMeal)
    }
}

struct Ingredient: Codable, Hashable {
    let name: String
    let measure: String
}
