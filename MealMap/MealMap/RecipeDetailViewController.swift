import UIKit

class RecipeDetailViewController: UIViewController {
    let recipe: APIMeal
    let scrollView = UIScrollView()
    let contentView = UIView()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let ingredientsLabel = UILabel()
    let instructionsLabel = UILabel()

    init(recipe: APIMeal) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        configure()
    }

    func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        ingredientsLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        ingredientsLabel.textColor = .label
        ingredientsLabel.numberOfLines = 0
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ingredientsLabel)

        instructionsLabel.font = UIFont.systemFont(ofSize: 16)
        instructionsLabel.textColor = .secondaryLabel
        instructionsLabel.numberOfLines = 0
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(instructionsLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 220),
            imageView.heightAnchor.constraint(equalToConstant: 220),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            ingredientsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ingredientsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            instructionsLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 24),
            instructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            instructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            instructionsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    func configure() {
        titleLabel.text = recipe.strMeal
        if let urlString = recipe.strMealThumb, let url = URL(string: urlString) {
            imageView.image = UIImage(systemName: "photo")
            imageView.tintColor = .systemGray4
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self, let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.imageView.tintColor = nil
                }
            }.resume()
        }
        // Ingredients
        let ingredientsText = recipe.ingredients.map { "• \($0.name) \($0.measure)" }.joined(separator: "\n")
        ingredientsLabel.text = "Ingredients:\n" + ingredientsText
        // Instructions
        instructionsLabel.text = "Instructions:\n" + (recipe.strInstructions ?? "")
    }
}
