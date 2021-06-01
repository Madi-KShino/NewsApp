//
//  NewsStoriesViewController.swift
//  News
//
//  Created by Madison Shino on 5/28/21.
//

import UIKit

class NewsStoriesViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var slideMenuButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var articleTableView: UITableView!
    
    
    //MARK: Properties
    
    var articles: [Article] = []
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDelegates()
        loadInitialView()
//        updateView()
    }
    
    //MARK: Methods

    func updateView() {
        DispatchQueue.main.async {
            self.articleTableView.reloadData()
        }
    }
    
    func assignDelegates() {
        searchBar.delegate = self
        articleTableView.delegate = self
        articleTableView.dataSource = self
    }
    
    func loadTopArticles() {
        ArticleController.sharedInstance.fetchTopArticlesForCountry(Country.unitedStates) { (articles, error) in
            if let articles = articles {
                self.articles = articles
                self.updateView()
            }
        }
    }
    
    func loadInitialView() {
        searchBar.text = "crypto"
        ArticleController.sharedInstance.fetchArticlesFromSearch("crypto") { (articles, error) in
            if let articles = articles {
                self.articles = articles
                self.updateView()
            }
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
        guard let searchText = searchBar.text,
              searchText != "" else { return }
        ArticleController.sharedInstance.fetchArticlesFromSearch(searchText) { (articles, error) in
            if let articles = articles {
                self.articles = articles
                self.updateView()
            }
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
