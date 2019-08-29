//
//  PostViewController.swift
//  CognitoYourUserPoolsSample
//
//  Created by oyutar on 2019/08/28.
//  Copyright © 2019 Dubal, Rohan. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var start: UITextField!
    @IBOutlet weak var end: UITextField!
    @IBOutlet weak var tag: UITextField!
    @IBOutlet weak var error_text: UILabel!
    @IBOutlet weak var content: UITextField!
    var name:String?
    var start_datePicker: UIDatePicker = UIDatePicker()
    var end_datePicker: UIDatePicker = UIDatePicker()
    
    var pickerView: UIPickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "投稿"
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        name = appDelegate.USER_NAME
        
        // 開始時刻用ピッカー設定
        start_datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        start_datePicker.timeZone = NSTimeZone.local
        start_datePicker.locale = Locale(identifier: "ja")
        start.inputView = start_datePicker
        
        // 終了時刻用ピッカー設定
        end_datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        end_datePicker.timeZone = NSTimeZone.local
        end_datePicker.locale = Locale(identifier: "ja")
        end.inputView = end_datePicker
        
        // 開始時刻決定バーの生成
        let start_toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let start_spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let start_doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(start_done))
        start_toolbar.setItems([start_spacelItem, start_doneItem], animated: true)

        // 終了時刻決定バーの生成
        let end_toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let end_spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let end_doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(end_done))
        end_toolbar.setItems([end_spacelItem, end_doneItem], animated: true)
        
        // 開始時刻インプットビュー設定
        start.inputView = start_datePicker
        start.inputAccessoryView = start_toolbar

        // 終了時刻インプットビュー設定
        end.inputView = end_datePicker
        end.inputAccessoryView = end_toolbar
        
        //tagのpickerview
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)
        
        self.tag.inputView = pickerView
        self.tag.inputAccessoryView = toolbar
    }
    
    // 決定ボタン押下
    @objc func start_done() {
        start.endEditing(true)
        // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd-HH:mm"
        start.text = formatter.string(from: start_datePicker.date)
    }

    @objc func end_done() {
        end.endEditing(true)
        // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd-HH:mm"
        end.text = formatter.string(from: end_datePicker.date)
    }
    
    @IBAction func postEvent(_ sender: UIButton) {
        if (self.start.text == "" || self.end.text == "" ||
            self.tag.text == "" ){
            error_text.text = "全ての内容を埋めてください"
        }
        else{
        let url = URL(string: "https://qm2ju9z5y5.execute-api.ap-northeast-1.amazonaws.com/dev/test")
        var request = URLRequest(url: url!)
        // POSTを指定
        request.httpMethod = "POST"
        // POSTするデータをBodyとして設定
            
            //request.httpBody = "{\"name\":\"shuma1111\", \"tag\":\"1111\", \"st\":\"aaaaaa\", \"en\":\"bbbbb\"}".data(using: .utf8)
            
        request.httpBody = "{\"name\":\"\(name ?? "")\", \"tag\":\"\(tag.text ?? "")\", \"st\":\"\(start.text ?? "")\", \"en\":\"\(end.text ?? "")\", \"content\":\"\(content.text ?? "")\"}".data(using: .utf8)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPヘッダの取得
                print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
                print(String(data: data, encoding: .utf8) ?? "")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            }.resume()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PullDownModel.pullDownList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PullDownModel.pullDownList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tag.text = String(row)
    }
    
    @objc func cancel() {
        self.tag.text = ""
        self.tag.endEditing(true)
    }
    
    @objc func done() {
        self.tag.endEditing(true)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
