//
//  DetailViewController.swift
//  TipListViewDemo
//
//  Created by tezwez on 2019/10/11.
//  Copyright © 2019 tezwez. All rights reserved.
//

import UIKit

class QuickTableVM: NSObject, UITableViewDelegate, UITableViewDataSource{
    
    let kTipCellIdentify = "YXTipTableViewCell"
    let kCellIdentify = "UITableViewCell"
    
    lazy var pageVM: DCPageVM = {
        return DCPageVM<YXTipTableViewCell, UITableViewCell, String>()
    }()
    
    func register(tableView: UITableView){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellIdentify)
        tableView.register(YXTipTableViewCell.self, forCellReuseIdentifier: kTipCellIdentify)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageVM.dcp_quickTableNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return pageVM.dcp_quickTableCellForRowAt(indexPath: indexPath, tableView: tableView, tipCellIdentify: kTipCellIdentify, cellIdentify: kCellIdentify) { (cell, text) -> UITableViewCell in
            cell.textLabel?.text = text
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return pageVM.dcp_quickTableHeightForRowAt(indexPath: indexPath) { (data) -> CGFloat in
            if data == nil {
                return 400
            } else {
                return 44
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pageVM.dcp_quickTableDidSelectRowAt(indexPath: indexPath) { (txt) in
            if let text = txt{
                print(text)
            }
        }
    }
}

class GroupTableVM: NSObject, UITableViewDelegate, UITableViewDataSource{
    
    let kTipCellIdentify = "YXTipTableViewCell"
    let kCellIdentify = "UITableViewCell"
    
    lazy var pageVM: DCPageVM = {
        return DCPageVM<YXTipTableViewCell, UITableViewCell, String>()
    }()

    func register(tableView: UITableView){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellIdentify)
        tableView.register(YXTipTableViewCell.self, forCellReuseIdentifier: kTipCellIdentify)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pageVM.dcp_commonTableNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageVM.dcp_groupTableNumberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return pageVM.dcp_groupTableCellForRowAt(indexPath: indexPath, tableView: tableView, tipCellIdentify: kTipCellIdentify, cellIdentify: kCellIdentify) { (cell, text) -> UITableViewCell in
            cell.textLabel?.text = text
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        view.backgroundColor = UIColor.init(hexColor: "#f7f7f7")
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pageVM.dcp_groupTableDidSelectRowAt(indexPath: indexPath) { (txt) in
            if let text = txt{
                print(text)
            }
        }
    }
}

class CommonTableVM: NSObject, UITableViewDelegate, UITableViewDataSource{
    
    let kTipCellIdentify = "YXTipTableViewCell"
    let kCellIdentify1 = "UITableViewCell"
    let kCellIdentify2 = "UITableViewCell"
    let kCellIdentify3 = "UITableViewCell"
    
    lazy var pageVM: DCPageVM = {
        return DCPageVM<YXTipTableViewCell, UITableViewCell, String>()
    }()

    func register(tableView: UITableView){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellIdentify1)
        tableView.register(YXTipTableViewCell.self, forCellReuseIdentifier: kTipCellIdentify)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageVM.dcp_quickTableNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return pageVM.dcp_commonTableCell(tipConfig: { (msg, image, isReload) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: kTipCellIdentify) as! YXTipTableViewCell
            cell.imageSize = CGSize(width: 145, height: 126)
            cell.imageTopSapce = 158
            if isReload ?? false {
                cell.isShowButton = true
                cell.btnBackground = .color(UIColor.clear)
                cell.btnTitleFontSize = 12
                cell.buttonTop = 20
                cell.btnTitleColor = UIColor.init(hexColor: "#2DA1DB")
                cell.buttonAction = reloadData
            }
            cell.config = YXTipCellConfig(image: image ?? "no_data", desc: msg, buttonTitle: isReload == true ? "重试" : nil)
            return cell
        }) { (list) -> UITableViewCell in
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentify1)!
                cell.textLabel?.text = list?[indexPath.row] as? String
                return cell
            } else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentify2)!
                cell.textLabel?.text = list?[indexPath.row] as? String
                return cell
            } else{
                let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentify3)!
                cell.textLabel?.text = list?[indexPath.row] as? String
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return pageVM.dcp_commonTableHeight { (list) -> CGFloat in
            if list == nil{
                return 400
            }
            if indexPath.row == 0 {
                return 44
            } else if indexPath.row == 1{
                return 120
            } else{
                return 88
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pageVM.dcp_commonTableDidSelect { (li) in
            if let list = li{
                let txt = list[indexPath.row] as? String
                print(txt ?? "")
            }
        }
    }
    
    func reloadData(){
        print("reloadData")
    }
}


class DetailViewController: UIViewController {

    enum TableType {
        case quick
        case group
        case common
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.tableFooterView = UIView()
        return table
    }()
    
    var type: TableType = .quick
    
    let kTipCellIdentify = "YXTipTableViewCell"
    let kCellIdentify = "UITableViewCell"
    
    lazy var quickVM: QuickTableVM = {
        let vm = QuickTableVM()
        vm.register(tableView: tableView)
        return vm
    }()
    lazy var groupVM: GroupTableVM = {
        let vm = GroupTableVM()
        vm.register(tableView: tableView)
        return vm
    }()
    
    lazy var commonVM: CommonTableVM = {
        let vm = CommonTableVM()
        vm.register(tableView: tableView)
        return vm
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(tableView)
        tableView.frame = self.view.bounds
        
        switch type {
        case .quick:
            tableView.dataSource = quickVM
            tableView.delegate = quickVM
            
            quickVM.pageVM.pageState = DCPageState.generate(list:["大小", "大小", "大小", "大小", "大小"])
        case .group:
            tableView.dataSource = groupVM
            tableView.delegate = groupVM
            
            groupVM.pageVM.pageState = DCPageState.generate(list:[["大小", "大小", "大小", "大小", "大小"], ["大小", "大小", "大小", "大小", "大小"], ["大小", "大小", "大小", "大小", "大小"]])
        case .common:
            tableView.dataSource = commonVM
            tableView.delegate = commonVM
            commonVM.pageVM.pageState = DCPageState.generate(list:["大小", "大小", "大小", "大小", "大小"])
            
            break
        }
        
        
        let item = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(back))
        
        self.navigationItem.leftBarButtonItem = item
        
        let rightItem = UIBarButtonItem.init(title: "请求网络", style: .plain, target: self, action: #selector(request))
        
        self.navigationItem.rightBarButtonItem = rightItem
    }
    

    @objc func back(){
        self.dismiss(animated: true, completion: nil)
    }

    @objc func request(){
        
        switch type {
        case .quick:
            
            quickVM.pageVM.pageState = DCPageState.generate()
        case .group:
            groupVM.pageVM.pageState = DCPageState.generate()
        case .common:
            commonVM.pageVM.pageState = DCPageState.generate()
        }
        
        tableView.reloadData()
    }
}
