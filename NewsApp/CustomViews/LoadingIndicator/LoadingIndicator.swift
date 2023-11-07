//
//  LoadingIndicator.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 07/11/2023.
//

import UIKit

class LoadingIndicator: UIView {

    @IBOutlet var parientView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    static let shared = LoadingIndicator()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("LoadingIndicator", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        // Get main screen bounds
        indicator.color = .white
        
//        // Get main screen bounds
//        let screenSize: CGRect = UIScreen.main.bounds
//        parientView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
//        parientView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func show(vc: UIViewController) {
        indicator.startAnimating()
        
        vc.view.addSubview(parientView)
        parientView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
        
//        if #available(iOS 13, *) {
//            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//            keyWindow?.addSubview(parientView)
//        } else {
//            let keyWindow = UIApplication.shared.keyWindow
//            keyWindow?.addSubview(parientView)
//        }
    }
    
    func hide() {
        indicator.stopAnimating()
        parientView.removeFromSuperview()
    }
}
