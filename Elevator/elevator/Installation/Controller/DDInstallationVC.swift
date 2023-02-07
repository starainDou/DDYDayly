//
//  DDInstallationVC.swift
//  elevator
//
//  Created by ddy on 2023/1/31.
//

import UIKit
import JXSegmentedView

class DDInstallationVC: UIViewController {
    
    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Lift Details"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var segmentView: DDInstallSegmentView = DDInstallSegmentView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.searchButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        $0.notInButton.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
        $0.notComButton.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
        $0.comButton.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
    }
    
    private lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.isScrollEnabled = false
    }
    
    private lazy var notInsVC: DDInstallSubVC = DDInstallSubVC().then {
        $0.tagIndex = 0
    }
    
    private lazy var notComVC: DDInstallSubVC = DDInstallSubVC().then {
        $0.tagIndex = 4
    }
    
    private lazy var comVC: DDInstallSubVC = DDInstallSubVC().then {
        $0.tagIndex = 5
    }
    
    var currentVC: DDInstallSubVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(navigationBar, segmentView, scrollView)
        scrollView.addSubviews(notInsVC.view, notComVC.view, comVC.view)
        addChildren(notInsVC, notComVC, comVC)
        setViewConstraints()
        currentVC = notInsVC
    }
    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        segmentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            make.height.equalTo(90)
        }
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(segmentView.snp.bottom)
        }
        notInsVC.view.snp.makeConstraints { make in
            make.width.equalTo(DDScreen.width)
            make.leading.top.bottom.equalToSuperview()
            make.top.equalTo(segmentView.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
        }
        notComVC.view.snp.makeConstraints { make in
            make.size.centerY.equalTo(notInsVC.view)
            make.leading.equalTo(notInsVC.view.snp.trailing)
        }
        comVC.view.snp.makeConstraints { make in
            make.size.centerY.equalTo(notInsVC.view)
            make.leading.equalTo(notComVC.view.snp.trailing)
            make.trailing.equalToSuperview()
        }
    }
    
    @objc private func backAction() {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func searchAction() {
        view.endEditing(true)
        guard let text = segmentView.textField.text else { return }
        guard let tempVC = currentVC else { return }
        let vc = DDInstallSearchVC()
        vc.loadData(tempVC.dataArray.filter { $0.number.contains(text)}, tag: tempVC.tagIndex)
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func selectAction(_ button: UIButton) {
        scrollView.setContentOffset(CGPoint(x: DDScreen.width * CGFloat(button.tag), y: 0), animated: true)
        [segmentView.notInButton, segmentView.notComButton, segmentView.comButton].forEach {
            $0.isSelected = ($0.tag == button.tag)
            $0.backgroundColor = UIColor(hex: ($0.tag == button.tag) ? "#168991" : "#DEDEE0")
        }
        currentVC = (button.tag == 0) ? notInsVC : (button.tag == 1 ? notComVC : comVC)
    }
}


