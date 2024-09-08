//
//  CommentCell.swift
//  Scrolly
//
//  Created by 유철원 on 9/7/24.
//

import UIKit
import SnapKit
import Then

final class CommentCell: BaseCollectionViewCell {
    
    var delegate: CommentCellDelegate?
    
    private let creatorLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = Resource.Asset.CIColor.gray
        $0.font = Resource.Asset.Font.boldSystem13
    }
    
    private let dateLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = Resource.Asset.CIColor.gray
        $0.font = Resource.Asset.Font.boldSystem10
    }
    
    private let newLabel = NewLabel()
    
    private let contentLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = Resource.Asset.Font.system15
        $0.textColor = Resource.Asset.CIColor.black
        $0.numberOfLines = 0
    }
    
    override func configHierarchy() {
        contentView.addSubview(creatorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(newLabel)
        contentView.addSubview(contentLabel)
    }
    
    override func configLayout() {
        newLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.equalTo(44)
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        creatorLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalToSuperview().inset(20)
            make.leading.equalTo(newLabel.snp.trailing).offset(4)
        }
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.width.equalTo(120)
            make.leading.equalTo(creatorLabel.snp.trailing).offset(10)
            make.top.equalToSuperview().inset(20)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(newLabel.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    override func configView() {
        backgroundColor = .clear
    }
    
    func configCell(_ comment: Comment) {
//        let hiddenId = comment.creator.userId.replacing(comment.creator.userId.suffix(), with: "*")
        creatorLabel.text = comment.creator.nick
        dateLabel.text = DateFormatManager.shared.stringToformattedString(value: comment.createdAt, before: .dateAndTimeWithTimezone, after: .dotSperatedyyyMMddHHmm)
        
        let isHidden = !DateFormatManager.shared.dateStringIsNowDate(comment.createdAt)
        newLabelToggle(isHidden: isHidden)
        contentLabel.text = comment.content
    }
    
    private func newLabelToggle(isHidden: Bool) {
        let width = isHidden ? 0 : 44
        let offset = isHidden ? 0 : 4
        newLabel.snp.updateConstraints { make in
            make.width.equalTo(width)
        }
        creatorLabel.snp.updateConstraints { make in
            make.leading.equalTo(newLabel.snp.trailing).offset(offset)
        }
        newLabel.isHidden = isHidden
    }
    
}
