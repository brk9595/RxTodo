//
//  AddTaskViewController.swift
//  RxTodoList
//
//  Created by Bharath Raj Kumar B on 26/10/20.
//

import UIKit
import TinyConstraints
import RxSwift
import RxCocoa

class AddTaskViewController: UIViewController {
    
    private let taskSubject = PublishSubject<Task>()
    var taskSubjectObservable: Observable<Task>  {
        return taskSubject.asObserver()
    }
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["High","Medium","Low"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.sendActions(for: .valueChanged)
        return segmentedControl
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add the task"
        textField.borderStyle = .roundedRect
        return textField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = "Add task"
        setupTextField()
        setupSegmentedControl()
        setupNavBar()
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addtask))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    func setupTextField() {
        view.addSubview(textField)
        textField.height(46)
        textField.center(in: view)
        textField.leading(to: view).constant = 16
        textField.trailing(to: view).constant = -16
    }
    
    func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.bottomToTop(of: textField).constant = -20
        segmentedControl.trailing(to: view).constant = -32
        segmentedControl.leading(to: view).constant = 32
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
    }
    
    @objc func segmentedValueChanged() {
        
    }
    
    @objc func addtask() {
        guard let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex), let title = self.textField.text else { return }
        
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        self.dismiss(animated: true, completion: nil)
    }
    
}
