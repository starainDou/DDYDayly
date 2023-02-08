//
//  DDVerifyDetailVC.swift
//  elevator
//
//  Created by ddy on 2023/1/30.
//

import UIKit
import SwiftyJSON
import ProgressHUD

class DDVerifyDetailVC: UIViewController {

    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Verify Lift Details"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var scrollView: UIScrollView = UIScrollView()
    
    private lazy var topView: DDVerifyDetailTopView = DDVerifyDetailTopView()
    
    private lazy var mapView: DDVerifyDetailMapView = DDVerifyDetailMapView()
    
    private lazy var infoView: DDVerifyDetailInfoView = DDVerifyDetailInfoView().then {
        $0.nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
    }
    
    public var liftModel: DDLiftModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, scrollView)
        scrollView.addSubviews(topView, mapView, infoView)
        setViewConstraints()
        loadData()
    }
    
    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        scrollView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
        }
        topView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(10)
            make.width.equalTo(DDScreen.width - 30)
            make.height.equalTo(123)
        }
        mapView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(223)
            make.top.equalTo(topView.snp.bottom).offset(10)
        }
        infoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(35)
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextAction() {
        let vc = DDInstallImageVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func refreshView() {
        topView.loadData(liftModel)
        mapView.loadData(liftModel)
        infoView.loadData(liftModel)
    }
    
    private func loadData() {
        guard let leftId = liftModel?.id else { return }
        DDPost(target: .getLiftDetail(liftId: leftId), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            ProgressHUD.dismiss()
            self?.liftModel = DDLiftModel(liftDetail: JSON(result)["data"])
            self?.refreshView()
        }, failure: { [weak self] code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
            
        })
    }
}
