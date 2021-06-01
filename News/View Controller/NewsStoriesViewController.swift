//
//  NewsStoriesViewController.swift
//  News
//
//  Created by Madison Shino on 5/28/21.
//

import UIKit

class NewsStoriesViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    //MARK: Properties
    
    var articles: [Article] = []
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDelegates()
        loadInitialView()
    }
    
    //MARK: Methods

    func updateView() {
        DispatchQueue.main.async { [self] in
            self.titleLabel.text = self.searchBar.text == "" ? "Top News Articles" : "News Articles for '\(self.searchBar.text!)'"
            self.articleTableView.reloadData()
            if self.articles.isEmpty == true {
                self.noResultsLabel.isHidden = false
            } else {
                self.noResultsLabel.isHidden = true
            }
        }
    }
    
    func assignDelegates() {
        searchBar.delegate = self
        articleTableView.delegate = self
        articleTableView.dataSource = self
    }
    
    func loadTopArticles() {
        ArticleController.sharedInstance.fetchTopArticlesForCountry(Country.unitedStates) { (articles, error) in
            if let error = error {
                self.presentErrorMessage(error)
                return
            }
            if let articles = articles {
                self.articles = articles
            } else {
                self.articles = []
            }
        }
        updateView()
    }
    
    func loadArticlesWithSearch(_ searchText: String) {
        ArticleController.sharedInstance.fetchArticlesFromSearch(searchText) { (articles, error) in
            if let error = error {
                self.presentErrorMessage(error)
                return
            }
            if let articles = articles {
                self.articles = articles
            } else {
                self.articles = []
            }
        }
        updateView()
    }
    
    func loadInitialView() {
        searchBar.text = "Crypto Currency"
        titleLabel.text = "Crypto Currency"
        loadArticlesWithSearch(searchBar.text!)
    }
    
    func presentErrorMessage(_ error: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Something went wrong", message: error, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArticleDetailVC" {
            if let detailViewController = segue.destination as? ArticleDetailViewController,
                let indexPath = articleTableView.indexPathForSelectedRow?.row {
                let article = articles[indexPath]
                detailViewController.article = article
            }
        }
    }
}

extension NewsStoriesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            ArticleController.sharedInstance.fetchArticlesFromSearch(searchText) { (articles, error) in
                if let articles = articles {
                    self.articles = articles
                    self.updateView()
                } else {
                    self.articles = []
                    self.updateView()
                }
            }
        } else {
            titleLabel.text = "Top News Articles"
            loadTopArticles()
        }
    }
}

extension NewsStoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? ArticleTableViewCell else { return UITableViewCell() }
        let article = articles[indexPath.row]
        cell.article = article
        cell.selectionStyle = .none
        return cell
    }
}
