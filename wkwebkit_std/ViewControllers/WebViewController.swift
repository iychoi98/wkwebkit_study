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
    private weak var webConfigure: WKWebViewConfiguration?
    
    var popupWebView: WKWebView?
    
    static func instance() -> WebViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWebView()
        bindAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadUrl()
        checkNetwork()
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
    
    func checkNetwork() {
        guard Reachability.networkConnected() else {
            let alertController = UIAlertController(title: "네트워크 오류", message: "네트워크 연결 확인 부탁드립니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "종료", style: .default) { (action) in
                exit(0) //프로그램 종료 -> 메인화면으로 이동
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
    }
    
    func changeQueryDictionary(_ query: String) -> [String:String]? {
        var queryDictionary = [String:String]()
        
        for pair in query.components(separatedBy: "&") {
            let key = pair.components(separatedBy: "=")[0]
            let value = pair.components(separatedBy: "=")[1]
            
            queryDictionary[key] = value
        }
        
        return queryDictionary
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
    
    //MARK: - 브라우저 경고창 처리 (alert, confirm, prompt)
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertContoller = UIAlertController(title: "alertPanel", message: "messege", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "", style: .default) { (action) in
            completionHandler()
        }
        alertContoller.addAction(alertAction)
        self.present(alertContoller, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertContoller = UIAlertController(title: "alertPanel", message: "messege", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { (action) in
            completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default) { (action) in
            completionHandler(false)
        }
        alertContoller.addAction(confirmAction)
        alertContoller.addAction(cancelAction)
        self.present(alertContoller, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default) { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: - WKNavigationDelegate 관련 함수
extension WebViewController: WKNavigationDelegate {
    
    //웹페이지의 탐색 허용 여부를 결정 (url 응답값 받기 전)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("url 응답 받기 전")
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        if let query = url.query {
            guard let result = changeQueryDictionary(query) else { return }
            print("파라미터 \(result)")
        }
        
        if url.scheme == "https" || url.scheme == "http" {
            decisionHandler(.allow)
        } else if (url.scheme == "about") {
            print("about:blank")
            decisionHandler(.allow)
        } else {
            decisionHandler(.allow)
            
            let vc = SubViewController.instance()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //웹페이지의 탐색 허용 여부를 결정 (url 응답 값 받은 후)
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("url 응답 받은 후")
        
        decisionHandler(.allow)
    }
    
    //웹 뷰가 컨텐츠 탐색을 시작할 때
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("컨텐츠 탐색 시작 start")
    }
    
    //웹 뷰가 콘텐츠를 받기 시작할 때
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("컨텐츠 받기 시작 commit")
    }
    
    //탐색 완료
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("컨텐츠 받기 완료 finish")
    }
    
    //탐색 실패
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("컨텐츠 받기 실패 fail")
    }
    
    //웹 뷰가 서버 redirect를 수신했을 때 호출
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("didReceiveRedirect")
    }
    
    //웹 뷰가 인증 문제에 응답해야할 때 호출
    //    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    //        print("인증 문제")
    //    }
    
    //웹 컨텐츠 종료
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("웹 컨텐츠 종료")
    }
    
}
