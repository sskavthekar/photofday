//
//  ViewController.swift
//  photofday
//
//  Created by Siddharth on 02/03/23.
//

import UIKit
import SDWebImage

class ViewController: BaseViewController {
    
    @IBOutlet var screentitle: UITextView!
    @IBOutlet var subTitle: UITextView!
    @IBOutlet var imageView: UIImageView!
    
    private var viewmodel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
    }
    
    //Fetch data
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
}

//  MARK: - Viewmodel functions
extension ViewController: ViewModelProtocol {
    
    //Set delegate
    func setDelegate() {
        viewmodel.set(delegate: self)
    }
    
    //Fetch data from nasa api
    func fetchData() {
        viewmodel.fetchData()
    }
    
    //Update data response from api to user interfacce
    func update(photo: PhotoDetails) {
        DispatchQueue.main.async { [weak self] in
            self?.screentitle?.text = photo.title
            self?.subTitle?.text = photo.explanation
            self?.imageView.sd_setImage(with: URL(string: photo.hdurl)!)
            self?.subTitle.flashScrollIndicators()
        }
    }
    
    //Show message on alert if required
    func show(msg: String) {
        showAlert(string: msg)
    }
}
