import UIKit

class TodoListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupUI()
//        for family in UIFont.familyNames {
//            for name in UIFont.fontNames(forFamilyName: family) {
//                print(name)
//            }
//        }
    }
    
    private let titleLabel = {
        let uiLabel = UILabel()
        uiLabel.font = AppFonts.title
        uiLabel.text = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            dateFormatter.locale = Locale.current
            return dateFormatter.string(from: Date())
        }()
        uiLabel.textColor = AppColors.primaryText
        return uiLabel
    }()
    
    private let statusLabel = {
        let uiLabel = UILabel()
        uiLabel.font = AppFonts.status
        uiLabel.text = "0 incomplete, 0 completed"
        uiLabel.textColor = AppColors.statusText
        return uiLabel
    }()
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(statusLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32.0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16.0),
            
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.0),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16.0),
        ])
    }
}

