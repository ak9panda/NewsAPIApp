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
        setBackgroundGradient()
        
        self.articleDetail = getArticleDetail
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
    
    fileprivate func setBackgroundGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 100)

        self.gradientView.layer.insertSublayer(gradient, at: 0)
    }
}
