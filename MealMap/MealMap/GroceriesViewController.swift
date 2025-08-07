import UIKit

enum GroceryCategory: String, CaseIterable {
    case produce = "Produce"
    case dairy = "Dairy"
    case meat = "Meat"
    case pantry = "Pantry"
    case other = "Other"
}

func categorize(ingredient: String) -> GroceryCategory {
    let lower = ingredient.lowercased()
    if lower.contains("egg") || lower.contains("milk") || lower.contains("cheese") { return .dairy }
    if lower.contains("chicken") || lower.contains("beef") || lower.contains("pork") { return .meat }
    if lower.contains("lettuce") || lower.contains("tomato") || lower.contains("onion") || lower.contains("carrot") || lower.contains("apple") { return .produce }
    if lower.contains("flour") || lower.contains("sugar") || lower.contains("oil") || lower.contains("rice") { return .pantry }
    return .other
}

class MealPlanDataSource {
    static let shared = MealPlanDataSource()
    var mealPlan: [DayPlan] = []
}

class GroceriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var tableView: UITableView!
    private var groceriesByCategory: [GroceryCategory: [String]] = [:]
    private var checkedItems = Set<String>()
    private var categories: [GroceryCategory] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Groceries"
        setupTableView()
        loadGroceries()
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GroceryCell")
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadGroceries() {
        let mealPlan = MealPlanDataSource.shared.mealPlan
        var categoryDict: [GroceryCategory: Set<String>] = [:]
        for day in mealPlan {
            for mealList in day.meals.values {
                for recipe in mealList {
                    for ingredient in recipe.ingredients {
                        let display = ingredient.measure.isEmpty ? ingredient.name : "\(ingredient.measure) \(ingredient.name)"
                        let category = categorize(ingredient: ingredient.name)
                        if categoryDict[category] == nil { categoryDict[category] = [] }
                        categoryDict[category]?.insert(display)
                    }
                }
            }
        }
        // Convert sets to sorted arrays
        groceriesByCategory = categoryDict.mapValues { Array($0).sorted() }
        categories = GroceryCategory.allCases.filter { groceriesByCategory[$0]?.isEmpty == false }
        tableView.reloadData()
    }

    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = categories[section]
        return groceriesByCategory[category]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].rawValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.section]
        let item = groceriesByCategory[category]?[indexPath.row] ?? ""
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryCell", for: indexPath)
        cell.textLabel?.text = item
        cell.accessoryType = checkedItems.contains(item) ? .checkmark : .none
        return cell
    }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.section]
        let item = groceriesByCategory[category]?[indexPath.row] ?? ""
        if checkedItems.contains(item) {
            checkedItems.remove(item)
        } else {
            checkedItems.insert(item)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
