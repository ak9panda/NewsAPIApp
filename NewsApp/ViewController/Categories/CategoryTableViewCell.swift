//
//  CategoryTableViewCell.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 07/11/2023.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCategoryTitle: UILabel!
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    var categoryName: String? {
        didSet {
            if let name = categoryName {
                lblCategoryTitle.text = name
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
