//
//  FilesManageViewController.swift
//  iOSDummy
//
//  Created by yin.yan on 2019/09/02.
//  Copyright © 2019 Leon.yan. All rights reserved.
//

import Foundation
import UIKit

class FilesManageViewController: UITableViewController {
    private lazy var documentUrl: URL = {
        guard let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            fatalError("Error when get documentDirectory")
        }
        return url
    }()

    private var subPaths: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            subPaths = try FileManager.default.subpathsOfDirectory(atPath: documentUrl.path)
            print(subPaths)
        } catch {
            print("error => \(error)")
        }
        tableView.setEditing(true, animated: false)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subPaths.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }

        cell?.textLabel?.text = subPaths[indexPath.row]
        do {
            let subPath = subPaths[indexPath.row]
            let subFullPath = documentUrl.appendingPathComponent(subPath).path
            let attributes = try FileManager.default.attributesOfItem(atPath: subFullPath)
            let fileSize = (attributes[.size] as? Int64) ?? -1
            cell?.detailTextLabel?.text = "\(fileSize)"
        } catch {

        }
        return cell!
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        do {
            let subPath = subPaths[indexPath.row]
            let subFullPath = documentUrl.appendingPathComponent(subPath)
            try FileManager.default.removeItem(at: subFullPath)
            subPaths.remove(at: indexPath.row)
            tableView.reloadData()
        } catch {

        }
    }
}
