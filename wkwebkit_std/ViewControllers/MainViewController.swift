//
//  ViewController.swift
//  wkwebkit_std
//
//  Created by iychoi on 2022/03/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MainViewController: UIViewController {
    
    @IBOutlet weak var moveButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    static func instance() -> MainViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        bindAction()
    }
}

extension MainViewController {
    private func bindAction() {
        moveButton.rx.tap
            .bind {
                let vc = WebViewController.instance()
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
    }
}
