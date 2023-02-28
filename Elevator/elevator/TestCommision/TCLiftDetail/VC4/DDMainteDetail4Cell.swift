//
//  DDMainteDetail4Cell.swift
//  elevator
//
//  Created by ddy on 2023/2/28.
//

import UIKit

class DDMainteDetail4Cell: UITableViewCell {
    
    private lazy var item1Label: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    private lazy var item2Label: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    private lazy var item3Label: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    private lazy var item4Label: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    private lazy var item5Label: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    private lazy var topLineView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#7C80B8")
    }
    private lazy var bottomLineView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#7C80B8")
    }
    private lazy var line1View: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#7C80B8")
    }
    private lazy var line2View: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#7C80B8")
    }
    private lazy var line3View: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#7C80B8")
    }
    private lazy var line4View: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#7C80B8")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(item1Label, item2Label, item3Label, item4Label, item5Label)
        contentView.addSubviews(line1View, line2View, line3View, line4View, topLineView, bottomLineView)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        topLineView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1)
        }
        item1Label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo((DDScreen.width - 34) / 5.0)
        }
        line1View.snp.makeConstraints { make in
            make.leading.equalTo(item1Label.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        item2Label.snp.makeConstraints { make in
            make.leading.equalTo(line1View.snp.trailing)
            make.centerY.equalToSuperview()
            make.width.equalTo((DDScreen.width - 34) / 5.0)
        }
        line2View.snp.makeConstraints { make in
            make.leading.equalTo(item2Label.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        item3Label.snp.makeConstraints { make in
            make.leading.equalTo(line2View.snp.trailing)
            make.centerY.equalToSuperview()
            make.width.equalTo((DDScreen.width - 34) / 5.0)
        }
        line3View.snp.makeConstraints { make in
            make.leading.equalTo(item3Label.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        item4Label.snp.makeConstraints { make in
            make.leading.equalTo(line3View.snp.trailing)
            make.centerY.equalToSuperview()
            make.width.equalTo((DDScreen.width - 34) / 5.0)
        }
        line4View.snp.makeConstraints { make in
            make.leading.equalTo(item4Label.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        item5Label.snp.makeConstraints { make in
            make.leading.equalTo(line4View.snp.trailing)
            make.centerY.equalToSuperview()
            make.width.equalTo((DDScreen.width - 34) / 5.0)
        }
        bottomLineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    public func loadData(_ datas:[String], isFirst: Bool) {
        topLineView.isHidden = !isFirst
        item1Label.text = datas[0]
        item2Label.text = datas[1]
        item3Label.text = datas[2]
        item4Label.text = datas[3]
        item5Label.text = datas[4]
        backgroundColor = UIColor(hex: isFirst ? "#DCDFFF" : "#FFFFFF")
        
    }
}
