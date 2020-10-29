//
//  ViewController.swift
//  RxTodoList
//
//  Created by Bharath Raj Kumar B on 26/10/20.
//

import UIKit
import TinyConstraints
import RxSwift
import RxCocoa
class ViewController: UIViewController {
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["All","High","Medium","Low"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.sendActions(for: .valueChanged)
        return segmentedControl
    }()
    private let tableView = UITableView()
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupNavBar()
        setupSegmentedControl()
        setupTableView()
        
//        tasks.asObservable().
    }
    
    func setupNavBar() {
        self.title = "RxToDo"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addtask))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    
    func setupSegmentedControl() {
        self.navigationItem.titleView = segmentedControl
        segmentedControl.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
       
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.edgesToSuperview()
    }
    
    @objc func addtask() {
        let addTaskViewControllerNav = UINavigationController(rootViewController: AddTaskViewController())
        addTaskViewControllerNav.modalPresentationStyle = .pageSheet
        self.present(addTaskViewControllerNav, animated: true, completion: nil)
        
        let taskVC = addTaskViewControllerNav.viewControllers.first as! AddTaskViewController
        taskVC.taskSubjectObservable.subscribe(onNext: {
            [unowned self] task in
            
            let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex - 1)
            
            var existingtasks = self.tasks.value
            existingtasks.append(task)
            self.tasks.accept(existingtasks)
            self.filterTasks(filterBy: priority)
        }).disposed(by: disposebag)
        
    }
    
    private func filterTasks(filterBy priority: Priority?) {
        if priority == nil {
            self.filteredTasks = self.tasks.value
            self.updateTableview()
        } else {
            self.tasks.map { task in
                return task.filter { $0.priority == priority}
            }.subscribe(onNext: {
                [weak self] tasks in
                self?.filteredTasks = tasks
                print(self?.filteredTasks)
                self?.updateTableview()
            }).disposed(by: disposebag)
        }
    }
    
    @objc func segmentControlValueChanged() {
        let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex - 1)
        filterTasks(filterBy: priority)
    }
    
    func updateTableview() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        return cell
    }
    
    
}
