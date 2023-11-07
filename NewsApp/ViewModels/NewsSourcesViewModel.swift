//
//  NewsSourcesViewModel.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 07/11/2023.
//

import Foundation
import RxSwift

protocol NewsSourcesViewModelProtocol: AnyObject {
    var numberOfRowsInSection: Int { get }
    
    var updateInfo: Observable<Bool> {get}
    var errorResult: Observable<Error> {get}
    var isLoading: Observable<Bool> {get}
    
    func infoForRowAt(_ index: Int) -> SourceResponse
}


final class NewsSourcesViewModel {
    
    private let disposeBag = DisposeBag()
    private let service: NetworkManager
    private var sourceList = [SourceResponse]()
    
    private let updateInfoSubject = PublishSubject<Bool>()
    private let errorResultSubject = PublishSubject<Error>()
    private let loadingSubject = BehaviorSubject<Bool>(value: true)
    
    init(service: NetworkManager = NetworkManager()) {
        self.service = service
    }
}


extension NewsSourcesViewModel: NewsSourcesViewModelProtocol {
    var numberOfRowsInSection: Int { sourceList.count }
    
    var updateInfo: RxSwift.Observable<Bool> { updateInfoSubject.asObservable() }
    
    var errorResult: RxSwift.Observable<Error> { errorResultSubject.asObservable() }
    
    var isLoading: RxSwift.Observable<Bool> { loadingSubject.asObservable() }
    
    func infoForRowAt(_ index: Int) -> SourceResponse { self.sourceList[index] }
    
    func getNewsSources() {
        self.loadingSubject.onNext(true)
        service.fetchNewsSources()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] tasks in
                guard let `self` = self, let tasks = tasks else { return }
                self.sourceList = tasks.sources ?? []
                self.updateInfoSubject.onNext(true)
                self.loadingSubject.onNext(false)
            }, onFailure: { [weak self] error in
                guard let errorValue = error as? APIError else { return }
                self?.loadingSubject.onNext(false)
                print(errorValue.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
