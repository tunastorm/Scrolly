//
//  ViewController.swift
//  Scrolly
//
//  Created by 유철원 on 8/14/24.
//

import UIKit
import Alamofire
import RxSwift
import PDFKit

final class DummyDataViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    let email = "scrollyTest@Scrolly.com"
    let password = "123456"
    let nick = "tester"
    let phoneNum = "01012345678"
    let birthDay = "19930101"
    let coverName = "dummyImage_5"
    let episodeName = "novel_f1"
    
    lazy var files = [
        UIImage(named: coverName)?.jpegData(compressionQuality: 1.0) ?? Data(),
    ]
    
    lazy var signinQuery = SigninQuery(email: self.email, password: self.password, nick: self.nick, phoneNum: self.phoneNum, birthDay: self.birthDay)
    lazy var emailValidationQuery = EmailValidationQuery(email: self.email)
    lazy var loginQuery = LoginQuery(email: self.email, password: self.password)
    lazy var myProfileQuery = MyProfileQuery(nick: "secondTester", phoneNum: "01087654321", birthDay: "19951231", profile: Data())
    lazy var getPostsQuery = GetPostsQuery(next: nil, limit: "10", productId: APIConstants.ProductId.novelEpisode)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        validateEmail()
//        signin()
//        login()
//        withDraw()
//        getMyProfile()
//        updateMyProfile()
//        uploadPostImage()
//        uploadPosts()
//        getPosts()
        queryOnePost(postId: "66c353dfd22f9bf132291e8e")
    }
    
    private func testSubscribe(single: Single<APIManager.APIResult>) {
        single.subscribe(with: self) { owner, result in
            switch result {
            case .success(let model):
                print(#function, "model: ")
                dump(model)
                
                if model is UploadFilesModel {
                    let uploadFilesModel = model as! UploadFilesModel
                    owner.uploadPosts(files: uploadFilesModel.files)
                }
            case .failure(let error): print(#function, "error: ", error)
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func validateEmail() {
        let result = APIManager.shared.callRequestEmailValidation(.emailValidation(emailValidationQuery))
        testSubscribe(single: result)
    }
    
    private func signin() {
        let result = APIManager.shared.callRequestSignin(.signin(signinQuery))
        testSubscribe(single: result)
    }
    
    private func login() {
        let result = APIManager.shared.callRequestLogin(.login(loginQuery))
        testSubscribe(single: result)
    }
    
    private func withDraw() {
        let result = APIManager.shared.callRequestWithDraw()
        testSubscribe(single: result)
    }
    
    private func getMyProfile() {
        let result = APIManager.shared.callRequestMyProfile()
        testSubscribe(single: result)
    }
    
    private func updateMyProfile() {
        let result = APIManager.shared.callRequestUpdateMyProfile(.updateMyProfile(myProfileQuery))
        testSubscribe(single: result)
    }
    
    private func uploadPostImage() {
        guard let data = LocalFileManager.shared.loadPDFFromAsset(filename: self.episodeName) else {
            print(#function, "data 없음")
            return
        }
        self.files.append(data)
        let query = UploadFilesQuery(names: [coverName, episodeName], files: self.files)
        let result = APIManager.shared.callRequestUploadPostImage(query)
        testSubscribe(single: result)
    }
    
    private func uploadPosts(files: [String]? = nil) {
        var query = PostsQuery(productId: APIConstants.ProductId.novelEpisode, title: "원작에 없는 인물로 태어났습니다 1화", content: "#원작에_없는_인물로_태어났습니다 #로맨스 #판타지 #빙의", content1: "무료", content2: nil, content3: nil, content4: nil, content5: nil, files: files)
        let result = APIManager.shared.callRequestUploadPosts(.uploadPosts(query))
        testSubscribe(single: result)
    }
    
    private func getPosts() {
        let result = APIManager.shared.callRequestGetPosts(.getPosts(getPostsQuery))
        testSubscribe(single: result)
    }
    
    private func queryOnePost(postId: String) {
        let result = APIManager.shared.callRequestQueryOnePost(.queryOnePosts(id: postId))
        testSubscribe(single: result)
    }
    
    
    
}

