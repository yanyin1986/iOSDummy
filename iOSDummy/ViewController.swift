//
//  ViewController.swift
//  iOSDummy
//
//  Created by yin.yan on 2019/09/02.
//  Copyright © 2019 Leon.yan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var bytesFields: UITextField!
    @IBOutlet weak var countFields: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private lazy var documentUrl: URL = {
        guard let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            fatalError("Error when get documentDirectory")
        }
        return url
    }()

    private let queue = DispatchQueue(label: "dummy-create-queue")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func createDummyFiles(_ sender: UIButton) {
        guard
            let bytesText = bytesFields.text,
            let bytes = Int(bytesText),
            let countText = countFields.text,
            let count = Int(countText)
        else {
            print("bytes or count is not valid")
            return
        }

        activityIndicator.startAnimating()
        sender.isEnabled = false
        queue.async {
            for _ in 0 ..< count {
                let data = Data(repeating: 1, count: bytes)
                do {
                    let url = self.documentUrl.appendingPathComponent(UUID().uuidString)
                    print("write dummy file into => \(url)")
                    try data.write(to: url)
                } catch {
                    print("write dummy file failed => \(error)")
                }
            }

            DispatchQueue.main.async {
                sender.isEnabled = true
                self.activityIndicator.stopAnimating()
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        return true
    }
}

