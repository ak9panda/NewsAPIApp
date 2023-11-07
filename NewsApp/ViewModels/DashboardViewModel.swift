//
//  DashboardViewModel.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 06/11/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol DashboardViewModelProtocol: AnyObject {
    var numberOfRowsInSection: Int { get }
    
    var updateInfo: Observable<Bool> {get}
    var errorResult: Observable<Error> {get}
    var isLoading: Observable<Bool> {get}
    
    func infoForRowAt(_ index: Int) -> Article
    func updateNews(withCategory category: String)
    func updateNewsWithSource(sourceId: String)
}

final class DashboardViewModel {
    
    private let disposeBag = DisposeBag()
    private let service: NetworkManager
    private var articleList = [Article]()
    
    private let updateInfoSubject = PublishSubject<Bool>()
    private let errorResultSubject = PublishSubject<Error>()
    private let loadingSubject = BehaviorSubject<Bool>(value: true)
    
    init(service: NetworkManager = NetworkManager()) {
        self.service = service
    }
}

extension DashboardViewModel: DashboardViewModelProtocol {
    
    var numberOfRowsInSection: Int { articleList.count }
    
    var updateInfo: Observable<Bool> { updateInfoSubject.asObservable() }
    
    var errorResult: Observable<Error> { errorResultSubject.asObservable() }
    
    var isLoading: Observable<Bool> { loadingSubject.asObservable() }
    
    func infoForRowAt(_ index: Int) -> Article { self.articleList[index] }
    
    func updateNews(withCategory category: String) {
        self.loadingSubject.onNext(true)
        service.fetchHeadline(withCategory: category)
            .observe(on: MainScheduler.instance)
            .subscribe (onSuccess: { [weak self] tasks in
                guard let `self` = self, let tasks = tasks else { return }
                self.articleList = tasks.articles
                self.updateInfoSubject.onNext(true)
                self.loadingSubject.onNext(false)
            }, onFailure: { [weak self] error in
                guard let errorValue = error as? APIError else { return }
                self?.loadingSubject.onNext(false)
                print(errorValue.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func updateNewsWithSource(sourceId: String) {
        self.loadingSubject.onNext(true)
        service.fetchHeadlineWithSource(sourceId: sourceId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] tasks in
                guard let `self` = self, let tasks = tasks else { return }
                self.articleList = tasks.articles
                self.updateInfoSubject.onNext(true)
                self.loadingSubject.onNext(false)
            }, onFailure: { [weak self] error in
                guard let errorValue = error as? APIError else { return }
                self?.loadingSubject.onNext(false)
                print(errorValue.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
