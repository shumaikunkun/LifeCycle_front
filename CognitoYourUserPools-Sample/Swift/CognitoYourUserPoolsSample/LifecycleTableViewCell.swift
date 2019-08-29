//
//  LifecycleTableViewCell.swift
//  CognitoYourUserPoolsSample
//
//  Created by oyutar on 2019/08/28.
//  Copyright © 2019 Dubal, Rohan. All rights reserved.
//

import UIKit

class LifecycleTableViewCell: UITableViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var postedLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpView(plan: Plan) {
        if let tag = Int(plan.tag) {
            tagLabel.text = PullDownModel.pullDownList[tag].components(separatedBy: ":")[1]
        } else {
            tagLabel.text = "不明"
        }
        startTimeLabel.text = plan.st
        endTimeLabel.text = plan.en
        memoTextView.text = plan.content
        postedLabel.text = plan.posted
    }

}
