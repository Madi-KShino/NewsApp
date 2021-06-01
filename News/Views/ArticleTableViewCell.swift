//
//  ArticleTableViewCell.swift
//  News
//
//  Created by Madison Shino on 6/1/21.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    //MARK: Outlets
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var cellStackView: UIStackView!
    
    //MARK: Properties
    
    var article: Article? {
        didSet {
            if article != nil {
                articleImageView.layer.cornerRadius = 10
                cellStackView.layer.cornerRadius = 10
                if article!.imageURL != nil {
                    ArticleController.sharedInstance.fetchImageForArticle(article!) { (image, error) in
                        if let image = image {
                            DispatchQueue.main.async {
                                self.articleImageView.image = image
                            }
                        }
                    }
                }
                titleLabel.text = article?.title
                summaryLabel.text = article?.body
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
