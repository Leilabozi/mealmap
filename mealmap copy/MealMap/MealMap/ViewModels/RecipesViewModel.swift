import Foundation
import SwiftUI

@MainActor
final class RecipesViewModel: ObservableObject {
    enum Status {
        case idle
        case loading
        case results
        case empty
        case error
    }

    @Published private(set) var recipes: [APIMeal] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var searchText = "" {
        didSet {
            if oldValue != searchText {
                scheduleSearch()
            }
        }
    }

    var status: Status {
        if normalizedQuery.isEmpty { return .idle }
        if isLoading { return .loading }
        if errorMessage != nil { return .error }
        if recipes.isEmpty { return .empty }
        return .results
    }

    private var searchTask: Task<Void, Never>?
    private var lastSearchedQuery = ""

    private var normalizedQuery: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func retryLastSearch() {
        let query = lastSearchedQuery.isEmpty ? normalizedQuery : lastSearchedQuery
        guard !query.isEmpty else { return }
        searchTask?.cancel()
        searchTask = Task { await performSearch(query: query) }
    }

    private func scheduleSearch() {
        searchTask?.cancel()

        let query = normalizedQuery
        guard !query.isEmpty else {
            recipes = []
            errorMessage = nil
            isLoading = false
            return
        }

        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            await performSearch(query: query)
        }
    }

    private func performSearch(query: String) async {
        lastSearchedQuery = query
        isLoading = true
        errorMessage = nil

        do {
            let results = try await MealService.shared.searchMeals(named: query)
            guard !Task.isCancelled else { return }
            guard normalizedQuery == query else { return }
            recipes = results
            isLoading = false
        } catch is CancellationError {
            return
        } catch let urlError as URLError where urlError.code == .cancelled {
            return
        } catch {
            guard !Task.isCancelled else { return }
            guard normalizedQuery == query else { return }
            recipes = []
            errorMessage = (error as? RecipeAPIError)?.userMessage
                ?? RecipeAPIError.requestFailed.userMessage
            isLoading = false
        }
    }
}
