// PlanViewController.swift
import UIKit

class PlanViewController: UIViewController, MealRecipeSelectionDelegate, DayPlanCellDelegate {

    // MARK: - Properties
    private var mealPlan: [DayPlan] = []
    private let tableView = UITableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupInitialData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Meal Plan"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addCustomRecipe)
        )
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DayPlanCell.self, forCellReuseIdentifier: "DayPlanCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupInitialData() {
        let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        mealPlan = days.map { DayPlan(day: $0) }
    }
    
    // MARK: - Actions
    @objc private func addCustomRecipe() {
        showAlert(title: "Coming Soon", message: "Custom recipe feature will be added in future update")
    }
    
    func addRecipe(_ recipe: APIMeal, to day: String, mealType: MealType) {
        if let dayIndex = mealPlan.firstIndex(where: { $0.day == day }) {
            mealPlan[dayIndex].meals[mealType]?.append(recipe)
            MealPlanDataSource.shared.mealPlan = mealPlan
            tableView.reloadData()
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - DayPlanCellDelegate
    func didTapAddRecipe(for day: String, mealType: MealType) {
        let recipesVC = RecipesViewController()
        recipesVC.recipeSelectionDelegate = self
        recipesVC.selectedDay = day
        recipesVC.selectedMealType = mealType
        recipesVC.isSelectingForMealPlan = true
        
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
            if let navController = tabBarController.viewControllers?[0] as? UINavigationController {
                navController.pushViewController(recipesVC, animated: true)
            }
        }
    }
    
    // MARK: - MealRecipeSelectionDelegate
    func didSelectRecipe(_ recipe: APIMeal, for day: String, mealType: MealType) {
        addRecipe(recipe, to: day, mealType: mealType)
        tabBarController?.selectedIndex = 1
        if let navController = tabBarController?.viewControllers?.first as? UINavigationController {
            navController.popToRootViewController(animated: false)
        }
    }
}

// MARK: - TableView DataSource & Delegate
extension PlanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealPlan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayPlanCell", for: indexPath) as! DayPlanCell
        cell.configure(with: mealPlan[indexPath.row], delegate: self)
        return cell
    }
}
