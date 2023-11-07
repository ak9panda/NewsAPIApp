//
//  ArticleCategoriesViewController.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 07/11/2023.
//

import UIKit
import RxSwift

class ArticleCategoriesViewController: UIViewController {

    @IBOutlet weak var articleCategoriesTableView: UITableView!
    
    fileprivate var categories: [String] = ["All", "Business", "Entertainment", "Health", "Science", "Sports", "Technology"]
    
    private let selectedCategoriesSubject = PublishSubject<String>()
    var selectedCategories: Observable<String> { selectedCategoriesSubject.asObserver() }
    private let disposeBag = DisposeBag()
    
    var lastSelectedCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}


// MARK: - HELPER FUCNCTIONS
extension ArticleCategoriesViewController {
    fileprivate func setupView() {
        navigationItem.title = "Categories"
        
        articleCategoriesTableView.dataSource = self
        articleCategoriesTableView.delegate = self
        
        let closeBarBtn = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(onTouchCloseBtn))
        self.navigationItem.rightBarButtonItem = closeBarBtn
        
        articleCategoriesTableView.register(CategoryTableViewCell.nib, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        articleCategoriesTableView.reloadData()
    }
    
    @objc func onTouchCloseBtn() {
        self.dismiss(animated: true)
    }
}


// MARK: - TABLEVIEW DATASOURCE AND DELEGATE
extension ArticleCategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let categoryCell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) as? CategoryTableViewCell else {return UITableViewCell()}
        categoryCell.categoryName = categories[indexPath.row]
        categoryCell.accessoryType = lastSelectedCategory == categories[indexPath.row] ? .checkmark : .none
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedCategoriesSubject.onNext(categories[indexPath.row])
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
