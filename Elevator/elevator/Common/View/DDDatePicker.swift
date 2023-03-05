//
//  DDDatePicker.swift
//  elevator
//
//  Created by ddy on 2023/2/15.
//

import UIKit

class DDDatePicker: UIView {
    
    private var sureBlock: ((String) -> Void)?
    
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
    
    private lazy var datePicker: UIDatePicker = UIDatePicker().then {
        $0.locale = Locale.current
        $0.datePickerMode = .date
        $0.setDate(Date(), animated: true)
        if #available(iOS 13.4, *) {
            $0.preferredDatePickerStyle = .wheels
        }
    }

    override init(frame: CGRect) {
        super.init(frame: DDScreen.bounds)
        backgroundColor = UIColor(hex: "#666666").withAlphaComponent(0.75)
        addSubviews(backView, cancelButton, sureButton, datePicker)
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
        datePicker.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(216)
        }
    }
    
    public static func show(in inView: UIView, sure: @escaping ((String) -> Void)) {
        let view = DDDatePicker()
        view.sureBlock = sure
        inView.addSubview(view)
    }
    
    @objc private func cancelAction() {
        removeFromSuperview()
    }
    
    @objc private func sureAction() {
        sureBlock?(String(Int(datePicker.date.timeIntervalSince1970 * 1000)))
        removeFromSuperview()
    }
}
