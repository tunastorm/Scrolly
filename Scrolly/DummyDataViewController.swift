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
    
//    let email = "scrollyTest@Scrolly.com"
//    let password = "123456"
    
    let email = "test@tuna.com"
    let password = "1234"
    
    let nick = "tester"
    let phoneNum = "01012345678"
    let birthDay = "19930101"
    let coverName = "dummyImage_17"
    let episodeName = "novel_m2"
    
    let dummyTitle = "언니 그놈이랑 결혼하지 마요"
    let content = "남주가 다 해먹는 무협지 속, 남주의 먼 조상님으로 빙의했다.\n\n남주를 든든히 뒷받침해 주는 역할에 충실하기 위해 뼈가 으스러져라 일해서 최고의 가문을 세웠다.\n\n 그 후, 마음 편히 눈을 감았었는데.\n\n”뭐? 내 가문이 망했다고?!”\n\n다시 눈을 떠 보니 300년 후. #무협지_남주의_어린_아내가_되어_버렸다 #Rana #여성향 #로판 "
    let creator = "Rana"
    let uploadDates = "[1,1,1,1,1,1,1]"
    let viewCount = "4626000"
    let averageRate = "9.6,3500"
    let waiting = "true"
    
    let productId = APIConstants.ProductId.novelEpisode
    let postId = "66ce15445a9c85013f89d1b4"
    let pdfFiles = [
        "uploads/posts/novel_m1_1724773384035.pdf",
        "uploads/posts/novel_m2_1724773384575.pdf",
        "uploads/posts/novel_m3_1724773384567.pdf",
        "uploads/posts/novel_m4_1724773384712.pdf",
        "uploads/posts/novel_m5_1724773384568.pdf"
    ]
    
    let cursor: String? = "66ce28f31691d4013e52d23c"
    
    lazy var dummyProfileData = UIImage(named: coverName)?.jpegData(compressionQuality: 1.0)
    
//    lazy var files = [
//        UIImage(named: coverName)?.jpegData(compressionQuality: 1.0) ?? Data(),
//    ]
//    
    lazy var signinQuery = SigninQuery(email: self.email, password: self.password, nick: self.nick, phoneNum: self.phoneNum, birthDay: self.birthDay)
    lazy var emailValidationQuery = EmailValidationQuery(email: self.email)
    lazy var loginQuery = LoginQuery(email: self.email, password: self.password)
    lazy var myProfileQuery = MyProfileQuery(nick: "admin", phoneNum: "01087654321", birthDay: "19951231", profile: dummyProfileData )
    lazy var getPostsQuery = GetPostsQuery(next: cursor, limit: "50", productId: self.productId)
//    lazy var getPostsQuery = GetPostsQuery(next: nil, limit: "50", productId: nil)
    lazy var commentsQuery = CommentsQuery(content: "테스트 댓글3")
    lazy var likeQuery = LikeQuery(likeStatus: true)
    lazy var likedPostsQuery = LikedPostsQuery(next: nil, limit: "10")
    lazy var hashTagsQuery = HashTagsQuery(next: nil, limit: "1", productId: APIConstants.ProductId.novelEpisode, hashTag: "만렙_자캐")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        validateEmail()
//        signin()
//        login()
//        withDraw()
//        getMyProfile()
//        updateMyProfile()
//        uploadPostImage(isUpdate: false)
//        uploadPosts()
        getPosts()
