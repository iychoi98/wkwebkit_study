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

extension WebViewController {
    func initWebView() {
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
    }
    
    func loadUrl() {
        guard let url = URL(string: "https://www.google.co.kr") else { return }
        let request = URLRequest(url: url)
        
        wkWebView.load(request)
    }
    
    private func backPage() {
        if wkWebView.canGoBack {
            wkWebView.goBack()
        } else {
            print("no back page")
        }
    }
    
    private func forwardPage() {
        if wkWebView.canGoForward {
            wkWebView.goForward()
        } else {
            print("no forward page")
        }
    }
    
    private func homePage() {
        guard let url = URL(string: "https://www.google.co.kr") else { return }
        let request = URLRequest(url: url)
        
        wkWebView.load(request)
    }
    
    private func resetPage() {
        wkWebView.reload()
    }
    
}

extension WebViewController {
    private func bindAction() {
        backButton.rx.tap
            .bind {
                self.backPage()
            }.disposed(by: disposeBag)
        
        forwardButton.rx.tap
            .bind {
                self.forwardPage()
            }.disposed(by: disposeBag)
        
        homeButton.rx.tap
            .bind {
                self.homePage()
            }.disposed(by: disposeBag)
        
        resetButton.rx.tap
            .bind {
                self.resetPage()
            }.disposed(by: disposeBag)
    }
}

//MARK: - WKUIDelegate 관련 함수
extension WebViewController: WKUIDelegate {
    
}

//MARK: - WKNavigationDelegate 관련 함수
extension WebViewController: WKNavigationDelegate {
    
}
