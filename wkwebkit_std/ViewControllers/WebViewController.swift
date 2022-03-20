//
//  WebViewController.swift
//  wkwebkit_std
//
//  Created by iychoi on 2022/03/20.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var wkWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadUrl()
    }
}

extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    func initWebView() {
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
    }
    
    func loadUrl() {
        guard let url = URL(string: "https://www.google.co.kr") else { return }
        let request = URLRequest(url: url)
        
        wkWebView.load(request)
    }
}
