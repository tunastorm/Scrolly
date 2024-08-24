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
    let coverName = "dummyImage_17"
    let episodeName = "novel_m1"
    
    let dummyTitle = "언니 그놈이랑 결혼하지 마요"
    let content = "남주가 다 해먹는 무협지 속, 남주의 먼 조상님으로 빙의했다.\n\n남주를 든든히 뒷받침해 주는 역할에 충실하기 위해 뼈가 으스러져라 일해서 최고의 가문을 세웠다.\n\n 그 후, 마음 편히 눈을 감았었는데.\n\n”뭐? 내 가문이 망했다고?!”\n\n다시 눈을 떠 보니 300년 후. #무협지_남주의_어린_아내가_되어_버렸다 #Rana #여성향 #로판 "
    let creator = "Rana"
    let uploadDates = "[1,1,1,1,1,1,1]"
    let viewCount = "4626000"
    let averageRate = "9.6,3500"
    let waiting = "true"
    
    let productId = APIConstants.ProductId.novelInfo
    let postId = "66c8ca8c5056517017a45b9b"
    
    lazy var dummyProfileData = UIImage(named: coverName)?.jpegData(compressionQuality: 1.0)
    
    lazy var files = [
        UIImage(named: coverName)?.jpegData(compressionQuality: 1.0) ?? Data(),
    ]
    
    lazy var signinQuery = SigninQuery(email: self.email, password: self.password, nick: self.nick, phoneNum: self.phoneNum, birthDay: self.birthDay)
    lazy var emailValidationQuery = EmailValidationQuery(email: self.email)
    lazy var loginQuery = LoginQuery(email: self.email, password: self.password)
    lazy var myProfileQuery = MyProfileQuery(nick: "thirdTester", phoneNum: "01087654321", birthDay: "19951231", profile: dummyProfileData )
    lazy var getPostsQuery = GetPostsQuery(next: nil, limit: "50", productId: APIConstants.ProductId.novelInfo)
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
//        uploadPostImage(isUpdate: true)
//        uploadPosts()
        getPosts()
