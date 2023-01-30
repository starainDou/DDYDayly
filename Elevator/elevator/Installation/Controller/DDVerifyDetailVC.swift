//
//  DDVerifyDetailVC.swift
//  elevator
//
//  Created by ddy on 2023/1/30.
//

import UIKit

class DDVerifyDetailVC: UIViewController {

    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Verify Lift Details"
    }
    
    private lazy var scrollView: UIScrollView = UIScrollView()
    
    private lazy var topView: DDVerifyDetailTopView = DDVerifyDetailTopView()
    
    private lazy var mapView: DDVerifyDetailMapView = DDVerifyDetailMapView()
    
    private lazy var infoView: DDVerifyDetailInfoView = DDVerifyDetailInfoView()
    
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
        setupClosure()
        topView.loadData(DDElevatorModel())
        mapView.loadData(DDElevatorModel())
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
            make.height.equalTo(200)
        }
    }
    
    // MARK:- 回调响应
    private func setupClosure() {
        navigationBar.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
}
