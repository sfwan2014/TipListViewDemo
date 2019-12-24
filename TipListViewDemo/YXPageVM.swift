//
//  DCPageVM.swift
//  DigitalClub
//
//  Created by tezwez on 2019/9/18.
//  Copyright © 2019 YUXI. All rights reserved.
//

import Foundation
import UIKit
enum DCPageState {
    case normal
    case noData(String?, String?, Bool?) // msg, icon, isReload
    case data([Any]?) // list
    
    static func generate(list:[Any]? = nil,
                         msg: String? = DCPageState.defaultDesc(),
                         image: String? = DCPageState.defaultIcon()) -> DCPageState{
        if list?.count ?? 0 > 0 {
            return DCPageState.data(list)
        } else {
            if image == self.defaultNoNetworkIcon() || image == defaultNeedAddIcon(){
                return DCPageState.noData(msg, image, true)
            }
            return DCPageState.noData(msg, image, false)
        }
    }
    
    static func defaultDesc() -> String?{
        return "暂无记录"
    }
    
    static func defaultIcon() -> String?{
        return "no_data"
    }
    
    static func defaultNoNetworkIcon() -> String?{
        return "no_network"
    }
    
    static func defaultNeedAddIcon() -> String?{
        return "nodata_folder"
    }
}

class DCPageVM<TipCell, Cell, Model>: NSObject{
    
    var pageState: DCPageState = .normal
    var reloadBlock: (() -> Void)?
}
// MARK: - tableView DataSource
extension DCPageVM{
    
    // MARK: - - plan
    
    /// 非分组tableView 调用
    func dcp_quickTableNumberOfRows() -> Int{
        switch pageState {
        case .normal:
            return 0
        case .noData(_, _, _):
            return 1
        case .data(let data):
            return data?.count ?? 0
        }
    }
    
