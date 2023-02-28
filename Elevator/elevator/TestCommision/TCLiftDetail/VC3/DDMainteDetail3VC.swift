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

class DDMainteDetail3VC: UIViewController {
    
    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 300
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.ddy_zeroPadding()
        $0.ddy_register(cellClass: DDMainteDetail3Cell.self)
        $0.emptyDataSetSource = self
        $0.emptyDataSetDelegate = self
    }
    
    private lazy var dataArray: [JSON] = []
    
    var liftBaseJson: JSON = JSON()
    
    private lazy var startTime: String = ""
    
    private lazy var endTime: String = ""
    
    var page: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(tableView)
        setViewConstraints()
        timeInit()
        loadData()
    }
    
    private func setViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func timeInit() {
        guard let today = DDAppInfo.dateStr(DDAppInfo.timeStamp(), dateFormat: "yyyy-MM-dd") else { return }
        guard let date = DateFormatter().then({ $0.dateFormat = "yyyy-MM-dd" }).date(from: today) else { return }
        startTime = String(Int(date.timeIntervalSince1970 * 1000) - 86400000 )
        endTime = String(Int(date.timeIntervalSince1970 * 1000))
  
//        print("66666 \(DDAppInfo.timeStamp()) \(time00) \(time24)")
//        guard let today00 = DDAppInfo.dateStr(time00, dateFormat: "yyyy-MM-dd HH-mm-ss") else { return }
//        guard let today24 = DDAppInfo.dateStr(time24, dateFormat: "yyyy-MM-dd HH-mm-ss") else { return }
//        print("66666 \(today) \(today00) \(today24)")
    }
    
//    - (void)timeStrTest{
//
//        // 时间戳字符串+时间格式
//        NSString * createTimeStr = @"1320805779000";
//        NSString * formatStr = @"YYYY-MM-dd";
//
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//        [dateFormatter setDateFormat:formatStr];
//
//        NSTimeInterval time = [createTimeStr doubleValue] / 1000 ;
//        NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time] ;
//        NSString *currentTimeString = [dateFormatter stringFromDate: detaildate];
//        NSDate* result = [dateFormatter dateFromString:currentTimeString];
//
//        // 计算零点时间戳
//        NSTimeInterval timeZreoInt=[result timeIntervalSince1970] * 1000;
//        NSString *timeZreoString = [NSString stringWithFormat:@"%.0f", timeZreoInt];
//
//        // 计算二十四点时间戳
//        NSTimeInterval timeTenInt = timeZreoInt + 86400000;
//        NSString *timeTenString = [NSString stringWithFormat:@"%.0f", timeTenInt];
//
//        NSLog(@"%@===%@===KK",timeZreoString,timeTenString);
//    }
    
    func loadData2() {
        let liftNumber = liftBaseJson["liftnumber"].stringValue
        DDPost(target: .getSingleRide(liftnumber: liftNumber, daterange: [startTime, endTime]), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            ProgressHUD.dismiss()
            self?.dataArray = JSON(result)["data"]["exportDatas"].arrayValue
            self?.tableView.reloadData()
        }, failure: { [weak self] code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
        })
    }
    
    func loadData() {
        guard let userId = DDShared.shared.json?["user"]["id"].stringValue else { return }
        let liftNumber = liftBaseJson["liftnumber"].stringValue
        DDPost(target: .getSingleRide2(liftnumber: liftNumber, starttime: startTime, endtime: endTime, userid: userId, page: "\(page)", limit: "10"), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            ProgressHUD.dismiss()
            self?.dataArray = JSON(result)["data"]["exportDatas"].arrayValue
            self?.tableView.reloadData()
        }, failure: { [weak self] code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
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
            json["isFold"].bool = !json["isFold"].boolValue
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
        loadData()
    }
}

