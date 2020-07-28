//
//  LoginViewController.swift
//  TheMovieWithAlamofire
//
//  Created by MM on 7/24/20.
//  Copyright © 2020 MM. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.layer.cornerRadius = 25
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRequestToken()
    }
    
    func getRequestTokenDataFromUserDefaults() -> RequestToken? {
        if let requestTokenData = defaults.data(forKey: "requestToken") {
            let json = JSONDecoder()
            var rt: RequestToken? = nil
            do {
                rt = try json.decode(RequestToken.self, from: requestTokenData)
            } catch {
                print(error)
            }
            if let requestToken = rt {
                return requestToken
            } else {
                return nil
            }
        }
        return nil
    }
    
    func getSessionDataFromUserDefaults() -> Session? {
        if let sessionData = defaults.data(forKey: "session") {
            let json = JSONDecoder()
            var ss: Session? = nil
            do {
                ss = try json.decode(Session.self, from: sessionData)
            } catch {
                print(error)
            }
            if let session = ss {
                return session
            } else {
                return nil
            }
        }
        return nil
    }
    
    func getRequestToken() {
        let params = [
            "api_key": API.apiKey,
        ]
        AF.request("https://api.themoviedb.org/3/authentication/token/new", method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.data {
                    self.defaults.set(data, forKey: "requestToken")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func presentTabBar() {
        let listVC = ListViewController()
        let listNavController = UINavigationController(rootViewController: listVC)
        listNavController.tabBarItem.image = UIImage(systemName: "play.rectangle")
        listNavController.tabBarItem.selectedImage = UIImage(systemName: "play.rectangle.fill")
        listNavController.tabBarItem.title = "Now Playing"
        
        let ratedVC = RatedViewController()
        let ratedNavController = UINavigationController(rootViewController: ratedVC)
        ratedNavController.tabBarItem.image = UIImage(systemName: "star")
        ratedNavController.tabBarItem.selectedImage = UIImage(systemName: "star.fill")
        ratedNavController.tabBarItem.title = "Log Out"
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .systemTeal
        tabBarController.viewControllers = [listNavController, ratedNavController]
        
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true, completion: nil)
    }
    
    @IBAction func btnLoginPressed(_ sender: UIButton) {
        guard let username = txfUsername.text else { return }
        guard let password = txfPassword.text else { return }
        guard let requestToken = getRequestTokenDataFromUserDefaults()?.request_token else { return }
        
        let params = [
            "username": username,
            "password": password,
            "request_token": requestToken
            ] as [String : Any]
        
        AF.request("https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(API.apiKey)", method: .post, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200:
                        if let data = response.data {
                            self.defaults.set(data, forKey: "requestToken")
                        }
                        if let requestToken = self.getRequestTokenDataFromUserDefaults() {
                            guard let success = requestToken.success else { return }
                            if success == false { return }
                            guard let token = requestToken.request_token else { return }
                            let tokenParam = ["request_token": token]
                            AF.request("https://api.themoviedb.org/3/authentication/session/new?api_key=\(API.apiKey)", method: .post, parameters: tokenParam).responseJSON { (responseSession) in
                                if let data = responseSession.data {
                                    self.defaults.set(data, forKey: "session")
                                }
                                if let session = self.getSessionDataFromUserDefaults() {
                                    guard let success = session.success else { return }
                                    if success == false { return }
                                    self.presentTabBar()
                                }
                            }
                        }
                    default:
                        print(response)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
