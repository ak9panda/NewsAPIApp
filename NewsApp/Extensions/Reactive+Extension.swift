//
//  Reactive+Extension.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 07/11/2023.
//

import RxSwift

extension Reactive where Base: UIViewController {
    
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                LoadingIndicator.shared.show()
            } else {
                LoadingIndicator.shared.hide()
            }
        })
    }
}
