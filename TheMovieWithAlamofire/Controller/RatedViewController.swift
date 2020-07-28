//
//  RatedViewController.swift
//  TheMovieWithAlamofire
//
//  Created by MM on 7/24/20.
//  Copyright © 2020 MM. All rights reserved.
//

import UIKit
import Alamofire

class RatedViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Log Out"
        navigationController?.navigationBar.prefersLargeTitles = true
        //getList()
    }

    @IBAction func btnLogoutPressed(_ sender: UIButton) {
        guard let session = getSessionDataFromUserDefaults() else { return }
        guard let sessionId = session.session_id else { return }
                
        let params = [ "session_id": sessionId]
        
        AF.request("https://api.themoviedb.org/3/authentication/session?api_key=\(API.apiKey)", method: .delete, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(_):
                switch response.response?.statusCode {
                case 200:
                    if let data = response.data {
                        let json = JSONDecoder()
                        var sessionLogout: SessionLogOut? = nil
                        do {
                            sessionLogout = try json.decode(SessionLogOut.self, from: data)
                        } catch {
                            print(error)
                        }
                        if let sessionLogout = sessionLogout {
                            guard let success = sessionLogout.success else { return }
                            if success == true {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                default:
                    print(response.response!.statusCode)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
}
