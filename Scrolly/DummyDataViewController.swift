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
    lazy var dummyProfileData = UIImage(named: coverName)?.jpegData(compressionQuality: 1.0)
    
    lazy var files = [
        UIImage(named: coverName)?.jpegData(compressionQuality: 1.0) ?? Data(),
    ]
    
    lazy var signinQuery = SigninQuery(email: self.email, password: self.password, nick: self.nick, phoneNum: self.phoneNum, birthDay: self.birthDay)
    lazy var emailValidationQuery = EmailValidationQuery(email: self.email)
    lazy var loginQuery = LoginQuery(email: self.email, password: self.password)
    lazy var myProfileQuery = MyProfileQuery(nick: "thirdTester", phoneNum: "01087654321", birthDay: "19951231", profile: dummyProfileData )
    lazy var getPostsQuery = GetPostsQuery(next: nil, limit: "50", productId: APIConstants.ProductId.novelEpisode)
//    lazy var getPostsQuery = GetPostsQuery(next: nil, limit: "50", productId: nil)
    lazy var commentsQuery = CommentsQuery(content: "테스트 댓글3")
    lazy var likeQuery = LikeQuery(likeStatus: true)
    lazy var likedPostsQuery = LikedPostsQuery(next: nil, limit: "10")
    lazy var hashTagsQuery = HashTagsQuery(next: nil, limit: "10", productId: APIConstants.ProductId.novelEpisode, hashTag: "로맨스")
    
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
//        queryOnePost(postId: "66c42b6a97d02bf91e201935")
//        deletePosts(postId: "66c353dfd22f9bf132291e8e")
//        uploadComments(postId: "66c42b6a97d02bf91e201935")
//        updateComments(postId: "66c42b6a97d02bf91e201935", commentId: "66c4cb052701b5f91d1a670d")
//        deleteComments(postId: "66c42b6a97d02bf91e201935", commentId: "66c4cb052701b5f91d1a670d")
//        likePostsToggle(postId: "66c42b6a97d02bf91e201935")
//        likePostsToggleSub(postId: "66c42b6a97d02bf91e201935")
//        likedPosts()
//        likedPostsSub()
//        updateMyProfile()
        searchHashTag()
    }
    
    private func testSubscribe(single: Single<APIManager.ModelResult>) {
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
        let result = APIManager.shared.callRequestAPI(model: BaseModel.self, router: .emailValidation(emailValidationQuery))
        testSubscribe(single: result)
    }
    
    private func signin() {
        let result = APIManager.shared.callRequestAPI(model: SigninModel.self, router:.signin(signinQuery))
        testSubscribe(single: result)
    }
    
    private func login() {
        let result = APIManager.shared.callRequestLogin(.login(loginQuery))
        testSubscribe(single: result)
    }
    
    private func withDraw() {
        let result = APIManager.shared.callRequestAPI(model: WithDrawModel.self, router: .withdraw)
        testSubscribe(single: result)
    }
    
    private func getMyProfile() {
        let result = APIManager.shared.callRequestAPI(model: MyProfileModel.self, router: .getMyProfile)
        testSubscribe(single: result)
    }
    
    private func updateMyProfile() {
        let result = APIManager.shared.callRequestUploadFiles(model: MyProfileModel.self, .updateMyProfile(myProfileQuery), myProfileQuery)
        testSubscribe(single: result)
    }
    
    private func uploadPostImage() {
        guard let data = LocalFileManager.shared.loadPDFFromAsset(filename: self.episodeName) else {
            print(#function, "data 없음")
            return
        }
        self.files.append(data)
        let query = UploadFilesQuery(names: [coverName, episodeName], files: self.files)
        let result = APIManager.shared.callRequestUploadFiles(model: UploadFilesModel.self, .uploadFiles(query), query)
        testSubscribe(single: result)
    }
    
    private func uploadPosts(files: [String]? = nil) {
        var query = PostsQuery(productId: APIConstants.ProductId.novelEpisode, title: "원작에 없는 인물로 태어났습니다 1화", content: "#원작에_없는_인물로_태어났습니다 #로맨스 #판타지 #빙의", content1: "무료", content2: nil, content3: nil, content4: nil, content5: nil, files: files)
        let result = APIManager.shared.callRequestAPI(model: PostsModel.self, router:.uploadPosts(query))
        testSubscribe(single: result)
    }
    
    private func getPosts() {
        let result = APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts(getPostsQuery))
        testSubscribe(single: result)
    }
    
    private func queryOnePost(postId: String) {
        let result = APIManager.shared.callRequestAPI(model: PostsModel.self, router: .queryOnePosts(postId))
        testSubscribe(single: result)
    }
    
    private func deletePosts(postId: String) {
        let result = APIManager.shared.callRequestAPI(model: BaseModel.self, router: .deletePosts(postId))
        testSubscribe(single: result)
    }
    
    private func uploadComments(postId: String) {
        let result = APIManager.shared.callRequestAPI(model: CommentsModel.self, router: .uploadComments(postId, commentsQuery))
        testSubscribe(single: result)
    }
    
    private func updateComments(postId: String, commentId: String) {
        let result = APIManager.shared.callRequestAPI(model: CommentsModel.self, router: .updateComments(postId, commentId, commentsQuery))
        testSubscribe(single: result)
    }
    
    private func deleteComments(postId: String, commentId: String) {
        let result = APIManager.shared.callRequestAPI(model: BaseModel.self, router: .deleteComments(postId, commentId))
        testSubscribe(single: result)
    }
    
    private func likePostsToggle(postId: String) {
        let result = APIManager.shared.callRequestAPI(model: LikeModel.self, router: .likePostsToggle(postId, likeQuery))
        testSubscribe(single: result)
    }
    
    private func likePostsToggleSub(postId: String) {
        let result = APIManager.shared.callRequestAPI(model: LikeModel.self, router: .likePostsToggleSub(postId, likeQuery))
        testSubscribe(single: result)
    }
    
    private func likedPosts() {
        let result = APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getLikedPosts(likedPostsQuery))
        testSubscribe(single: result)
    }
    
    private func likedPostsSub() {
        let result = APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getLikedPostsSub(likedPostsQuery))
        testSubscribe(single: result)
    }
    
    private func searchHashTag() {
        let result = APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .searchHashTags(hashTagsQuery))
        testSubscribe(single: result)
    }
    
    
}

