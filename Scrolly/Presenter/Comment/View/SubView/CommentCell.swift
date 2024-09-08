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
    
    private var commentId: String?
    
    private let newLabel = NewLabel()
    
    private let creatorLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = Resource.Asset.CIColor.gray
        $0.font = Resource.Asset.Font.boldSystem13
    }
    
    private let dateLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = Resource.Asset.CIColor.gray
        $0.font = Resource.Asset.Font.boldSystem10
    }
    
    private let updateButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(Resource.Asset.CIColor.gray, for: .normal)
        $0.titleLabel?.font = Resource.Asset.Font.boldSystem10
        $0.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
    }
    
    private let deleteButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(Resource.Asset.CIColor.gray, for: .normal)
        $0.titleLabel?.font = Resource.Asset.Font.boldSystem10
        $0.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
   
    private let contentLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = Resource.Asset.Font.system15
        $0.textColor = Resource.Asset.CIColor.black
        $0.numberOfLines = 0
    }
    
    override func configHierarchy() {
        contentView.addSubview(newLabel)
        contentView.addSubview(creatorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(updateButton)
        contentView.addSubview(deleteButton)
        contentView.addSubview(contentLabel)
    }
    
    override func configLayout() {
        newLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.equalTo(44)
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.width.equalTo(24)
            make.top.trailing.equalToSuperview().inset(20)
        }
        updateButton.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.width.equalTo(24)
            make.top.equalToSuperview().inset(20)
            make.trailing.equalTo(deleteButton.snp.leading).offset(-10)
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
            make.trailing.lessThanOrEqualTo(updateButton.snp.leading).offset(-10)
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
        commentId = comment.commentId
        creatorLabel.text = comment.creator.nick
        dateLabel.text = DateFormatManager.shared.stringToformattedString(value: comment.createdAt, before: .dateAndTimeWithTimezone, after: .dotSperatedyyyMMddHHmm)
        
        let isHidden = !DateFormatManager.shared.dateStringIsNowDate(comment.createdAt)
        newLabelToggle(isHidden)
        
        print(#function, "creator: ", comment.creator.userId)
        print(#function, "user: ", UserDefaultsManager.user)
        
        updateDeleteButtonToggle(!(comment.creator.userId == UserDefaultsManager.user))
        contentLabel.text = comment.content
    }
    
    private func newLabelToggle(_ isHidden: Bool) {
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
    
    private func updateDeleteButtonToggle(_ isHidden: Bool) {
        updateButton.isHidden = isHidden
        deleteButton.isHidden = isHidden
    }
    
    @objc func updateButtonTapped() {
        print(#function)
    }
    
    @objc func deleteButtonTapped() {
        guard let commentId else {
            return
        }
        print(#function)
        delegate?.deleteComment(commentId)
    }
    
}
