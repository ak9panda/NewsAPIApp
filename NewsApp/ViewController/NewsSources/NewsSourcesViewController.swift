//
//  NewsSourcesViewController.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 07/11/2023.
//

import UIKit
import RxSwift

final class NewsSourcesViewController: UIViewController {

    @IBOutlet weak var newsSourcesTableView: UITableView!
    
    private var viewModel: NewsSourcesViewModel = NewsSourcesViewModel()
    
    private let selectedSourceSubject = PublishSubject<String>()
    var selectedSource: Observable<String> { selectedSourceSubject.asObserver() }
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupViewModel()
    }
}


//MARK: - HELPER FUNCTIONS
extension NewsSourcesViewController {
    fileprivate func setupView() {
        navigationItem.title = "All Sources"
        
        newsSourcesTableView.dataSource = self
        newsSourcesTableView.delegate = self
        newsSourcesTableView.register(SourceTableViewCell.self, forCellReuseIdentifier: SourceTableViewCell.identifier)
        
        let closeBarBtn = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(onTouchCloseBtn))
        self.navigationItem.rightBarButtonItem = closeBarBtn
    }
    
    fileprivate func setupViewModel() {
        viewModel.updateInfo
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] _ in
                self?.newsSourcesTableView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.errorResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }).disposed(by: disposeBag)
        
        viewModel.isLoading.bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        viewModel.getNewsSources()
    }
    
    @objc func onTouchCloseBtn() {
        self.dismiss(animated: true)
    }
}


// MARK: - TABLEVIEW DATASOURCE AND DELEGATE
extension NewsSourcesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SourceTableViewCell.identifier, for: indexPath) as? SourceTableViewCell else {return UITableViewCell()}
        let data = viewModel.infoForRowAt(indexPath.row)
        cell.configureCell(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = viewModel.infoForRowAt(indexPath.row)
        selectedSourceSubject.onNext(data.id ?? "")
        self.dismiss(animated: true)
    }
}


extension NewsSourcesViewController {
    fileprivate func showAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        self.present(alertView, animated: true)
    }
}
