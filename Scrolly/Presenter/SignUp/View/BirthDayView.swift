//
//  BirthDayView.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit

final class BirthDayView: BaseView {
    
    let birthDayPicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        picker.maximumDate = .now
        picker.locale = Locale(identifier: "ko-KR")
        return picker
    }()
    
    let descriptionLabel = CustomLabel(alignment: .center, fontSize: 18)
    
    let pickedDateLabel = CustomLabel(alignment:.center, fontSize: 15)
  
    let nextButton = PointButton(title: "다음")
    
    override func configHierarchy() {
        addSubview(descriptionLabel)
        addSubview(pickedDateLabel)
        addSubview(birthDayPicker)
        addSubview(nextButton)
    }
    
    override func configLayout() {
        birthDayPicker.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        pickedDateLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(birthDayPicker.snp.top).offset(-10)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(pickedDateLabel.snp.top).offset(-10)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(10)
        }
    }
    
    override func configView() {
        super.configView()
        nextButton.isEnabled = false
    }
    
}

