import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var planViewController: PlanViewController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Create view controllers
        let planVC = PlanViewController()
        self.planViewController = planVC // Keep reference
        
        let recipesVC = RecipesViewController()
        recipesVC.recipeSelectionDelegate = planVC // Set delegate for recipe selection
        
        let groceriesVC = GroceriesViewController()
        
        // Configure tab items
        recipesVC.tabBarItem = UITabBarItem(
            title: "Recipes",
            image: UIImage(systemName: "book.fill"),
            selectedImage: UIImage(systemName: "book.fill")
        )
        
        planVC.tabBarItem = UITabBarItem(
            title: "Plan",
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar.fill")
        )
        
        groceriesVC.tabBarItem = UITabBarItem(
            title: "Groceries",
            image: UIImage(systemName: "cart.fill"),
            selectedImage: UIImage(systemName: "cart.fill")
        )
        
        // Create tab bar controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: recipesVC),
            UINavigationController(rootViewController: planVC),
            UINavigationController(rootViewController: groceriesVC)
        ]
        
        // Customize appearance
        UITabBar.appearance().tintColor = .systemOrange
        UITabBar.appearance().unselectedItemTintColor = .systemGray
        UINavigationBar.appearance().tintColor = .systemOrange
        
        // Set root controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Save meal plan data here if needed
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Load meal plan data here if needed
    }
}
