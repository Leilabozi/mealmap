import UIKit

class DayPlanCell: UITableViewCell {
    static let identifier = "DayPlanCell"
    
    weak var delegate: DayPlanCellDelegate?
    private var dayPlan: DayPlan?
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        contentView.addSubview(dayLabel)
        contentView.addSubview(stackView)
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with dayPlan: DayPlan, delegate: DayPlanCellDelegate?) {
        self.dayPlan = dayPlan
        self.delegate = delegate
        dayLabel.text = dayPlan.day
        
        // Clear previous views
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add meal type sections
        for mealType in MealType.allCases {
            addMealSection(for: mealType, recipes: dayPlan.meals[mealType] ?? [])
        }
    }
    
    private func addMealSection(for mealType: MealType, recipes: [APIMeal]) {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.text = mealType.rawValue
        
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 8
        
        let mealStack = UIStackView()
        mealStack.axis = .vertical
        mealStack.spacing = 8
        
        container.addSubview(mealStack)
        mealStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            mealStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            mealStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            mealStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
        
        mealStack.addArrangedSubview(titleLabel)
        
        if recipes.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No recipes added"
            emptyLabel.font = UIFont.systemFont(ofSize: 14)
            emptyLabel.textColor = .secondaryLabel
            mealStack.addArrangedSubview(emptyLabel)
        } else {
            for recipe in recipes {
                let recipeView = RecipePlanView(recipe: recipe)
                mealStack.addArrangedSubview(recipeView)
            }
        }
        
        let addButton = UIButton(type: .system)
        addButton.setTitle("+ Add Recipe", for: .normal)
        addButton.addTarget(self, action: #selector(addRecipeTapped(_:)), for: .touchUpInside)
        addButton.tag = mealType.rawValue.hashValue
        mealStack.addArrangedSubview(addButton)
        
        stackView.addArrangedSubview(container)
    }
    
    @objc private func addRecipeTapped(_ sender: UIButton) {
        guard let dayPlan = dayPlan else { return }
        let mealType = MealType.allCases.first(where: { $0.rawValue.hashValue == sender.tag }) ?? .breakfast
        delegate?.didTapAddRecipe(for: dayPlan.day, mealType: mealType)
    }
}

class RecipePlanView: UIView {
    private var recipe: APIMeal

    init(recipe: APIMeal) {
        self.recipe = recipe
        super.init(frame: .zero)
        setupView(with: recipe)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(with recipe: APIMeal) {
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 6

        let titleLabel = UILabel()
        titleLabel.text = recipe.strMeal
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
