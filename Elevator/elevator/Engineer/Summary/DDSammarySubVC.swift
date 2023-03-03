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
import EmptyDataSet_Swift

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
        $0.emptyDataSetSource = self
        $0.emptyDataSetDelegate = self
    }
    
    private(set) lazy var dataArray: [JSON] = []
    
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
        
        ProgressHUD.show(interaction: false)
        DDGet(target: .summaryOfLiftPerformance(summaryType: "\(summaryType)", showType: "1"), success: { [weak self] result, msg in
            ProgressHUD.dismiss()
            self?.reloadTableView(JSON(result)["data"])
        }, failure: { code, msg in
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
        })
    }
    
    private func reloadTableView(_ json: JSON) {
        dataArray = json["values"].arrayValue
        headerView.rightLabel.text = json["total"].stringValue
        tableView.reloadData()
    }
}


extension DDSammarySubVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section]["isFold"].boolValue ? 0 : dataArray[section]["values"].arrayValue.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = DDSummarySectionHeader()
        header.loadData(dataArray[section], isFold: dataArray[section]["isFold"].boolValue, action: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.dataArray[section]["isFold"].bool = !weakSelf.dataArray[section]["isFold"].boolValue
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


extension DDSammarySubVC: EmptyDataSetSource, EmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "Icon218")
    }
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        loadData()
    }
}
