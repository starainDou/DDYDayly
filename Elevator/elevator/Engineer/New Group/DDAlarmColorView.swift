//
//  DDAlarmColorView.swift
//  elevator
//
//  Created by ddy on 2023/3/4.
//

import UIKit
import SwiftyJSON

class DDAlarmColorView: UIView {

    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.rowHeight = 30
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.keyboardDismissMode = .onDrag
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
        $0.ddy_zeroPadding()
        $0.ddy_register(cellClass: InnerCell.self)
    }
    
    private lazy var dataArray: [JSON] = []

    private var actionBlock: ((JSON, Int) -> Void)?
    
    private var targetPoint: CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: DDScreen.bounds)
        backgroundColor = UIColor(hex: "#666666").withAlphaComponent(0.75)
        addSubviews(backView, tableView)
        dataArray = [JSON(["title":"OK", "color":"#00FF00"]), JSON(["title":"Clear", "color":"#1ECAA1"]),
                     JSON(["title":"Debug", "color":"#0000FF"]), JSON(["title":"Info", "color":"#FBD232"]),
                     JSON(["title":"Minor", "color":"#FF974C"]), JSON(["title":"Major", "color":"#FE5151"]),
                     JSON(["title":"Critical", "color":"#333333"]), JSON(["title":"Unknown", "color":"#CCCCCC"])]
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewsConstraint() {
        backView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(DDScreen.width - targetPoint.x)
            make.top.equalToSuperview().inset(targetPoint.y)
            make.width.equalTo(100)
            make.height.equalTo(min(CGFloat(10 + 30 * dataArray.count), DDScreen.height - 120))
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(backView).inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
    }
    @objc private func hideAction() {
        removeFromSuperview()
    }
    
    static func show(in inView: UIView, point: CGPoint, action: ((JSON, Int) -> Void)? = nil) {
        let listView = DDAlarmColorView()
        inView.addSubview(listView)
        listView.targetPoint = point
        listView.actionBlock = action
        listView.setViewsConstraint()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        removeFromSuperview()
    }
}



extension DDAlarmColorView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ddy_dequeueReusableCell(InnerCell.self, for: indexPath)
        cell.loadData(dataArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        actionBlock?(dataArray[indexPath.row], indexPath.item)
        removeFromSuperview()
    }
}

fileprivate class InnerCell: UITableViewCell {
    private lazy var titleLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "333333")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    private lazy var colorView: UIView = UIView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(titleLabel, colorView)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualToSuperview().inset(5)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(colorView.snp.leading).offset(-10)
        }
        colorView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(5)
            make.width.height.equalTo(8)
        }
    }
    
    func loadData(_ json: JSON) {
        titleLabel.text = json["title"].stringValue
        colorView.backgroundColor = UIColor(hex: json["color"].stringValue)
    }
}
