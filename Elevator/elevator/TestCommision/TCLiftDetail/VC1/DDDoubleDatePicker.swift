//
//  DDDoubleDatePicker.swift
//  elevator
//
//  Created by ddy on 2023/2/26.
//

import UIKit

class DDDoubleDatePicker: UIView {
    
    private var sureBlock: ((String, String) -> Void)?
    
    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    
    private lazy var cancelButton: UIButton = UIButton().then  {
        $0.setTitle("Cancel", for: .normal)
        $0.setTitleColor(UIColor(hex: "#999999"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    }
    
    private lazy var sureButton: UIButton = UIButton().then  {
        $0.setTitle("OK", for: .normal)
        $0.setTitleColor(UIColor(hex: "#1792AC"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
    }
    
    private lazy var fromLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#999999")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.text = "Start Date"
    }
    
    private lazy var endLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#999999")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.text = "End Date"
    }
    
    private lazy var fromPicker: UIDatePicker = UIDatePicker().then {
        $0.locale = Locale.current
        $0.datePickerMode = .date
        $0.setDate(Date(), animated: true)
        if #available(iOS 13.4, *) {
            $0.preferredDatePickerStyle = .wheels
        }
    }
    
    private lazy var endPicker: UIDatePicker = UIDatePicker().then {
        $0.locale = Locale.current
        $0.datePickerMode = .date
        $0.setDate(Date(), animated: true)
        if #available(iOS 13.4, *) {
            $0.preferredDatePickerStyle = .wheels
        }
    }

    override init(frame: CGRect) {
        super.init(frame: DDScreen.bounds)
        backgroundColor = UIColor(hex: "#66666666")
        addSubviews(backView, cancelButton, sureButton, fromPicker, endPicker, fromLabel, endLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        backView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(256)
        }
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalTo(backView).inset(10)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        sureButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(backView).inset(10)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        fromPicker.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.trailing.equalTo(backView.snp.centerX)
            make.height.equalTo(216)
        }
        endPicker.snp.makeConstraints { make in
            make.leading.equalTo(backView.snp.centerX)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(216)
        }
        fromLabel.snp.makeConstraints { make in
            make.centerX.equalTo(fromPicker)
            make.bottom.equalTo(fromPicker.snp.top).offset(-5)
        }
        endLabel.snp.makeConstraints { make in
            make.centerX.equalTo(endPicker)
            make.bottom.equalTo(endPicker.snp.top).offset(-5)
        }
    }
    
    public static func show(in inView: UIView, sure: @escaping ((String, String) -> Void)) {
        let view = DDDoubleDatePicker()
        view.sureBlock = sure
        inView.addSubview(view)
    }
    
    @objc private func cancelAction() {
        removeFromSuperview()
    }
    
    @objc private func sureAction() {
        sureBlock?(String(Int(fromPicker.date.timeIntervalSince1970 * 1000)), String(Int(fromPicker.date.timeIntervalSince1970 * 1000)))
        removeFromSuperview()
    }
}

