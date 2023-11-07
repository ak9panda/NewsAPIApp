//
//  SourceTableViewCell.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 07/11/2023.
//

import UIKit
import SnapKit

final class SourceTableViewCell: BaseTableViewCell {
    
    private let lblSourceTitle: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private let lblSourceDetail: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    override func prepareView() {
        addSubview(lblSourceTitle)
        addSubview(lblSourceDetail)
    }
    
    override func setConstraintsView() {
        lblSourceTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        lblSourceDetail.snp.makeConstraints { make in
            make.top.equalTo(lblSourceTitle.snp_bottomMargin).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configureCell(data: SourceResponse) {
        lblSourceTitle.text = data.name
        lblSourceDetail.text = data.description
    }
}
