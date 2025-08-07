import UIKit

class RecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    weak var recipeSelectionDelegate: MealRecipeSelectionDelegate?
    var isSelectingForMealPlan = false
    var selectedDay: String?
    var selectedMealType: MealType?
    var dayIndex: Int = 0

    var tableView: UITableView!
    var searchBar: UISearchBar!
    var recipes: [APIMeal] = []
    var filteredRecipes: [APIMeal] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchRecipes()
    }

    func setupUI() {
        view.backgroundColor = .systemBackground
        searchBar = UISearchBar()
        searchBar.placeholder = "Search recipes..."
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: RecipeTableViewCell.reuseIdentifier)
        tableView.rowHeight = 90
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func fetchRecipes() {
        MealService.shared.fetchAllRecipes { [weak self] result in
            switch result {
            case .success(let meals):
                self?.recipes = meals
                self?.filteredRecipes = meals
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching meals: \(error)")
            }
        }
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.reuseIdentifier, for: indexPath) as! RecipeTableViewCell
        let meal = filteredRecipes[indexPath.row]
        cell.configure(with: meal)
        return cell
    }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = filteredRecipes[indexPath.row]
        if isSelectingForMealPlan {
            recipeSelectionDelegate?.didSelectRecipe(selectedRecipe, for: selectedDay ?? "", mealType: selectedMealType ?? .breakfast)
            navigationController?.popViewController(animated: true)
        } else {
            let detailVC = RecipeDetailViewController(recipe: selectedRecipe)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    // MARK: - Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredRecipes = recipes
        } else {
            filteredRecipes = recipes.filter { $0.strMeal.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

