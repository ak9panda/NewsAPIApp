//
//  ArticalDetailViewController.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 07/11/2023.
//

import UIKit
import SDWebImage
import SafariServices

class ArticleDetailViewController: UIViewController {

    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var lblArticleTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var tvArticleContents: UITextView! {
        didSet {
            _ = tvArticleContents.layoutManager
            var attributes = [NSAttributedString.Key: Any]()
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            attributes[NSAttributedString.Key.font] = UIFont.preferredFont(forTextStyle: .subheadline)
            tvArticleContents.typingAttributes = attributes
        }
    }
    
    var getArticleDetail: Article?
    fileprivate var webUrl: String?
    
    fileprivate var articleDetail: Article? {
        didSet {
            if let data = articleDetail {
                imgPoster.sd_setImage(with: URL(string: data.urlToImage ?? ""))
                lblArticleTitle.text = data.title
                lblAuthor.text = data.author
                tvArticleContents.text = data.description
                webUrl = data.url
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        self.articleDetail = getArticleDetail
        
        // set the corner radius
        gradientView.layer.cornerRadius = 10.0
        gradientView.clipsToBounds = true
        // set the shadow properties
        gradientView.layer.shadowColor = UIColor.black.cgColor
        gradientView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        gradientView.layer.shadowOpacity = 0.2
        gradientView.layer.shadowRadius = 4.0
        gradientView.layer.masksToBounds = false
    }
    
    @IBAction func onTouchRealMore(_ sender: Any) {
        if let webUrl = URL(string: self.webUrl ?? "") {
            presentSafariViewController(for: webUrl)
        }
    }
}


// MARK: - HELPER FUNCTIONS
extension ArticleDetailViewController {
    fileprivate func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func presentSafariViewController(for url: URL) {
        let safariController = SFSafariViewController(url: url)
        if #available(iOS 10, *) {
            safariController.preferredControlTintColor = .label
        } else {
            safariController.view.tintColor = .label
        }
        safariController.preferredBarTintColor = .white
        safariController.modalPresentationStyle = .overFullScreen

        present(safariController, animated: true, completion: nil)
    }
}
