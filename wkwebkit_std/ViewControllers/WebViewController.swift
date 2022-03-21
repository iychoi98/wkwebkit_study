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
    
    var popupWebView: WKWebView?
    
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
    
    //새 탭 열리는 부분 처리
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        popupWebView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView?.navigationDelegate = self
        popupWebView?.uiDelegate = self
        view.addSubview(popupWebView!)
        
        return popupWebView!
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        wkWebView.removeFromSuperview()
        popupWebView = nil
    }
    
    
//
//    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
//        <#code#>
//    }
//
//    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async -> Bool {
//        <#code#>
//    }
//
//    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo) async -> String? {
//        <#code#>
//    }
}

//MARK: - WKNavigationDelegate 관련 함수
extension WebViewController: WKNavigationDelegate {
    
    //들어온 링크 확인
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
}
