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
    @IBOutlet weak var articleSourceLabel: UILabel!
    @IBOutlet weak var articleAuthorLabel: UILabel!
    @IBOutlet weak var articleLinkButton: UIButton!
    
    //MARK: Properties
    
    var article: Article?
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        updateView()
    }
    
    //MARK: Actions
    
    @IBAction func didSelectArticleLinkButton(_ sender: Any) {
        let alertController = UIAlertController(title: "View full article?", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "YES", style: .default) { (action) in
            self.performSegue(withIdentifier: "toArticleWebViewController", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Methods
    
    func updateView() {
        if article != nil {
            articleTitleLabel.text = article!.title
            articleBodyLabel.text = article!.body
            articleDateLabel.text = formattedDateString(dateString: article!.date)
            articleSourceLabel.text = article!.source.name
            articleAuthorLabel.text = article!.author
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
    
    func formattedDateString(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        if date != nil {
            return dateFormatter.string(from: date!)
        } else {
            return ""
        }
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArticleWebViewController" {
            if let webViewController = segue.destination as? WebViewController,
               let url = article?.url {
                webViewController.url = url
            }
        }
    }
}
