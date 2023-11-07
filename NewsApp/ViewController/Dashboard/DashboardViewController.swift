//
//  ViewController.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 06/11/2023.
//

import UIKit
import RxSwift

final class DashboardViewController: UIViewController {
    
    @IBOutlet weak var articleListTableView: UITableView!
    
    private var viewModel: DashboardViewModelProtocol = DashboardViewModel()
    private let disposeBag = DisposeBag()
    
    var currentCategory: String = "All"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.primaryColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - HELPER FUNCTIONS
extension DashboardViewController {
    fileprivate func setupView() {
        navigationItem.title = "Today News"
        
        articleListTableView.dataSource = self
        articleListTableView.delegate = self
        articleListTableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        
        let btnCategory = UIButton()
        btnCategory.setImage(UIImage(named: "icon_category"), for: .normal)
        btnCategory.tintColor = .white
        btnCategory.addTarget(self, action: #selector(onTouchCategoryBtn), for: .touchUpInside)
        let categoryBarBtn = UIBarButtonItem(customView: btnCategory)
        categoryBarBtn.customView?.translatesAutoresizingMaskIntoConstraints = false
        categoryBarBtn.customView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        categoryBarBtn.customView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.navigationItem.setLeftBarButton(categoryBarBtn, animated: true)
        
        let btnSources = UIButton()
        btnSources.setImage(UIImage(named: "icon_source"), for: .normal)
        btnSources.tintColor = .white
        btnSources.addTarget(self, action: #selector(onTouchSourcesBtn), for: .touchUpInside)
        let sourcesBarBtn = UIBarButtonItem(customView: btnSources)
        sourcesBarBtn.customView?.translatesAutoresizingMaskIntoConstraints = false
        sourcesBarBtn.customView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        sourcesBarBtn.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.navigationItem.setRightBarButton(sourcesBarBtn, animated: true)
    }
    
    fileprivate func setupViewModel() {
        viewModel.updateInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                self?.articleListTableView.reloadData()
            }).disposed(by: disposeBag)

        viewModel.errorResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }).disposed(by: disposeBag)
        
        viewModel.isLoading.bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        viewModel.updateNews(withCategory: "")
    }
    
    @objc func onTouchCategoryBtn() {
         showCategories()
    }
    
    @objc func onTouchSourcesBtn() {
        showNewsSources()
    }
}


//MARK: TABLEVIEW DATASOURCE AND DELEGATES
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as? ArticleTableViewCell else { return UITableViewCell()}
        let data = viewModel.infoForRowAt(indexPath.row)
        cell.configureCell(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = viewModel.infoForRowAt(indexPath.row)
        gotoDetailPage(article: data)
    }
}


extension DashboardViewController {
    fileprivate func showAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        self.present(alertView, animated: true)
    }
    
    fileprivate func gotoDetailPage(article: Article) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleDetailViewController") as! ArticleDetailViewController
        detailVC.getArticleDetail = article
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    fileprivate func showCategories() {
        let navigationVC = UINavigationController()
        let categoriesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleCategoriesViewController") as! ArticleCategoriesViewController
        categoriesVC.lastSelectedCategory = currentCategory
        navigationVC.viewControllers = [categoriesVC]
        self.present(navigationVC, animated: true)
        
        categoriesVC.selectedCategories
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] categoryName in
                self?.currentCategory = categoryName
                let category = categoryName == "All" ? "" : categoryName
                self?.viewModel.updateNews(withCategory: category)
            }.disposed(by: disposeBag)
    }
    
    fileprivate func showNewsSources() {
        let navigationVC = UINavigationController()
        let categoriesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsSourcesViewController") as! NewsSourcesViewController
        navigationVC.viewControllers = [categoriesVC]
        self.present(navigationVC, animated: true)
        
        categoriesVC.selectedSource
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] sourceId in
                self?.viewModel.updateNewsWithSource(sourceId: sourceId)
            }.disposed(by: disposeBag)
    }
}