//        queryOnePost(postId: "66c42b6a97d02bf91e201935")
//        updatePosts(postId: "66c8ca8c5056517017a45b9b", query:  PostsQuery(productId: nil, title: nil, content: "소설 속 악역으로 빙의했다.\n재능도 없고, 노력도 하지 않는\n찌질한 망나니 빌런으로.\n\n하지만\n\n[검술: F] [창술: S]\n\n…이 정도면 할만한데? #백작가_도련님은_창술천재 #연량 #웹소설 #판타지 #남성향", content1: nil, content2: nil, content3: nil, content4: nil, content5: nil, files: nil))
//        deletePosts(postId: "66c353dfd22f9bf132291e8e")
//        uploadComments(postId: "66c42b6a97d02bf91e201935")
//        updateComments(postId: "66c42b6a97d02bf91e201935", commentId: "66c4cb052701b5f91d1a670d")
//        deleteComments(postId: "66c42b6a97d02bf91e201935", commentId: "66c4cb052701b5f91d1a670d")
//        likePostsToggle(postId: "66c42b6a97d02bf91e201935")
//        likePostsToggleSub(postId: "66c42b6a97d02bf91e201935")
//        likedPosts()
//        likedPostsSub()
//        updateMyProfile()
//        searchHashTag()
//        let vc = MainViewController(view: MainView(), viewModel: MainViewModel())
//        navigationController?.pushViewController(vc, animated: false)
    }
    
    let waitingFree = [
        "true","true", "false", "true", "false",
        "false", "false", "false", "true", "true",
        "true", "true", "true", "false", "true",
        "true", "false", "false", "false", "true"
    ]
    
    
    let banner = [
        "남주가 다 해먹는 무협지 속, 남주의 먼 조상님으로 빙의했다",
        "아버지는 사실 정령왕이었다. 그런데 이번엔 내 차례라고 한다",
        "내가 직접 설계했던 퀘스트가 진행되는 세상",
        "오직 나만이 상태창이라는 법칙 아래 자유롭다",
        "무재능, 무노력의 망나니 빌런이지만 해볼 만하다",
        "이 빌어먹을 세계는 한 때 게임이었다",
        "어느 날 나에게 ‘유닛 뽑는’ 능력이 생겼다",
        "정글에서 살아남기",
        "불운했던 인생, 템빨로 역전한다",
        "굴라의 아들이 돌아왔다",
        "장장 300년만에 돌아온 집에 내 ‘딸’이 기다리고 있다?",
        "남주의 사랑을 갈구하는 무능한 약혼자에게 빙의했다.",
        "바랬던 건 가족들의 사랑, 그것 뿐이었어",
        "파혼을 선언한 날, 살아갈 욕심이 생겼다",
        "원작이 시작되기 1년 전으로 회귀했다. 평판 최악의 악녀로",
        "망할 예정인 검술명가에 빙의한 나",
        "내가 쓴 소설 속에서 원작에 없는 인물로 태어나버렸다",
        "이제 막 빙의한 난 언니에게 집착하다가 죽을 운명",
        "스텐튼 공작가의 하녀 ‘클레어 매킬로이’로 빙의했다",
        "여주를 소드마스터로 키우면 전부 해결될 줄 알았다",
    ]
    
    private func testSubscribe<T: Decodable>(single: Single<APIManager.ModelResult<T>>, _ isUpdate: Bool = false) {
        single.subscribe(with: self) { owner, result in
            switch result {
            case .success(let model):
                print(#function, "model: ")
//                dump(model)
               
                if model is GetPostsModel {
                    let getPostsModel = model as! GetPostsModel
                    print("count: ", getPostsModel.data.count)
                    getPostsModel.data.enumerated().forEach { idx, model in
                        print("-[\(idx)]-----------------------------------------------------")
                        print("postId: ", model.postId)
                        print("title: ", model.title)
                        print("content: ",model.content)
                        print("tags: ", model.hashTags)
                        print("files: ", model.files)
                        print("기다무: ", model.content1)
                        print("연재주기: ", model.content2)
                        print("조회수: ", model.content3)
                        print("평균별점, 입력수: ", model.content4)
                        print("waiting: ", model.content5)
                        
                        
//                        let query = PostsQuery(productId: nil, title: nil, content: nil, content1: owner.waitingFree[idx], content2: nil, content3: nil, content4: nil, content5: nil, files: nil)
//                        owner.updatePosts(postId: model.postId, query: query)
                        
//                        if let content = model.content {
//                            var newContent = content.contains("#판타지") ?  content + " #남성인기" : content + " #여성인기"
                          
//                        }
//                        var newContent = model.content?.replacing("#남성향", with: "#웹소설") ?? ""
//                        newContent = newContent.replacing("#여성향", with: "#웹소설") ?? ""
                    }
                }
                
                if model is UploadFilesModel {
                    let uploadFilesModel = model as! UploadFilesModel
                    if isUpdate {
                        let query = PostsQuery(productId: nil, title: nil, content: nil, content1: nil, content2: nil, content3: nil, content4: nil, content5: nil, files: nil)
                        owner.updatePosts(postId: owner.postId, query: query)
                        return
                    }
                    let query = PostsQuery(productId: owner.productId, title: owner.dummyTitle, content: owner.content, content1: owner.creator, content2: owner.uploadDates, content3: owner.viewCount, content4: owner.averageRate, content5: owner.waiting, files: uploadFilesModel.files)
                    owner.uploadPosts(query: query)
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
    
    private func uploadPostImage(isUpdate: Bool = false) {
//        guard let data = LocalFileManager.shared.loadPDFFromAsset(filename: self.episodeName) else {
//            print(#function, "data 없음")
//            return
//        }
//        self.files.append(data)
        let query = UploadFilesQuery(names: [coverName], files: self.files)
//        let query = UploadFilesQuery(names: [coverName, episodeName], files: self.files)
        let result = APIManager.shared.callRequestUploadFiles(model: UploadFilesModel.self, .uploadFiles(query), query)
        testSubscribe(single: result, isUpdate)
    }
    
    private func uploadPosts(query: PostsQuery) {
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
    
    private func updatePosts(postId: String, query: PostsQuery) {
        let result = APIManager.shared.callRequestAPI(model: PostsModel.self, router: .updatePosts(postId, query))
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