    // MARK: - - - CellForRow
    /// 非分组tableView 调用
    ///  - 单一样式的cell
    func dcp_quickTableCellForRowAt(indexPath: IndexPath, tableView: UITableView,
                         tipCellIdentify: String, cellIdentify: String,
                         tipConfig:((_ tipCell: TipCell, _ config: YXTipCellConfig, _ isReload: Bool?) -> UITableViewCell)? = nil,
                         config: ((_ cell: Cell, _ model: Model?) -> UITableViewCell)) -> UITableViewCell{
        
        return self.dcp_commonTableCell(tipConfig: { (msg, image, isReload) -> UITableViewCell in
            if tipConfig == nil{
                let cell = tableView.dequeueReusableCell(withIdentifier: tipCellIdentify) as! YXTipTableViewCell
                cell.imageSize = CGSize(width: 74, height: 74)
                cell.imageTopSapce = 158
                cell.isShowButton = false
                if isReload ?? false {
                    cell.isShowButton = true
                    let bgColor = UIColor.theme
                    cell.btnBackground = .color(bgColor.withAlphaComponent(0.1))
                    cell.btnTitleFontSize = 14
                    cell.buttonTop = 20
                    cell.btnTitleColor = UIColor.blue
                    cell.buttonAction = reloadBlock
                }
                cell.backgroundColor = UIColor.clear
                cell.config = YXTipCellConfig(image: image ?? "no_data", desc: msg, buttonTitle: isReload == true ? "刷新" : nil)
                return cell
            } else{
                let cell = tableView.dequeueReusableCell(withIdentifier: tipCellIdentify) as! TipCell
                let config = YXTipCellConfig(image: image ?? "no_data", desc: msg)
                return tipConfig!(cell, config, isReload)
            }
        }, config: { (list) -> UITableViewCell in
            let array = list as? [Model]
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify) as! Cell
            let model = array?[indexPath.row]
            return config(cell, model)
        })
    }
    
    /// 一个tableView多个cell样式 (除去空白cell 含2个以上)
    func dcp_commonTableCell(
        tipConfig:((_ msg: String?, _ image: String?, _ isReload: Bool?) -> UITableViewCell),
        config: ((_ list: [Any]?) -> UITableViewCell)) -> UITableViewCell{
        switch pageState {
        case .normal:
            return UITableViewCell()
        case .noData(let msg, let image, let isReload):
            return tipConfig(msg, image, isReload)
        case .data(let data):
            return config(data)
        }
    }
    
    /// 非分组tableView 调用
    func dcp_quickTableHeightForRowAt(indexPath: IndexPath, config: ((_ model: Model?) -> CGFloat)) -> CGFloat {
        
        return self.dcp_commonTableHeight(config: { (list) -> CGFloat in
            let arr = list as? [Model]
            if arr != nil{
                return config(arr?[indexPath.row])
            } else{
                return config(nil)
            }
        })
    }
    
    func dcp_commonTableHeight(config: ((_ list: [Any]?) -> CGFloat)) -> CGFloat {
        switch pageState {
        case .data(let list):
            return config(list)
        default:
            return config(nil)
        }
    }
    
    func dcp_commonTableHeightForFooterInSection(_ section: Int, config: ((_ section: Int) -> CGFloat)) -> CGFloat{
        switch pageState {
        case .data(_):
            return config(section)
        default:
            return 0
        }
    }
    
    func dcp_commonTableHeightForHeaderInSection(_ section: Int, config: ((_ section: Int) -> CGFloat)) -> CGFloat{
        switch pageState {
        case .data(_):
            return config(section)
        default:
            return 0
        }
    }
    
    /// 非分组tableView 调用
    func dcp_quickTableDidSelectRowAt(indexPath: IndexPath, completeHandle: ((_ model: Model?) -> Void)) {
        return self.dcp_commonTableDidSelect(completeHandle: { (list) in
            let arr = list as? [Model]
            completeHandle(arr?[indexPath.row])
        })
    }
    
    func dcp_commonTableDidSelect(completeHandle: ((_ list: [Any]?) -> Void)) {
        switch pageState {
        case .data(let list):
            completeHandle(list)
        default:
            completeHandle(nil)
        }
    }
  
}

extension DCPageVM{
    // MARK: - - group
    func dcp_commonTableNumberOfSections() -> Int{
        switch pageState {
        case .normal:
            return 0
        case .noData(_, _, _):
            return 1
        case .data(let data):
            return data?.count ?? 0
        }
    }
    
