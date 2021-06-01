//
//  ArticleDetailViewController.swift
//  News
//
//  Created by Madison Shino on 5/30/21.
//

import UIKit

class ArticleDetailViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleBodyLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    
    //MARK: Properties
    
    var article: Article?
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        updateView()
    }
    
    //MARK: Actions
    
    
    //MARK: Methods
    
    func updateView() {
        if article != nil {
            articleTitleLabel.text = article!.title
            articleBodyLabel.text = article!.body
            articleDateLabel.text = article!.date
            if article!.imageURL != nil {
                ArticleController.sharedInstance.fetchImageForArticle(article!) { (image, error) in
                    if let image = image {
                        DispatchQueue.main.async {
                            self.articleImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    func setUI() {
        articleImageView.layer.cornerRadius = 10
    }
    
    func stringFrom(date: Date) -> String {
        return "dateString"
    }
}
