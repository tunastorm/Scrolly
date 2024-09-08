//
//  CommentView.swift
//  Scrolly
//
//  Created by 유철원 on 9/7/24.
//

import UIKit
import SnapKit
import Then

final class CommentView: BaseView {
    
    var delegate: CommentViewDelegate?
    
    private let backButton = UIButton().then {
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        $0.setImage(Resource.Asset.SystemImage.xmark, for: .normal)
        $0.tintColor = Resource.Asset.CIColor.black
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = Resource.Asset.CIColor.black
        $0.font = Resource.Asset.Font.boldSystem13
        $0.textAlignment = .left
    }
    
    let collectionView = CommentTableView(frame: .zero,
                                          collectionViewLayout: CommentTableView.createLayout())
    
    private let toolBarView = UIView().then {
        $0.backgroundColor = Resource.Asset.CIColor.white
    }
    
    private let userLabel = UILabel().then {
        let user = UserDefaultsManager.user.split(separator:"@")[0]
        let hiddenUser = user.replacing(user.suffix(4), with: "*")
        $0.text = UserDefaultsManager.nick + "\(hiddenUser)"
        $0.textColor = Resource.Asset.CIColor.black
        $0.textAlignment = .left
    }
    
    private let commentTextView = UITextView().then {
        $0.text = "댓글을 입력해주세요"
        $0.font = Resource.Asset.Font.system13
        $0.backgroundColor = .clear
        $0.textColor = Resource.Asset.CIColor.gray
    }
    
    private let submitButton = UIButton().then {
        $0.setTitle("등록", for: .normal)
        $0.setTitleColor(Resource.Asset.CIColor.black, for: .normal)
        $0.titleLabel?.font = Resource.Asset.Font.system15
        $0.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        toolBarView.layer.addBorder([.top], color: Resource.Asset.CIColor.lightGray, width: 1)
    }
    
    override func configHierarchy() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(collectionView)
        addSubview(toolBarView)
        toolBarView.addSubview(commentTextView)
        toolBarView.addSubview(submitButton)
    }
    
    override func configLayout() {
        backButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.leading.equalTo(safeAreaLayoutGuide).inset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(backButton.snp.trailing).offset(10)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        toolBarView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        submitButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(60)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(25)
        }
        commentTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.bottom.equalToSuperview().inset(20)
            make.trailing.equalTo(submitButton.snp.leading).offset(6)
        }
    }
    
    override func configView() {
        super.configView()
        commentTextView.delegate = self
        commentTextView.isScrollEnabled = false
    }
    
    func configTitle(_ title: String) {
        print(#function, "title: ", title)
        titleLabel.text = title
    }
    
    @objc func backButtonTapped() {
        delegate?.dissmissCommentView()
    }
    
    @objc func submitButtonTapped() {
        guard let comment = commentTextView.text else {
            return
        }
        delegate?.uploadComment(comment)
    }
    
}

extension CommentView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print(#function, "텍스트뷰 클릭됨")
        commentTextView.text = ""
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        commentTextView.text = "댓글을 입력해주세요"
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
           
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
           
        if estimatedSize.height > 50 {
            toolBarView.snp.updateConstraints { make in
                make.height.equalTo(50 + estimatedSize.height)
            }
            return
        }
        
        if  estimatedSize.height <= 50 {
            toolBarView.snp.updateConstraints { make in
                make.height.equalTo(80)
            }
            return
        }
    }
    
}

