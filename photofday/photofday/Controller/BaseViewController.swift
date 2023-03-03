//
//  BaseViewController.swift
//  photofday
//
//  Created by Siddharth on 03/03/23.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        
    }
}

extension BaseViewController {
    func showAlert(string: String) {
        let title = string
        let buttonText = "Okay"
        
        let alert =  UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAcction  = UIAlertAction(title: buttonText, style: .default)
        alert.addAction(okAcction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
}
