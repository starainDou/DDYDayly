//
//  DDMainteDetail4PEU0View.swift
//  elevator
//
//  Created by ddy on 2023/2/26.
//

import UIKit

class DDMainteDetail4PEU0View: UIView {

    private lazy var titleLabel: UILabel = UILabel().then {
        $0.text = "PEU0 Components"
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 300
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.ddy_zeroPadding()
        $0.ddy_register(cellClass: DDMainteDetail4Cell.self)
    }
    
    private lazy var dataArray: [Array<String>] = [["Name", "Input", "HardWare\nVersion", "FirmWare\nVersion", "Health\nState"]]

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#FFFFFF")
        layer.cornerRadius = 8
        layer.masksToBounds = true
        addSubviews(titleLabel, tableView)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(22)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(30)
        }
    }
}

extension DDMainteDetail4PEU0View: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ddy_dequeueReusableCell(DDMainteDetail4Cell.self, for: indexPath)
        cell.loadData(dataArray[indexPath.row], isFirst: (indexPath.row == 0))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
