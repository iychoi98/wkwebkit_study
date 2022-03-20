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
}

extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    func initWebView() {
        view.addSubview(wkWebView)
        
        guard let url = URL(string: "https://www.google.co.kr") else { return }
        let request = URLRequest(url: url)
        
        wkWebView.load(request)
        
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
    }
}
