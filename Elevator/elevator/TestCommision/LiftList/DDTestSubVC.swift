//
//  DDTestSubVC.swift
//  elevator
//
//  Created by ddy on 2023/2/6.
//

import UIKit
import DDYSwiftyExtension
import JXSegmentedView
import ProgressHUD
import SwiftyJSON
import MJRefresh

class DDTestSubVC: UIViewController {

    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 170
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
        $0.ddy_zeroPadding()
        $0.ddy_register(cellClass: DDTestCell.self)
        $0.keyboardDismissMode = .onDrag
    }
    
    private(set) lazy var dataArray: [JSON] = []
    
    var sensorJson: JSON?
    
    var tagIndex: Int = 0
    
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(tableView)
        setViewConstraints()
        setupRefresh()
        loadData()
    }
    
    private func setViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadData() {
        DDGet(target: .getLiftsBystatus(status: "\(tagIndex)", page: "\(page)", limit: "20"), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            ProgressHUD.dismiss()
            if let `self` = self {
                if (self.page == 1) {
                    self.dataArray = []
                }
                let data = JSON(result)["data"]
                self.dataArray += data["rows"].arrayValue
                if self.dataArray.count < data["total"].intValue || data["rows"].arrayValue.count < 20 {
                    self.page += 1
                }
            }
            self?.tableView.reloadData()
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
        }, failure: { [weak self] code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
        })
    }
    
    private func setupRefresh() {
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            self?.page = 1
            self?.loadData()
        })
        // 上拉加载更多
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [weak self] in
            self?.loadData()
        })
    }
}


extension DDTestSubVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ddy_dequeueReusableCell(DDTestCell.self, for: indexPath)
        let json = dataArray[indexPath.row]
        cell.loadData(json: json, tag: tagIndex)
        cell.detailBlock = { [weak self] in
            let vc = DDMainteDetailVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        cell.downloadBlock = { [weak self] in
            self?.loadPdf(json)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tagIndex == 0 {
            ProgressHUD.showFailed("Sorry, you don't have permission", interaction: false, delay: 3)
        } else if tagIndex == 4 {
            let vc = DDCommisionVC()
            vc.load(json: dataArray[indexPath.row], tag: tagIndex)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension DDTestSubVC {
    fileprivate func loadPdf(_ json: JSON) {
        let liftNum = json["liftnumber"].stringValue
        let fileName = "Report-" + liftNum + ".pdf"
        let dateVal = "" //DDAppInfo.dateStr(DDAppInfo.timeStamp(), dateFormat: "yyyy-MM") ?? ""
        let path = DDAppInfo.ducumentPath + "/getAppTcReport/" + fileName
        guard !FileManager.default.fileExists(atPath: path) else { return previewPdf(path, fileName) }
        ProgressHUD.show("Downloading")
        DDDownload(target: .getTcReport(fileName: fileName, liftNumber: liftNum, mapImgBase64: "", dateVal: dateVal), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            if FileManager.default.fileExists(atPath: path) {
                ProgressHUD.dismiss()
                self?.previewPdf(path, fileName)
            } else {
                ProgressHUD.showFailed("Fail", interaction: false, delay: 3)
            }
        }, failure: { [weak self] code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            if FileManager.default.fileExists(atPath: path) {
                ProgressHUD.dismiss()
                self?.previewPdf(path, fileName)
            } else {
                ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
            }
        })
    }
    
    fileprivate func previewPdf(_ path: String,_ fileName: String) {
        let vc = DDDocumentPreviewVC()
        vc.loadData(path, fileName)
        navigationController?.pushViewController(vc, animated: true)
    }
}
