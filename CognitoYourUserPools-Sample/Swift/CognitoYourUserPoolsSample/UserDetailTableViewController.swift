//
// Copyright 2014-2018 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License").
// You may not use this file except in compliance with the
// License. A copy of the License is located at
//
//     http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, express or implied. See the License
// for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import AWSCognitoIdentityProvider
import SwiftyJSON
import RxCocoa
import RxSwift

struct UserData: Codable {
    let name: String
    let plan: [Plan]
}

struct Plan: Codable {
    let en: String
    let posted: String
    let st: String
    let tag: String
    let content: String
}

class UserDetailTableViewController : UITableViewController {
    
    var response: AWSCognitoIdentityUserGetDetailsResponse?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    var plans: [Plan] = []
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lifecycle"
        self.tableView.delegate = self
        self.pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
        if (self.user == nil) {
            self.user = self.pool?.currentUser()
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(reload), for: .valueChanged)
        self.refreshControl = refreshControl
        
        
        AWSCognitoModel.userNameRx.asDriver()
            .drive(onNext: { _ in
                if AWSCognitoModel.userNameRx.value.count != 0 {
                    let urlString = "https://qm2ju9z5y5.execute-api.ap-northeast-1.amazonaws.com/dev/pytest?name=" + AWSCognitoModel.userNameRx.value
                    if let url = URL(string: urlString) {
                        let request = URLRequest(url: url)
                        let session = URLSession.shared
                        session.dataTask(with: request) { (data, response, error) in
                            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                                print("status code:\(response.statusCode)")
                                if let userData = self.parseJsonToUserData(data: data) {
                                    self.plans = userData.plan
                                }
                                self.plans.reverse()
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                           }.resume()
                    }
                }
                
            }).disposed(by: self.disposeBag)
        self.refresh()
    }
    
    @objc func reload() {
        if AWSCognitoModel.userNameRx.value.count != 0 {
            let urlString = "https://qm2ju9z5y5.execute-api.ap-northeast-1.amazonaws.com/dev/pytest?name=" + AWSCognitoModel.userNameRx.value
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    if error == nil, let data = data, let response = response as? HTTPURLResponse {
                        print("status code:\(response.statusCode)")
                        self.plans.removeAll()
                        if let userData = self.parseJsonToUserData(data: data) {
                            self.plans = userData.plan
                        }
                        self.plans.reverse()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    }
                    }.resume()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return plans.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "lifecycleTableViewCell", for: indexPath)
        if let cell = tableViewCell as? LifecycleTableViewCell {
            cell.setUpView(plan: plans[indexPath.section])
        }
        return tableViewCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }


    @IBAction func signOut(_ sender: AnyObject) {
        self.response = nil
        self.tableView.reloadData()
        self.refresh()
    }
    
    func refresh() {
        self.user?.getDetails().continueOnSuccessWith { (task) -> AnyObject? in
            DispatchQueue.main.async(execute: {
                self.response = task.result
            })
            return nil
        }
    }
    
    private func parseJsonToUserData(data: Data) -> UserData? {
        if let jsonString = String(data: data, encoding: String.Encoding.utf8) {
            let jsonData = jsonString.data(using: .utf8)
            if let userData = try? JSONDecoder().decode(UserData.self, from: jsonData!) {
                return userData
            }
        }
        return nil
    }
}

