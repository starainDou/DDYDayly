//
//  DDSammarySubVC.swift
//  elevator
//
//  Created by ddy on 2023/2/14.
//

import UIKit
import SwiftyJSON
import JXSegmentedView
import ProgressHUD

class DDSammarySubVC: UIViewController {
    
    private lazy var headerView = DDSummaryHeader(frame: CGRect(x: 0, y: 0, width: DDScreen.width, height: 47))
    
    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.tableHeaderView = headerView
        $0.tableFooterView = UIView()
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 50
        $0.separatorStyle = .none
        $0.estimatedSectionHeaderHeight = 50
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.sectionFooterHeight  = 1
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
        $0.showsVerticalScrollIndicator = false
        $0.ddy_zeroPadding()
        $0.ddy_register(cellClass: DDSammaryCell.self)
        $0.keyboardDismissMode = .onDrag
    }
    
    private(set) lazy var dataArray: [JSON] = []
    
    private var selectIndex: Int?
    
    var summaryType: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#01F5FF")
        view.addSubviews(tableView)
        setViewConstraints()
        loadData()
    }
    
    private func setViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func loadData() {
//        guard let url = Bundle.main.url(forResource: "Local", withExtension: "json") else { return }
//        guard let data = try? Data(contentsOf: url), let str = String(data: data, encoding: .utf8) else { return }
//        let json = JSON(parseJSON: str)
//        dataArray = json["data"]["values"].arrayValue
//        headerView.rightLabel.text = json["data"]["total"].stringValue
//        tableView.reloadData()
        
        ProgressHUD.show()
        DDGet(target: .summaryOfLiftPerformance(summaryType: "\(summaryType)", showType: "1"), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            ProgressHUD.dismiss()
            let json = JSON(result)
            self?.dataArray = json["data"]["values"].arrayValue
            self?.headerView.rightLabel.text = json["data"]["total"].stringValue
            self?.tableView.reloadData()
        }, failure: { code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
        })
    }
}


extension DDSammarySubVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == selectIndex ? dataArray[section]["values"].arrayValue.count : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = DDSummarySectionHeader()
        header.loadData(dataArray[section], isSelected: section == selectIndex, action: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.selectIndex = (section == weakSelf.selectIndex) ? -1 : section
            weakSelf.tableView.reloadData()
        })
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return DDSummarySectionFooter()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.ddy_dequeueReusableCell(DDSammaryCell.self, for: indexPath).then {
            $0.loadData(dataArray[indexPath.section]["values"].arrayValue[indexPath.row])
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension DDSammarySubVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
