//
//  ViewController.swift
//  TipListViewDemo
//
//  Created by tezwez on 2019/10/10.
//  Copyright © 2019 tezwez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var pageVM: DCPageVM = {
        return DCPageVM<YXTipTableViewCell, UITableViewCell, String>()
    }()
    
    let kTipCellIdentify = "YXTipTableViewCell"
    let kCellIdentify = "UITableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(tableView)
        tableView.frame = self.view.bounds
        
        YXTipTableViewCell.register(for: tableView, identify: kTipCellIdentify)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellIdentify)
        
        
        self.pageVM.pageState = DCPageState.generate(list: ["quickTable", "groupTable", "commonTable"])
    }

    
}
 
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageVM.dcp_quickTableNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return pageVM.dcp_quickTableCellForRowAt(indexPath: indexPath, tableView: tableView, tipCellIdentify: kTipCellIdentify, cellIdentify: kCellIdentify) { (cell, text) -> UITableViewCell in
            cell.textLabel?.text = text
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pageVM.dcp_quickTableDidSelectRowAt(indexPath: indexPath) { (txt) in
            if let text = txt{
                let ctrl = DetailViewController()
                if text == "groupTable" {
                    ctrl.type = .group
                } else if text == "quickTable"{
                    ctrl.type = .quick
                } else {
                    ctrl.type = .common
                }
                let nav = UINavigationController(rootViewController: ctrl)
                nav.modalPresentationStyle = .fullScreen
                ctrl.title = text
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
}

