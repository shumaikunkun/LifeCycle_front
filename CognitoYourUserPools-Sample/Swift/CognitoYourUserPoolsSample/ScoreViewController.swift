//
//  ScoreViewController.swift
//  CognitoYourUserPoolsSample
//
//  Created by oyutar on 2019/08/29.
//  Copyright © 2019 Dubal, Rohan. All rights reserved.
//

import UIKit

struct Point: Codable {
    let hash: DetailPoint
    let point: Int
}

struct DetailPoint: Codable {
    let a0: Int
    let a1: Int
    let a2: Int
    let a3: Int
    let a4: Int
    let a5: Int
    let a6: Int
    let a7: Int
    let a8: Int
    let a9: Int
}

class ScoreViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var studyLabel: UILabel!
    @IBOutlet weak var deployLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var excerciseLabel: UILabel!
    @IBOutlet weak var smaphoLabel: UILabel!
    @IBOutlet weak var televiLabel: UILabel!
    @IBOutlet weak var meetLabel: UILabel!
    @IBOutlet weak var playLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "得点"
        bind()
    }
    
    func bind() {
        resultLabel.text = AWSCognitoModel.userNameRx.value + "さんの採点結果"
        let urlString = "https://qm2ju9z5y5.execute-api.ap-northeast-1.amazonaws.com/dev/score?name=" + AWSCognitoModel.userNameRx.value
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error == nil, let data = data, let response = response as? HTTPURLResponse {
                    print("status code:\(response.statusCode)")
                    print(String(data: data, encoding: .utf8) ?? "")
                    if let data = self.parseJsonToUserData(data: data) {
                        DispatchQueue.main.async {
                            self.totalLabel.text = "\(data.point)"
                            self.sleepLabel.text = "\(data.hash.a0)"
                            self.studyLabel.text = "\(data.hash.a1)"
                            self.deployLabel.text = "\(data.hash.a2)"
                            self.gameLabel.text = "\(data.hash.a3)"
                            self.excerciseLabel.text = "\(data.hash.a4)"
                            self.smaphoLabel.text = "\(data.hash.a5)"
                            self.televiLabel.text = "\(data.hash.a6)"
                            self.meetLabel.text = "\(data.hash.a7)"
                            self.playLabel.text = "\(data.hash.a8)"
                            self.otherLabel.text = "\(data.hash.a9)"
                        }
                    }
                }
                }.resume()
        }

        
    }
    
    private func parseJsonToUserData(data: Data) -> Point? {
        if let jsonString = String(data: data, encoding: String.Encoding.utf8) {
            let jsonData = jsonString.data(using: .utf8)
            if let point = try? JSONDecoder().decode(Point.self, from: jsonData!) {
                return point
            }
        }
        return nil
    }
}