    /// 获取组数, 分组tableView 调用
    func dcp_groupTableNumberOfSections() -> Int{
        return dcp_commonTableNumberOfSections()
    }
    /// 获取行数, 分组tableView 调用
    func dcp_groupTableNumberOfRows(section: Int, config: ((_ data: Any?) -> Int)? = nil) -> Int{
        switch pageState {
        case .normal:
            return 0
        case .noData(_, _, _):
            return 1
        case .data(let data):
            if config != nil {
                return config!(data)
            } else{
                let arr = data?[section] as? [Any]
                return arr?.count ?? 0
            }
            
        }
    }
    /// 分组tableView 调用
    func dcp_groupTableCellForRowAt(indexPath: IndexPath, tableView: UITableView,
                                   tipCellIdentify: String, cellIdentify: String,
                                   tipConfig:((_ tipCell: TipCell, _ config: YXTipCellConfig) -> UITableViewCell)? = nil,
                                   config: ((_ cell: Cell, _ model: Model?) -> UITableViewCell)) -> UITableViewCell{
        return self.dcp_commonTableCell(tipConfig: { (msg, image, isReload) -> UITableViewCell in
            if tipConfig == nil{
                let cell = tableView.dequeueReusableCell(withIdentifier: tipCellIdentify) as! YXTipTableViewCell
                cell.imageSize = CGSize(width: 145, height: 126)
                cell.imageTopSapce = 158
                cell.config = YXTipCellConfig(image: image ?? "search_no_data", desc: msg)
                return cell
            } else{
                let cell = tableView.dequeueReusableCell(withIdentifier: tipCellIdentify) as! TipCell
                let config = YXTipCellConfig(image: image ?? "search_no_data", desc: msg)
                return tipConfig!(cell, config)
            }
        }, config: { (list) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify) as! Cell
            let array = list?[indexPath.section] as? [Model]
            let model = array?[indexPath.row]
            return config(cell, model)
        })
    }
    /// 分组tableView 调用
    func dcp_groupTableHeightForRowAt(indexPath: IndexPath, config: ((_ model: Model?) -> CGFloat)) -> CGFloat {
        return self.dcp_commonTableHeight(config: { (list) -> CGFloat in
            let array = list?[indexPath.section] as? [Model]
            let model = array?[indexPath.row]
            return config(model)
        })
    }
    
    /// 分钟调用
    func dcp_groupTableTitleForHeaderInSection(_ section: Int, config: ((_ list: [Any]?) -> String?)) -> String? {
        switch pageState {
        case .data(let list):
            return config(list)
        default:
            return nil
        }
    }
    
    /// 分组tableView 调用
    func dcp_groupTableDidSelectRowAt(indexPath: IndexPath, completeHandle: ((_ model: Model?) -> Void)) {
        self.dcp_commonTableDidSelect { (list) in
            let array = list?[indexPath.section] as? [Model]
            let model = array?[indexPath.row]
            completeHandle(model)
        }
    }
}
// MARK: - - TableView Edit
extension DCPageVM{
    //返回编辑类型，滑动删除
    func dcp_commonTableEditingStyle(config:((_ list: [Any]?) -> UITableViewCell.EditingStyle)
        ) -> UITableViewCell.EditingStyle {
        switch pageState {
        case .data(let list):
            return config(list)
        default:
            return .none
        }
    }
    
    func dcp_quickTableEditingStyleForRowAtIndexPath(
        _ indexPath: NSIndexPath,
        config:((_ model: Model?) -> UITableViewCell.EditingStyle)
        ) -> UITableViewCell.EditingStyle {
        return self.dcp_commonTableEditingStyle(config: { (list) -> UITableViewCell.EditingStyle in
            let arr = list as? [Model]
            return config(arr?[indexPath.row])
        })
    }
    
    func dcp_commonTableCanEdit(config:((_ list: [Any]?) -> Bool)) -> Bool{
        switch pageState {
        case .data(let list):
            return config(list)
        default:
            return false
        }
    }
    
    func dcp_quickTableCanEditAt(indexPath: IndexPath, config:((_ model: Model?) -> Bool)) -> Bool{
        return self.dcp_commonTableCanEdit(config: { (list) -> Bool in
            let arr = list as? [Model]
            return config(arr?[indexPath.row])
        })
    }
    
    func dcp_commonTableTitleForDeleteConfirmationButton(config:((_ list: [Any]?) -> String?)) -> String?{
        switch pageState {
        case .data(let list):
            return config(list)
        default:
            return nil
        }
    }
    
    func dcp_commonTableDidCommit(editingStyle: UITableViewCell.EditingStyle, config:((_ style: UITableViewCell.EditingStyle, _ list: [Any]?) -> Void)){
        switch pageState {
        case .data(let list):
            config(editingStyle, list)
        default:
            break
        }
    }
    
    func dcp_quickTableDidCommitAt(indexPath: IndexPath,
                                   editingStyle: UITableViewCell.EditingStyle,
                                   config:((_ style: UITableViewCell.EditingStyle,
                                    _ model: Model?) -> Void)){
        self.dcp_commonTableDidCommit(editingStyle: editingStyle) { (editingStyle, list) in
            let arr = list as? [Model]
            config(editingStyle, arr?[indexPath.row])
        }
    }
    
