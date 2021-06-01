//
//  ArticleController.swift
//  News
//
//  Created by Madison Shino on 5/30/21.
//

import UIKit

class ArticleController {
    
    //MARK: Properties
    
    //Source of Truth
    var articles = [Article]()
    
    //Shared instance
    static let sharedInstance = ArticleController()
    
    fileprivate let apiKey = "beb2c5bcbc994581b97bec0ea71c1d5d"
    fileprivate let baseURL = URL(string: "https://newsapi.org/v2/")
    
    //MARK: Class Methods
    
    func fetchAllArticles(completion: @escaping(([Article]?) -> Void )) {
        
    }
    
    func fetchTopArticlesForCountry(_ country: Country, completion: @escaping([Article]?, String?) -> Void) {
        guard let url = baseURL else { completion(nil, "Invalid URL"); return }
        let urlWithPathComponent = url.appendingPathComponent("top-headlines")
        var urlComponents = URLComponents(url: urlWithPathComponent, resolvingAgainstBaseURL: true)
        let keyQueryComponent = URLQueryItem(name: "apiKey", value: apiKey)
        let countryQueryComponent = URLQueryItem(name: "country", value: country.rawValue)
        urlComponents?.queryItems = [countryQueryComponent, keyQueryComponent]
        guard let finalURL = urlComponents?.url else { return }
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            if let data = data {
                do {
                    let results = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                    completion(results.articles, nil)
                } catch {
                    completion(nil, "Error decoding data.")
                    return
                }
            }
        } .resume()
    }
    
    func fetchArticlesFromSearch(_ searchText: String, completion: @escaping([Article]?, String?) -> Void) {
        guard let url = baseURL else { completion(nil, "Invalid URL"); return }
        let urlWithPathComponent = url.appendingPathComponent("everything")
        var urlComponents = URLComponents(url: urlWithPathComponent, resolvingAgainstBaseURL: true)
        let keyQueryComponent = URLQueryItem(name: "apiKey", value: apiKey)
        let countryQueryComponent = URLQueryItem(name: "q", value: searchText)
        urlComponents?.queryItems = [countryQueryComponent, keyQueryComponent]
        guard let finalURL = urlComponents?.url else { return }
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            if let data = data {
                do {
                    let results = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                    completion(results.articles, nil)
                } catch {
                    completion(nil, "Error decoding data.")
                    return
                }
            }
        } .resume()
    }
    
    func fetchImageForArticle(_ article: Article, completion: @escaping(UIImage?, String?) -> Void) {
        guard let imageURL = article.imageURL else { completion(nil, "Invalid Image URL"); return }
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            }
            if let data = data {
                guard let image = UIImage(data: data) else { completion(nil, "Error converting image."); return }
                completion(image, nil)
            }
        } .resume()
    }
    
    func createArticleWith(title: String, image: UIImage?, body: String, date: Date, withURL: URL) {
        
    }
    
    func remove(article: Article) {
        
    }
}
