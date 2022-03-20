//
//  WebViewController.swift
//  wkwebkit_std
//
//  Created by iychoi on 2022/03/20.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import RxGesture

class WebViewController: UIViewController {
    @IBOutlet weak var wkWebView: WKWebView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWebView()
        bindAction()
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

extension WebViewController {
    private func bindAction() {
        backButton.rx.tap
            .bind {
                print("backBtn")
            }.disposed(by: disposeBag)
        
        forwardButton.rx.tap
            .bind {
                print("forwardBtn")
            }.disposed(by: disposeBag)
        
        homeButton.rx.tap
            .bind {
                print("homeBtn")
            }.disposed(by: disposeBag)
        
        resetButton.rx.tap
            .bind {
                print("resetBtn")
            }.disposed(by: disposeBag)
    }
}
