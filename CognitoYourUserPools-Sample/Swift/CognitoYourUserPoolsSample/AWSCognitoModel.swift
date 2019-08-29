//
//  AWSCognitoModel.swift
//  CognitoYourUserPoolsSample
//
//  Created by oyutar on 2019/08/29.
//  Copyright © 2019 Dubal, Rohan. All rights reserved.
//

import Foundation
import RxCocoa


class AWSCognitoModel {
    static var userNameRx = RxCocoa.BehaviorRelay<String>(value: "")
}
