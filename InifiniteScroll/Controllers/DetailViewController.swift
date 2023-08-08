//
//  DetailViewController.swift
//  InifiniteScroll
//
//  Created by Sergei Semko on 8/8/23.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKUIDelegate {
    
    var url: String?
    private var webView: WKWebView?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "globe"), style: .plain, target: self, action: #selector(openTapped))
        
        guard let safeUrl = url else { return }
        guard let myUrl = URL(string: safeUrl) else { return }
        let myRequest = URLRequest(url: myUrl)
        webView?.load(myRequest)
    }
    
    @objc
    func openTapped() {
        guard let safeUrl = url else { return }
        guard let link = URL(string: safeUrl) else { return }
        UIApplication.shared.open(link)
    }

}
