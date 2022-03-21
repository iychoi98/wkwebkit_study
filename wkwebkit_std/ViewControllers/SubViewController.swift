//
//  SubViewController.swift
//  wkwebkit_std
//
//  Created by iychoi on 2022/03/21.
//

import UIKit

class SubViewController: UIViewController {
    
    static func instance() -> SubViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
