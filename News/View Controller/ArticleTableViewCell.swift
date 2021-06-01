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
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateView() {
        guard let article = article else { return }
        articleImageView.layer.cornerRadius = 10
        cellStackView.layer.cornerRadius = 10
        if self.traitCollection.userInterfaceStyle == .dark {
            self.cellStackView.layer.backgroundColor = #colorLiteral(red: 0.2388129957, green: 0.2388129957, blue: 0.2388129957, alpha: 1)
        } else {
            self.cellStackView.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        titleLabel.text = article.title
        summaryLabel.text = article.body
        if article.imageURL != nil {
            ArticleController.sharedInstance.fetchImageForArticle(article) { (image, error) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.articleImageView.image = image
                    }
                }
            }
        }
    }
}
