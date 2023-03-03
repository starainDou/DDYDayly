//
//  DDMainteDetail3VC.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import JXSegmentedView
import SwiftyJSON
import ProgressHUD
import EmptyDataSet_Swift
import MJRefresh

class DDMainteDetail3VC: UIViewController {
    
    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    private lazy var headerView: DDMainteDetail3Header = DDMainteDetail3Header()
    
    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 300
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.ddy_zeroPadding()
        $0.ddy_register(cellClass: DDMainteDetail3Cell.self)
        $0.emptyDataSetSource = self
        $0.emptyDataSetDelegate = self
    }
    
    private lazy var dataArray: [JSON] = []
    
    var liftBaseJson: JSON = JSON()
    
    private var page: Int = 1
    
    private lazy var time:(start: String, end: String) = ("", "") {
        didSet {
            guard let time00 = DDAppInfo.dateStr(time.start, dateFormat: "yyyy/MM/dd") else { return }
            guard let time24 = DDAppInfo.dateStr(time.end, dateFormat: "yyyy/MM/dd") else { return }
            headerView.textLabel.text = "\(time00)-\(time24)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(backView)
        backView.addSubviews(headerView, tableView)
        setViewConstraints()
        setupRefresh()
        baseInit()
        loadData(restart: true)
    }
    
    private func setViewConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 15, bottom: 30, right: 15))
        }
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    private func setupRefresh() {
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            self?.loadData(restart: true)
        })
        // 上拉加载更多
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [weak self] in
            self?.loadData(restart: false)
        })
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func baseInit() {
        headerView.timeButton.addTarget(self, action: #selector(timeAction), for: .touchUpInside)
        headerView.nameLabel.text = liftBaseJson["liftnumber"].stringValue
        guard let today = DDAppInfo.dateStr(DDAppInfo.timeStamp(), dateFormat: "yyyy-MM-dd") else { return }
        guard let date = DateFormatter().then({ $0.dateFormat = "yyyy-MM-dd" }).date(from: today) else { return }
        time = (String(Int(date.timeIntervalSince1970 * 1000) - 86400000), String(Int(date.timeIntervalSince1970 * 1000)))

  
//        print("66666 \(DDAppInfo.timeStamp()) \(time00) \(time24)")
//        guard let today00 = DDAppInfo.dateStr(time00, dateFormat: "yyyy-MM-dd HH-mm-ss") else { return }
//        guard let today24 = DDAppInfo.dateStr(time24, dateFormat: "yyyy-MM-dd HH-mm-ss") else { return }
//        print("66666 \(today) \(today00) \(today24)")
    }
    @objc private func timeAction() {
        DDDoubleDatePicker.show(in: view, date: time, sure: { [weak self] (start, end) in
            self?.time = (start, end)
            self?.loadData(restart: true)
        })
    }
    
    func loadData(restart: Bool) {
        guard let userId = DDShared.shared.json?["user"]["id"].stringValue else { return }
        let liftNumber = liftBaseJson["liftnumber"].stringValue
        if restart {
            page = 1
        }
        DDPost(target: .getSingleRide2(liftnumber: liftNumber, starttime: time.start, endtime: time.end, userid: userId, page: "\(page)", limit: "20"), success: { [weak self] result, msg in
            ProgressHUD.dismiss()
            if let `self` = self {
                if (self.page == 1) {
                    self.dataArray = []
                }
                let array = JSON(result)["data"].arrayValue
                self.dataArray += array
                if array.count >= 20 {
                    self.page += 1
                }
            }
            self?.tableView.reloadData()
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
        }, failure: { [weak self] code, msg in
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
        })
    }
}

extension DDMainteDetail3VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ddy_dequeueReusableCell(DDMainteDetail3Cell.self, for: indexPath)
        var json = dataArray[indexPath.row]
        cell.loadData(json, action: { [weak self] in
            self?.dataArray[indexPath.row]["isFold"].bool = !json["isFold"].boolValue
            let json2 = self?.dataArray[indexPath.row]
            self?.tableView.reloadData()
        })
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension DDMainteDetail3VC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}


extension DDMainteDetail3VC: EmptyDataSetSource, EmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "Icon218")
    }
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        loadData(restart: true)
    }
}

