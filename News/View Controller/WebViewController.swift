//
//  WebViewController.swift
//  News
//
//  Created by Madison Shino on 6/1/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var articleWebView: WKWebView!
    
    //MARK: Properties
    
    var url: URL?
    
    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }
    
    //MARK: Methods
    
    func loadWebView() {
        if url != nil {
            let request = URLRequest(url: url!)
            articleWebView.load(request)
        } else {
            let alertController = UIAlertController(title: "Unable to load page", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "YES", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
