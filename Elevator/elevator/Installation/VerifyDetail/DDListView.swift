//
//  DDListView.swift
//  elevator
//
//  Created by ddy on 2023/2/15.
//

import UIKit
import SnapKit

class DDListView: UIView {
    
    private lazy var topButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "#66666666")
        $0.addTarget(self, action: #selector(hideAction), for: .touchUpInside)
    }

    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 6
    }

    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.rowHeight = 40
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.keyboardDismissMode = .onDrag
        $0.showsVerticalScrollIndicator = false
        $0.ddy_zeroPadding()
        $0.ddy_register(cellClass: InnerCell.self)
    }
    private lazy var dataArray: [String] = []
    private var actionBlock: ((String, Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: DDScreen.bounds)
        addSubviews(topButton, backView, tableView)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewsConstraint() {
        topButton.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(backView.snp.top).offset(6)
        }
        backView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(min(CGFloat(40 + 40 * dataArray.count), DDScreen.height - 120))
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(backView).inset(UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15))
        }
    }
    @objc private func hideAction() {
        removeFromSuperview()
    }
    
    static func show(in inView: UIView, array: [String], action: ((String, Int) -> Void)?) {
        let listView = DDListView()
        listView.dataArray = array
        listView.actionBlock = action
        listView.setViewsConstraint()
        inView.addSubview(listView)
    }
}

extension DDListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.ddy_dequeueReusableCell(InnerCell.self, for: indexPath).then {
            $0.load(dataArray[indexPath.row], isFirst: indexPath.row == 0)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        actionBlock?(dataArray[indexPath.row], indexPath.row)
        removeFromSuperview()
    }
}


fileprivate class InnerCell: UITableViewCell {
    private lazy var contentLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#999999")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    private lazy var lineView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#EEEEEE")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubviews(contentLabel, lineView)
        contentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        lineView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(0.6)
        }
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func load(_ title: String, isFirst: Bool) {
        lineView.isHidden = isFirst
        contentLabel.text = title
    }
}
