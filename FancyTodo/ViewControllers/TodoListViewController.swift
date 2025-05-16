import UIKit

class TodoListViewController: UIViewController {
    private var tasks: [Task] = [
        Task(title: "Hello", isCompleted: false),
        Task(title: "Hello1", isCompleted: false),
        Task(title: "Hello2", isCompleted: false),
        Task(title: "Hello3", isCompleted: false),
        Task(title: "Hello4", isCompleted: false),
        Task(title: "Hello5", isCompleted: false)
    ]
    
    private var incompletedTasks: [Task] { tasks.filter({ !$0.isCompleted }) }
    private var completedTasks: [Task] { tasks.filter({ $0.isCompleted }) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupUI()
        setupData()
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
    
    private let horizontalLine: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.statusText?.withAlphaComponent(0.2)
        return view
    }()
    
    private func createTableHeaderView(title: String) -> UIView {
        let headerLabel = UILabel()
        headerLabel.text = title
        headerLabel.textAlignment = .left
        headerLabel.backgroundColor = .clear
        headerLabel.font = AppFonts.headerTitle
        headerLabel.textColor = AppColors.statusText
        headerLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        return headerLabel
    }
    
    private let incompleteTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IncompleteTaskCell.self, forCellReuseIdentifier: "IncompleteTaskCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let completeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CompleteTaskCell.self, forCellReuseIdentifier: "CompleteTaskCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let floatingActionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        return button
    }()
    
    private func setupUI() {
        incompleteTableView.delegate = self
        completeTableView.delegate = self
        incompleteTableView.dataSource = self
        completeTableView.dataSource = self
        
        incompleteTableView.tableHeaderView = createTableHeaderView(title: "Incomplete")
        completeTableView.tableHeaderView = createTableHeaderView(title: "Completed")
        
        view.addSubview(titleLabel)
        view.addSubview(statusLabel)
        view.addSubview(horizontalLine)
        view.addSubview(incompleteTableView)
        view.addSubview(completeTableView)
        view.addSubview(floatingActionButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        incompleteTableView.translatesAutoresizingMaskIntoConstraints = false
        completeTableView.translatesAutoresizingMaskIntoConstraints = false
        floatingActionButton.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32.0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16.0),
            
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.0),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16.0),
            
            horizontalLine.heightAnchor.constraint(equalToConstant: 2.0),
            horizontalLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            horizontalLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            horizontalLine.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16),
            
            incompleteTableView.topAnchor.constraint(equalTo: horizontalLine.bottomAnchor, constant: 16),
            incompleteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            incompleteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            incompleteTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
            
            completeTableView.topAnchor.constraint(equalTo: incompleteTableView.bottomAnchor, constant: 32),
            completeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            completeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            floatingActionButton.widthAnchor.constraint(equalToConstant: 60),
            floatingActionButton.heightAnchor.constraint(equalToConstant: 60),
            floatingActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            floatingActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupData() {
        updateStatus()
        DispatchQueue.main.async {
            self.adjustTableScrolling()
        }
    }
    
    private func updateStatus() {
        statusLabel.text = "\(incompletedTasks.count) incomplete, \(completedTasks.count) completed"
    }
    
    private func adjustTableScrolling() {
        incompleteTableView.isScrollEnabled = incompleteTableView.contentSize.height > incompleteTableView.frame.height
        completeTableView.isScrollEnabled = completeTableView.contentSize.height > completeTableView.frame.height
    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == incompleteTableView {
            return incompletedTasks.count
        } else if tableView == completeTableView {
            return completedTasks.count
        }
        return 0
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isIncompleteTable = tableView == incompleteTableView
        let cellIdentifier = isIncompleteTable ? "IncompleteTaskCell" : "CompleteTaskCell"
        let taskArray = isIncompleteTable ? incompletedTasks : completedTasks
        let task = taskArray[indexPath.row]
            
        if isIncompleteTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? IncompleteTaskCell else {
                return UITableViewCell()
            }
            cell.configure(title: task.title, isChecked: task.isCompleted, checkboxTapped: {
                self.toggleTaskCompletion(with: task.id)
            })
            cell.backgroundColor = .clear
            cell.separatorInset = .zero
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CompleteTaskCell else {
                return UITableViewCell()
            }
            cell.configure(title: task.title, isChecked: task.isCompleted, checkboxTapped: {
                self.toggleTaskCompletion(with: task.id)
            })
            cell.backgroundColor = .clear
            cell.separatorInset = .zero
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskArray = tableView == incompleteTableView ? incompletedTasks : completedTasks
        let task = taskArray[indexPath.row]
        toggleTaskCompletion(with: task.id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskArray = tableView == incompleteTableView ? incompletedTasks : completedTasks
            let taskToDelete = taskArray[indexPath.row]
            
            if let indexInMainArray = tasks.firstIndex(where: { $0.id == taskToDelete.id }) {
                tasks.remove(at: indexInMainArray)
                tableView.deleteRows(at: [indexPath], with: .fade)
                updateStatus()
                adjustTableScrolling()
            }
        }
    }
    
    private func toggleTaskCompletion(with id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            var task = tasks[index]
            task.toggleCompletion()
            tasks[index] = task
            
            incompleteTableView.reloadData()
            completeTableView.reloadData()
            updateStatus()
            adjustTableScrolling()
        }
    }
}
