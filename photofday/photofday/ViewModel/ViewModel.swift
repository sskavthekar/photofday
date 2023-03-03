//
//  ViewModel.swift
//  photofday
//
//  Created by Siddharth on 02/03/23.
//

import Foundation
import UIKit
import Reachability

enum Constants {
    public static let url = "https://api.nasa.gov/planetary/apod"
    public static let apikey = "W5D7dQFdqwEJX3oSS1yr4Szp0u46nO7Gve5GglZC"
    public static let apiHeaderKey = "x-api-key"
    public static let cacheTitleKey = "CachedTitleKey"
    public static let cacheSubTitleKey = "CachedSubTitleKey"
    public static let cacheImageKey = "CachedPhotoImage"
    public static let defaultMsg = "We are not connected to the internet, showing you the last image we have."
    public static let noInternet = "We are not connected to the internet!"
}

enum Method: String {
    case get = "GET"
}

protocol ViewModelProtocol: AnyObject {
    func update(photo: PhotoDetails)
    func show(msg: String)
}

class ViewModel {
    
    private var reachability: Reachability?
    
    private weak var delegate: ViewModelProtocol?
    
    //Set  delegate
    func set(delegate: ViewModelProtocol?) {
        self.delegate = delegate
        setupReachability()
    }
    
    //Set up reachability logic
    func setupReachability(){
        reachability = try? Reachability()
        reachability?.stopNotifier()
        try? reachability?.startNotifier()
        
        NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(reachabilityChanged(_:)),
                        name: .reachabilityChanged,
                        object: reachability
                    )
    }
    
    func fetchData() {
        guard
            reachability?.connection == .unavailable
        else {
            fetchLastText()
            return
        }
        var request = URLRequest(url: URL(string: Constants.url)!,timeoutInterval: Double.infinity)
        request.addValue(Constants.apikey, forHTTPHeaderField: Constants.apiHeaderKey)
        
        request.httpMethod = Method.get.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard
                let data = data
            else {
                print(String(describing: error))
                return
            }
            if let str = String(data: data, encoding: .utf8),
               let jsonData = str.data(using: .utf8),
               let photo: PhotoDetails = try? JSONDecoder().decode(PhotoDetails.self, from: jsonData) as? PhotoDetails {
                self?.delegate?.update(photo: photo)
                self?.save(details: photo)
            }
        }
        task.resume()
    }
    
    deinit {
        stopNotifier()
    }
}

extension ViewModel {
    //Set up reachability logic for starting notificationf or  internet
    func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            return
        }
    }
    
    //Set up reachability logic for stopping notificationf or  internet
    func stopNotifier() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    
    //Set up reachability logic for stopping notificationf or  internet - oN Of OFf
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection != .unavailable {
            fetchData()
        } else {
            // do nothing
        }
    }
}

//Cache data
extension ViewModel {
    //Save details to Userdefaults
    func save(details: PhotoDetails) {
        UserDefaults.standard.setValue(details.title, forKey: Constants.cacheTitleKey)
        UserDefaults.standard.setValue(details.explanation, forKey: Constants.cacheSubTitleKey)
        UserDefaults.standard.setValue(details.hdurl, forKey: Constants.cacheImageKey)
    }
    
    //Save details from Userdefaults
    func fetchLastText() {
        var object: PhotoDetails = PhotoDetails(title: "", explanation: "", url: "", hdurl: "", date: Date().description)
        object.title = UserDefaults.standard.value(forKey: Constants.cacheTitleKey) as? String ?? ""
        object.explanation = UserDefaults.standard.value(forKey: Constants.cacheSubTitleKey) as? String ?? ""
        if let imageUrl: String = UserDefaults.standard.value(forKey: Constants.cacheImageKey) as? String {
            object.hdurl = imageUrl
        } else {
            object.hdurl = ""
        }
        delegate?.update(photo: object)
        
        //Show relevant message
        let msg: String = object.isValid ? Constants.defaultMsg : Constants.noInternet
        delegate?.show(msg: msg)
    }
}
