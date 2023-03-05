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
        $0.addTarget(self, action: #selector(pickerAction(_:)), for: .valueChanged)
        if #available(iOS 13.4, *) {
            $0.preferredDatePickerStyle = .wheels
        }
    }
    
    private lazy var endPicker: UIDatePicker = UIDatePicker().then {
        $0.locale = Locale.current
        $0.datePickerMode = .date
        $0.setDate(Date(), animated: true)
        $0.addTarget(self, action: #selector(pickerAction(_:)), for: .valueChanged)
        if #available(iOS 13.4, *) {
            $0.preferredDatePickerStyle = .wheels
        }
    }

    override init(frame: CGRect) {
        super.init(frame: DDScreen.bounds)
        backgroundColor = UIColor(hex: "#666666").withAlphaComponent(0.75)
        addSubview(backView)
        backView.addSubviews(cancelButton, sureButton, fromPicker, endPicker, fromLabel, endLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        backView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(520)
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
        fromLabel.snp.makeConstraints { make in
            make.centerX.equalTo(fromPicker)
            make.top.equalTo(cancelButton.snp.bottom).offset(8)
        }
        fromPicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(fromLabel.snp.bottom).offset(-2)
            make.height.equalTo(216)
        }
        endLabel.snp.makeConstraints { make in
            make.centerX.equalTo(endPicker)
            make.top.equalTo(fromPicker.snp.bottom).offset(8)
        }
        endPicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(endLabel.snp.bottom).offset(-2)
            make.height.equalTo(216)
        }
    }
    
    public static func show(in inView: UIView, date:(start: String, end: String), sure: @escaping ((String, String) -> Void)) {
        let view = DDDoubleDatePicker()
        view.sureBlock = sure
        inView.addSubview(view)
        guard let start = DDAppInfo.dateStr(date.start, dateFormat: "yyyy-MM-dd") else { return }
        guard let dateStart = DateFormatter().then({ $0.dateFormat = "yyyy-MM-dd" }).date(from: start) else { return }
        guard let end = DDAppInfo.dateStr(date.end, dateFormat: "yyyy-MM-dd") else { return }
        guard let dateEnd = DateFormatter().then({ $0.dateFormat = "yyyy-MM-dd" }).date(from: end) else { return }
        view.fromPicker.setDate(dateStart, animated: true)
        view.endPicker.setDate(dateEnd, animated: true)
    }
    
    @objc private func pickerAction(_ picker: UIDatePicker) {
        if picker == fromPicker {
            
        } else if picker == endPicker {
            
        }
    }
    
    @objc private func cancelAction() {
        removeFromSuperview()
    }
    
    @objc private func sureAction() {
        sureBlock?(String(Int(fromPicker.date.timeIntervalSince1970 * 1000)), String(Int(endPicker.date.timeIntervalSince1970 * 1000)))
        removeFromSuperview()
    }
}

