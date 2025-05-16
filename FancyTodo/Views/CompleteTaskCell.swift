import UIKit

class CompleteTaskCell: UITableViewCell {
    private let checkbox: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = .primaryText
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.cellTitle
        label.textColor = AppColors.cellTitle
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupActions()
    }
    
    var checkboxTapped: (() -> Void)?
    
    private func setupUI() {
        contentView.addSubview(checkbox)
        contentView.addSubview(titleLabel)
        
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkbox.widthAnchor.constraint(equalToConstant: 24),
            checkbox.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    private func setupActions() {
        checkbox.addTarget(self, action: #selector(handleCheckboxTap), for: .touchUpInside)
    }
    
    @objc private func handleCheckboxTap() {
        checkboxTapped?()
    }
    
    func configure(title: String, isChecked: Bool, checkboxTapped: @escaping () -> Void) {
        titleLabel.text = title
        let imageName = isChecked ? "checkmark.square" : "square"
        checkbox.setImage(UIImage(systemName: imageName), for: .normal)
        self.checkboxTapped = checkboxTapped
    }
}

