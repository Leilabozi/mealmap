import UIKit

class RecipeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "RecipeTableViewCell"

    let recipeImageView = UIImageView()
    let titleLabel = UILabel()
    var imageTask: URLSessionDataTask?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.08
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 6

        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.layer.cornerRadius = 10
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recipeImageView)

        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            recipeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            recipeImageView.widthAnchor.constraint(equalToConstant: 64),
            recipeImageView.heightAnchor.constraint(equalToConstant: 64),

            titleLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImageView.image = nil
        titleLabel.text = nil
        imageTask?.cancel()
    }

    func configure(with meal: APIMeal) {
        titleLabel.text = meal.strMeal
        recipeImageView.image = UIImage(systemName: "photo")
        recipeImageView.tintColor = .systemGray4
        if let urlString = meal.strMealThumb, let url = URL(string: urlString) {
            imageTask?.cancel()
            imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self, let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.recipeImageView.image = image
                    self.recipeImageView.tintColor = nil
                }
            }
            imageTask?.resume()
        }
    }
}
