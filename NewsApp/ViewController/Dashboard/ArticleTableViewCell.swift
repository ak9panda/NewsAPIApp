//
//  AtricleTableViewCell.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 06/11/2023.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

final class ArticleTableViewCell: BaseTableViewCell {
    private let imgPoster: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRect.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let lblArticleTitle: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private let calendarIcon: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRect.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        imageView.image = UIImage(named: "icon_calendar")
        return imageView
    }()
    
    private let lblDate: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private let authorIcon: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRect.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        imageView.image = UIImage(named: "icon_pen")
        return imageView
    }()
    
    private let lblAuthor: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    override func prepareView() {
        addSubview(imgPoster)
        addSubview(lblArticleTitle)
        addSubview(calendarIcon)
        addSubview(lblDate)
        addSubview(authorIcon)
        addSubview(lblAuthor)
    }
    
    override func setConstraintsView() {
        imgPoster.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(130)
            make.height.equalTo(100)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        lblArticleTitle.snp.makeConstraints { make in
            make.top.equalTo(imgPoster).offset(5)
            make.left.equalTo(imgPoster.snp_rightMargin).offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        calendarIcon.snp.makeConstraints{ make in
            make.left.equalTo(imgPoster.snp_rightMargin).offset(20)
            make.height.equalTo(14)
            make.width.equalTo(14)
            make.centerY.equalTo(lblDate)
        }
        
        lblDate.snp.makeConstraints{(make) in
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalTo(calendarIcon.snp_rightMargin).offset(10)
        }
        
        authorIcon.snp.makeConstraints { make in
            make.left.equalTo(lblAuthor.snp_rightMargin).offset(10)
            make.height.equalTo(14)
            make.width.equalTo(14)
            make.centerY.equalTo(lblAuthor)
        }
        
        lblAuthor.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalTo(authorIcon.snp_rightMargin).offset(10)
            make.right.equalToSuperview().offset(-20)
        }

    }
    
    func configureCell(data: Article) {
        imgPoster.sd_setImage(with: URL(string: data.urlToImage ?? ""))
        lblArticleTitle.text = data.title
        lblDate.text = data.publishedAt?.components(separatedBy: "T").first ?? ""
        lblAuthor.text = data.author
    }
}
