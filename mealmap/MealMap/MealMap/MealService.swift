import Foundation

class MealService {
    static let shared = MealService()
    private let baseURL = "https://www.themealdb.com/api/json/v1/1/"
    private let urlSession = URLSession.shared
    private let jsonDecoder = JSONDecoder()
    
    func fetchAllRecipes(completion: @escaping (Result<[APIMeal], Error>) -> Void) {
        let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i"] // First 7 letters for demo
        var allRecipes = [APIMeal]()
        let dispatchGroup = DispatchGroup()
        var lastError: Error?
        
        for (index, letter) in letters.enumerated() {
            dispatchGroup.enter()
            
            // Add delay to prevent rate limiting
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(index * 300)) {
                self.fetchRecipes(startingWith: letter) { result in
                    defer { dispatchGroup.leave() }
                    
                    switch result {
                    case .success(let recipes):
                        allRecipes.append(contentsOf: recipes)
                    case .failure(let error):
                        lastError = error
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if allRecipes.isEmpty, let error = lastError {
                completion(.failure(error))
            } else {
                // Remove duplicates while preserving order
                let uniqueRecipes = allRecipes.reduce(into: [APIMeal]()) { result, meal in
                    if !result.contains(where: { $0.idMeal == meal.idMeal }) {
                        result.append(meal)
                    }
                }
                completion(.success(uniqueRecipes))
            }
        }
    }
    
    private func fetchRecipes(startingWith letter: String, completion: @escaping (Result<[APIMeal], Error>) -> Void) {
        let endpoint = "search.php?f=\(letter)"
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let response = try self.jsonDecoder.decode(MealResponse.self, from: data)
                completion(.success(response.meals))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
        case rateLimited
    }
}
