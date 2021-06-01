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
    
//    fileprivate let apiKey = "beb2c5bcbc994581b97bec0ea71c1d5d"
    fileprivate let apiKey = "828a6ecc708a4f969a8f60460c4a6e76"
    fileprivate let baseURL = URL(string: "https://newsapi.org/v2/")
    
    //MARK: Class Methods
    
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
            var errorMessage: String?
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 400: errorMessage = "Invalid Request"
                case 401: errorMessage = "Invalid or missing API key"
                case 429: errorMessage = "Too many requests. Try again later."
                case 500: errorMessage = "Server Error"
                default : errorMessage = "Error decoding data."
                }
            }
            if let data = data {
                do {
                    let results = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                    completion(results.articles, nil)
                } catch {
                    completion(nil, errorMessage)
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
            var errorMessage: String?
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 400: errorMessage = "Invalid Request"
                case 401: errorMessage = "Invalid or missing API key"
                case 429: errorMessage = "Too many requests. Try again later."
                case 500: errorMessage = "Server Error"
                default : errorMessage = "Error decoding data"
                }
            }
            if let data = data {
                do {
                    let results = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                    completion(results.articles, nil)
                } catch {
                    completion(nil, errorMessage)
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
}