//        queryOnePost(postId: "66c966c7078fb670167c2ec2")
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
//        pdfUploader()
        
    }
    
    let waitingFree = [
        "true","true", "false", "true", "false",
        "false", "false", "false", "true", "true",
        "true", "true", "true", "false", "true",
        "true", "false", "false", "false", "true"
    ]
    
    
    let banner = [
        "남주가 다 해먹는 무협지 속, 남주의 먼 조상님으로 빙의했다",
        "아버지는 사실 정령왕이었다. 그런데 이젠 내 차례라고?",
        "내가 설계한 퀘스트가 펼쳐지는 세상",
        "오직 나만이 상태창이라는 법칙 아래 자유롭다",
        "무재능, 무노력의 망나니 빌런이지만 해볼 만하다",
        "이 빌어먹을 세계는 한 때 게임이었다",
        "어느 날 나에게 ‘유닛 뽑는’ 능력이 생겼다",
        "정글에서 살아남기",
        "불운했던 인생, 템빨로 역전한다",
        "굴라의 아들이 돌아왔다",
        "장장 300년만에 돌아온 집에 내 ‘딸’이 기다리고 있다?",
        "남주의 사랑을 갈구하는 무능한 약혼자에게 빙의했다",
        "오직 바랬던 건 가족들의 사랑, 그것 뿐이었어",
        "파혼을 선언한 날, 살아갈 욕심이 생겼다",
        "원작이 시작되기 1년 전, 평판 최악의 악녀로 회귀했다",
        "망할 예정인 검술명가에 빙의한 나",
        "내가 쓴 소설 속에서 원작에 없는 인물로 태어나버렸다",
        "이제 막 빙의한 난 언니에게 집착하다가 죽을 운명이다",
        "스텐튼 공작가의 하녀 ‘클레어 매킬로이’로 빙의했다",
        "여주를 소드마스터로 키우면 전부 해결될 줄 알았다",
    ]
    
    let postIds: [String:String] = [
        "무협지_남주의_어린_아내가_되어_버렸다": "66c966c7078fb670167c2ec2",
        "헌터_세상의_정령왕" : "66c8cbbf078fb670167c1dcf",
        "설계자의_공략방법" : "66c8cb66078fb670167c1dc2",
        "시스템_에러로_종족초월" : "66c8cb175056517017a45bac",
        "백작가_도련님은_창술천재" : "66c8ca8c5056517017a45b9b",
        "만렙_자캐" : "66c8ca425056517017a45b84",
        "유닛_뽑는_헌터" : "66c8c9d75056517017a45b61",
        "라스트_서바이버_:_진화로_살아남아라!" : "66c8c973078fb670167c1d1c",
        "템빨" : "66c8c9255056517017a45aa3",
        "탐식의_재림" : "66c8c8ad5056517017a45a45",
        "절대자도_아빠는_처음이라" : "66c8c861078fb670167c1c71",
        "악녀의_문구점에_오지_마세요" : "66c8c81e078fb670167c1c3b",
        "사랑받는_시집살이" : "66c8c7cb078fb670167c1bee",
        "시한부_엑스트라의_시간" : "66c8c7575056517017a4592d",
        "진짜가_나타나기_전까지만" : "66c8c70b078fb670167c1b7c",
        "언니_그놈이랑_결혼하지_마요" : "66c8c6b2078fb670167c1b51",
        "원작에_없는_인물로_태어났습니다" : "66c8c6555056517017a458d2",
        "본의_아니게_원작_속_남주를_빼앗았다" : "66c8c59c078fb670167c1b2e",
        "살인마_황제님,_이러시면_곤란해요" : "66c8c54d078fb670167c1b21",
        "전_그냥_여주만_키우려고_했는데요" : "66c8c49d078fb670167c1af6"
    ]
    
    
    private func testSubscribe<T: Decodable>(single: Single<APIManager.ModelResult<T>>, _ isUpdate: Bool = false) {
        single.subscribe(with: self) { owner, result in
            switch result {
            case .success(let model):
                
                if model is PostsModel {
                    if let post = model as? PostsModel, post.content3 != nil {
                        print("success | ", post.title)
                        print(post.content5)
//                        guard let old = post.files.first else {
//                            return
//                        }
//                        let cover = "uploads/posts/dummyImage_2_1724433741089.jpg"
//                        var new = [ cover, old ]
//                        let query = PostsQuery(productId: APIConstants.ProductId.novelEpisode, title: nil, price: nil, content: nil, content1: nil, content2: nil, content3: nil, content4: nil, content5: nil, files: new)
//
//                        owner.updatePosts(postId: post.postId, query: query)
                        
                        
                        
                       
//                        let random = Int.random(in: 10...100)
//                        let nonPay = random > 50 ? Int(random / 10) : 0
//                        let waitingFree = Int(Double(random - nonPay) * 0.9)
//                        (0..<random).forEach { idx in
//                            guard let hashtag = post.hashTags.first else {
//                                return
//                            }
//                            let title = post.title! + " \(idx+1)화"
//                            let content = "#\(post.title)"
//                            let fileIdx = idx < 5 ? idx : (idx % 5)
//                            let files = [owner.pdfFiles[fileIdx]]
//                            let isPay = idx > nonPay
//                            let isWaitingFree = (isPay == true && idx <= waitingFree)
//                            
//                            let query = PostsQuery(productId: APIConstants.ProductId.novelEpisode, title: title, price: 100, content: content, content1: String(idx), content2: String(isPay), content3:  String(isWaitingFree), content4: nil, content5: nil, files: files)
//                            print("[\(idx)]\n", query)
//                            
//                            if let check = post.content3 {
//                                owner.uploadPosts(query: query)
//                            }
//                        }
                        
                    }
                }
                
                
                
                if model is GetPostsModel {
                    let getPostsModel = model as! GetPostsModel
                    print("count: ", getPostsModel.data.count)
                    getPostsModel.data.enumerated().forEach { idx, model in
//                        owner.deletePosts(postId: model.postId)
                        
                        print("-[\(idx)]-----------------------------------------------------")
//                        
//                        guard let old = model.files.first else {
//                            return
//                        }
//                        let cover = "uploads/posts/dummyImage_5_1724434004933.jpg"
//                        var new = [ cover, old ]
//                        let query = PostsQuery(productId: APIConstants.ProductId.novelEpisode, title: nil, price: nil, content: nil, content1: nil, content2: nil, content3: nil, content4: nil, content5: nil, files: new)
//                        owner.updatePosts(postId: model.postId, query: query)
//                        
                        
//                        let splited = old.split(separator: " ")
//                        var new = String(splited[0]) + " " + String(splited[1])
//                        let query = PostsQuery(productId: APIConstants.ProductId.novelEpisode, title: nil, price: nil, content: new, content1: nil, content2: nil, content3: nil, content4: nil, content5: nil, files: nil)
//
//                        let id = owner.postIds[model.hashTags[0]]
//                        print("수정할 아이디: ", id)
//                        let query = PostsQuery(productId: nil, title: nil, price: nil, content: nil, content1: nil, content2: nil, content3: nil, content4: nil, content5: id, files: nil)
//                        owner.updatePosts(postId: model.postId, query: query)
////////
//                        print("title: ", model.title)
//                        print("productId: ", model.productId)
//                        print("files: ", model.files)
//                        print("태그: ", model.hashTags)
//                        print("콘텐츠: ", model.content)
//                        print("회차: ", model.content1)
//                        print("유료: ", model.content2)
//                        print("기다무: ", model.content3)
//                        print("가격: ", model.price)
//                        print("작성자:", model.creator)
//
////                        print("success | ", model.title)
//                        let random = Int.random(in: 10...50)
//                        let nonPay = random > 25 ? Int(random / 5) : 0
//                        let waitingFree = Int(Double(random - nonPay) * 0.9)
//                        (0..<random).forEach { idx in
//                            guard let hashtag = model.hashTags.first else {
//                                return
//                            }
//                            let title = model.title! + " \(idx+1)화"
//                            let content = "#\(hashtag) #웹소설"
//                            let fileIdx = idx < 5 ? idx : (idx % 5)
//                            var files = model.files
//                            files.append(owner.pdfFiles[fileIdx])
//                            let isPay = idx > nonPay
//                            let isWaitingFree = (isPay == true && idx <= waitingFree)
//
//                            let query = PostsQuery(productId: APIConstants.ProductId.novelEpisode, title: title, price: 100, content: content, content1: String(idx), content2: String(isPay), content3: String(isWaitingFree), content4: nil, content5: nil, files: files)
//
////                            print("[\(idx)] ", "nonPay: ", nonPay, "waitingFree: ", waitingFree, " isPay: ", isPay, " isWaitingFree: ", isWaitingFree)
//
//                            owner.uploadPosts(query: query)
//                        }

//                    
////
//                        print("title: ", model.title)
//                        print("id: ", model.postId)
//                        print("content: ",model.content)
//                        print("tags: ", model.hashTags)
//                        print("files: ", model.files)
//                        print("기다무: ", model.content1)
//                        print("연재주기: ", model.content2)
//                        print("조회수: ", model.content3)
//                        print("평균별점, 입력수: ", model.content4)
//                        print("waiting: ", model.content5)
//                        print("해시태그: ", model.hashTags)
//                        print("작성자:", model.creator)
                        
                        
//
//                        if var dates = model.content2 , let oldContent = model.content {
//                            var dateString = ""
//                            let dateList = String(dates.replacing("[", with: "").replacing("]", with: "")).split(separator: ",")
//                            let krDates = ["월", "화", "수", "목", "금", "토", "일"]
//                            dateList.enumerated().forEach { idx, date in
//                                dateString += date == "1" ? "#\(krDates[idx])" : ""
//                            }
//                            let content = oldContent + dateString
//                            let query = PostsQuery(productId: nil, title: nil, content: content, content1: nil, content2: nil, content3: nil, content4: nil, content5: nil, files: nil)
//                            owner.updatePosts(postId: model.postId, query: query)
//                        }
                       
                        
//                        if let content = model.content {
//                            var newContent = content.contains("#판타지") ?  content + " #남성인기" : content + " #여성인기"
                          
//                        }
//                        var newContent = model.content?.replacing("#남성향", with: "#웹소설") ?? ""
//                        newContent = newContent.replacing("#여성향", with: "#웹소설") ?? ""
                    }
                    print("다음 커서: ", getPostsModel.nextCursor)
                }
                
              
                if model is UploadFilesModel {
                    let uploadFilesModel = model as! UploadFilesModel
                    if isUpdate {
                        let query = PostsQuery(productId: nil, title: nil, price: nil, content: nil, content1: nil, content2: nil, content3: nil, content4: nil, content5: nil, files: nil)
                        owner.updatePosts(postId: owner.postId, query: query)
                        return
                    }
                    let result = model as! UploadFilesModel
                    print(result.files)
//                    let query = PostsQuery(productId: owner.productId, title: owner.dummyTitle, content: owner.content, content1: owner.creator, content2: owner.uploadDates, content3: owner.viewCount, content4: owner.averageRate, content5: owner.waiting, files: uploadFilesModel.files)
//                    owner.uploadPosts(query: query)
                }
            case .failure(let error): print(#function, "error: ", error)
            }
        }
        .disposed(by: disposeBag)
    }
    
    
    private func pdfUploader() {
        (0..<5).forEach { idx in
            let name = idx < 5 ? "novel_m\(idx+1)" : "novel_m\((idx % 5) + 1)"
            let type = "application/pdf"
            print("\(idx) | type: \(type) | name: \(name)")
            uploadPostImage(names: [name], types: [type])
        }
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
    
    private func uploadPostImage(names: [String], types: [String], files: [Data] = [], isUpdate: Bool = false) {
        var dummyfiles: [Data] = []
        types.enumerated().forEach { idx, type in
            if type == "application/pdf", files.count == 0 {
                guard let data = LocalFileManager.shared.loadPDFFromAsset(filename: names[idx]) else {
                    print(#function, "data 없음")
                    return
                }
                dummyfiles.append(data)
            }
        }
        let fileList = files.isEmpty ? dummyfiles : files
        let query = UploadFilesQuery(names: names, types: types, files: fileList)
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

