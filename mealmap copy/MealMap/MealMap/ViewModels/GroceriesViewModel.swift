import Foundation
import SwiftData
import SwiftUI

@MainActor
final class GroceriesViewModel: ObservableObject {
    func groupedItems(from items: [GroceryItem]) -> [(category: GroceryCategory, items: [GroceryItem])] {
        GroceryCategory.allCases.compactMap { category in
            let grouped = items
                .filter { $0.category == category }
                .sorted { lhs, rhs in
                    if lhs.isChecked != rhs.isChecked { return !lhs.isChecked }
                    return lhs.displayName.localizedCaseInsensitiveCompare(rhs.displayName) == .orderedAscending
                }
            guard !grouped.isEmpty else { return nil }
            return (category, grouped)
        }
    }

    func toggle(_ item: GroceryItem, in context: ModelContext) throws {
        item.isChecked.toggle()
        try context.save()
    }

    func delete(_ item: GroceryItem, in context: ModelContext) throws {
        context.delete(item)
        try context.save()
    }

    func saveManual(name: String, measure: String, in context: ModelContext) throws {
        try GroceryListService.addManual(name: name, measure: measure, in: context)
        try context.save()
    }

    func update(_ item: GroceryItem, name: String, measure: String, in context: ModelContext) throws {
        GroceryListService.update(item, name: name, measure: measure)
        try context.save()
    }
}