    func dcp_commonTableMoveRowAt(fromIndexPath: IndexPath, to: IndexPath, config:((_ fromIndexPath: IndexPath, _ to: IndexPath, _ list: [Model]?) -> Void)?) {
        switch pageState {
        case .data(let list):
            config?(fromIndexPath, to, list as? [Model])
        default:
            break
        }
        
    }
    
    // Override to support conditional rearranging of the table view.
    func dcp_commonTableCanMoveRowAt(indexPath: IndexPath, config:((_ list: [Model]?) -> Bool)? = nil) -> Bool {
        switch pageState {
        case .data(let list):
            if config == nil {
                return true
            }
            return config!(list as? [Model])
        default:
            return false
        }
    }
    
//    @available(iOS 11.0, *)
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let action = UIContextualAction(style: .normal, title: "", handler: { (action, view, handle) in
//            self.deleteAction(indexPath, handle: handle)
//        })
//        action.image = UIImage(named: "my_collection_delete")
//        action.backgroundColor = UIColor.init(hexColor: "#E12C2C")
//        let config = UISwipeActionsConfiguration(actions: [action])
//        return config
//
//    }
}

// MARK:
// MARK:
// MARK: --------------------------------------------------------
// MARK: |--------------------collectionView--------------------|
// MARK: --------------------------------------------------------
// MARK: - collectionView DataSource
extension DCPageVM{
    // MARK: - Plan
    /// plan
    func dcp_collectionNumberOfItems() -> Int{
        switch pageState {
        case .normal:
            return 0
        case .noData(_, _, _):
            return 1
        case .data(let data):
            return data?.count ?? 0
        }
    }
    
    func dcp_collectionCellForRowAt(indexPath: IndexPath, collectionView: UICollectionView,
                         tipCellIdentify: String, cellIdentify: String,
                         tipConfig:((_ tipCell: TipCell, _ config: YXTipCellConfig, _ isReload: Bool?) -> UICollectionViewCell)? = nil,
                         config: ((_ cell: Cell, _ model: Model?) -> UICollectionViewCell)) -> UICollectionViewCell{
        switch pageState {
        case .normal:
            return UICollectionViewCell()
        case .noData(let msg, let image, let isReload):
            if tipConfig == nil{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tipCellIdentify, for: indexPath) as! YXTipCollectionViewCell
                cell.imageSize = CGSize(width: 145, height: 126)
                cell.imageTopSapce = 158
                cell.imageSize = CGSize(width: 145, height: 126)
                cell.imageTopSapce = 158
                if isReload ?? false {
                    cell.isShowButton = true
                    cell.btnBackground = .color(UIColor.clear)
                    cell.btnTitleFontSize = 12
                    cell.buttonTop = 20
                    cell.btnTitleColor = UIColor.init(hexColor: "#2DA1DB")
                    cell.buttonAction = reloadBlock
                }
                cell.config = YXTipCellConfig(image: image ?? "search_no_data", desc: msg, buttonTitle: isReload == true ? "重试" : nil)
                return cell
            } else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tipCellIdentify, for: indexPath)  as! TipCell
                let config = YXTipCellConfig(image: image ?? "search_no_data", desc: msg)
                return tipConfig!(cell, config, isReload)
            }
        case .data(let data):
            let array = data as? [Model]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentify, for: indexPath) as! Cell
            let model = array?[indexPath.row]
            return config(cell, model)
        }
    }
    
    func dcp_collectionSizeForRowAt(indexPath: IndexPath, config: ((_ model: Model?) -> CGSize)) -> CGSize {
        switch pageState {
        case .data(let list):
            let arr = list as? [Model]
            return config(arr?[indexPath.row])
        default:
            return config(nil)
        }
    }
    
    func dcp_collectionInsetForSection(at section: Int, config: ((_ section: Int) -> UIEdgeInsets)) -> UIEdgeInsets {
        switch pageState {
        case .data(_):
            return config(section)
        default:
            return UIEdgeInsets.zero
        }
    }
    
    func dcp_collectionHeaderSizeAt(section: Int, config: ((_ section: Int) -> CGSize)) -> CGSize {
        switch pageState {
        case .data(_):
            return config(section)
        default:
            return CGSize.init(width: 0, height: 0.0)
        }
    }
    
    func dcp_collectionDidSelectRowAt(indexPath: IndexPath, completeHandle: ((_ model: Model?) -> Void)) {
        switch pageState {
        case .data(let list):
            let arr = list as? [Model]
            completeHandle(arr?[indexPath.row])
        default:
            completeHandle(nil)
        }
    }

}

