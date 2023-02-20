//
//  DDPdfVC.swift
//  elevator
//
//  Created by ddy on 2023/2/20.
//

import UIKit
import WebKit

class DDPdfVC: UIViewController {

    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "pdf"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var wkWebView: WKWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(navigationBar, wkWebView)
        setViewConstraints()
    }
    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        wkWebView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
        }
    }
    
    @objc private func backAction() {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    func dataSource(urlString:String){
        guard let url = URL(string: urlString) else { return}
        wkWebView.load(URLRequest(url: url))
    }
}
