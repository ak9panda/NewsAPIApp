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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupViewModel()
    }
}

// MARK: - HELPER FUNCTIONS
extension DashboardViewController {
    fileprivate func setupView() {
        navigationItem.title = "Today News"
        
        articleListTableView.dataSource = self
        articleListTableView.delegate = self
        articleListTableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
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
        
        viewModel.updateNews(withCategory: "")
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
        
    }
}


extension DashboardViewController {
    fileprivate func showAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        self.present(alertView, animated: true)
    }
}