extension DCPageVM{
    // MARK: - Group
    /// group  分组调用
    /// 获取组数, 分组collectionView 调用
    func dcp_groupCollectionNumberOfSections() -> Int{
        switch pageState {
        case .normal:
            return 0
        case .noData(_, _, _):
            return 1
        case .data(let data):
            return data?.count ?? 0
        }
    }
    
    /// 获取组内单元格数, 分组collectionView 调用
    func dcp_groupCollectionNumberOfItems(section: Int) -> Int{
        switch pageState {
        case .normal:
            return 0
        case .noData(_, _, _):
            return 1
        case .data(let data):
            let arr = data?[section] as? [Any]
            return arr?.count ?? 0
        }
    }
    
    func dcp_groupCollectionCellForRowAt(indexPath: IndexPath, collectionView: UICollectionView,
                                        tipCellIdentify: String, cellIdentify: String,
                                        tipConfig:((_ tipCell: TipCell, _ config: YXTipCellConfig) -> UICollectionViewCell)? = nil,
                                        config: ((_ cell: Cell, _ model: Model?) -> UICollectionViewCell)) -> UICollectionViewCell{
        switch pageState {
        case .normal:
            return UICollectionViewCell()
        case .noData(let msg, let image, let isReload):
            if tipConfig == nil{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tipCellIdentify, for: indexPath) as! YXTipCollectionViewCell
                cell.imageSize = CGSize(width: 145, height: 126)
                cell.imageTopSapce = 158
                cell.imageSize = CGSize(width: 145, height: 126)
                cell.imageTopSapce = 158
                if isReload ?? false {
                    cell.isShowButton = true
                    cell.btnBackground = .color(UIColor.clear)
                    cell.btnTitleFontSize = 12
                    cell.buttonTop = 20
                    cell.btnTitleColor = UIColor.init(hexColor: "#2DA1DB")
                    cell.buttonAction = reloadBlock
                }
                cell.config = YXTipCellConfig(image: image ?? "search_no_data", desc: msg, buttonTitle: isReload == true ? "重试" : nil)
                return cell
            } else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tipCellIdentify, for: indexPath)  as! TipCell
                let config = YXTipCellConfig(image: image ?? "search_no_data", desc: msg)
                return tipConfig!(cell, config)
            }
        case .data(let list):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentify, for: indexPath) as! Cell
            let array = list?[indexPath.section] as? [Model]
            let model = array?[indexPath.row]
            return config(cell, model)
        }
    }
    
    func dcp_groupCollectionSizeForRowAt(indexPath: IndexPath, config: ((_ model: Model?) -> CGSize)) -> CGSize {
        switch pageState {
        case .data(let list):
            let array = list?[indexPath.section] as? [Model]
            let model = array?[indexPath.row]
            return config(model)
        default:
            return config(nil)
        }
    }
    
    func dcp_groupCollectionDidSelectRowAt(indexPath: IndexPath, completeHandle: ((_ model: Model?) -> Void)) {
        switch pageState {
        case .data(let list):
            let array = list?[indexPath.section] as? [Model]
            let model = array?[indexPath.row]
            completeHandle(model)
        default:
            completeHandle(nil)
        }
    }
}
