프로젝트 정보
-

<br>

<div align="center">
  <img src = "https://github.com/user-attachments/assets/ad7213c6-2dd0-41ef-bc36-c3c0168e938b" width="200" height="200"/>
</div>
<br>
<div align = "center">
   <img src = "https://github.com/user-attachments/assets/903c091a-62dd-4940-8b45-449de6788cc2" width="80" height="20">
   <img src = "https://github.com/user-attachments/assets/b37832bf-28fe-4d51-931c-0d1a3043636e" width="60" height="20">
  
</div>
<br>

> ### Scrolly

- 좋아하는 웹소설을 찾아 감상할 수 있는 서비스

> ### 스크린샷
![스크린샷 ALL](https://github.com/user-attachments/assets/fa8b7866-7a06-4f62-a79f-6eeb70082d62)

> ### 개발기간 
 2024.08.14 ~ 2024.08.31

> ### 개발인원
- 클라이언트(iOS) 1명
- 서버 1명

> ### 최소 지원 버전
iOS 16.0 이상

<br>

주요 기능
-

<br>

> ### 작품조회
- 카테고리별 필터링
- 최고 조회수, 기다리면 무료, 최근 등록순 정렬
- 최근 본 작품

> ### 작품 상세 정보 조회
- 유료 작품 구매
- 회차 감상

> ### 작품 감상
- 웹소설 뷰어
- 댓글 작성 / 삭제

> ### 회원 가입 / 로그인
- AccessToken 갱신
- RefreshToken만료 예외처리

<br>

기술 스택
- 

<br>

> ### Architecture & Design Pattern

* MVVM, Input-Output
* Router, Singleton

> ### Swift Libraries

* UIKit (CompositionalLayout, Diffable DataSource)
* PDFKit

> ### OpenSource Libraries

* RxSwift, RxCocoa, RxDataSource, Differentiator
* Alamofire (URLRequestConvertible, TargetType, RetryPolicy)
* KingFisher
* SnapKit, Then
* Toast, IQKeyboardManager

<br>

구현 사항
-

<br>

> ### 프로젝트 구성도

<div align= "center">
  <img src = "https://github.com/user-attachments/assets/fcd7a7ae-ed21-4d0a-8026-44f1f4261aa7">
</div>

<br>

> ### RxSwift와 Input/Output 패턴으로 단방향 데이터 흐름의 MVVM 아키텍처 구현

* ViewModel
  - Input과 Output 구조체에 Subject를 초기화하고 이를 ViewModel의 input, output 프로퍼티에 초기화
  - Input을 인자로 받고 Output을 반환하는 transform 메서드에 input Stream과 output Stream의 작업을 정의
  - transform 메서드가 한 번 실행되면 input과 output Stream의 구독 발생, 이후 input Stream 방출되면 연산 수행후 output Stream 방출
    
* View
  - 

<br> 

> ### zip과 combineLatest로 복수의 Section을 가진 CollectionView들의 DataSource에 동시에 네트워킹 결과값 패치하기

 ![카테고리별 콜렉션 뷰 페이징 그래픽](https://github.com/user-attachments/assets/2d5d5afa-897c-4ecc-bea8-d48a1c0778c3)

<br> 

> ### UICollectionView.CellRegistration으로 DiffableDataSource와 RxDataSource구성

* DiffableDataSource

```swift

```

* RxDataSource
```swift

```

<br>

> ### MainViewController의 각 CollectionView에 필요한 Section enum들의 인터페이스 구현

* Interface - 구현부에서 특정 콜렉션뷰의 section별 sort, filtering 조건 구현

```swift
protocol MainSection: CaseIterable, Hashable {
    var value: String { get }
    var header: String? { get }
    var allCase: [Self] { get }
    var query: HashTagsQuery { get }
    
    func convertData(_ model: [PostsModel]) -> [PostsModel]
    func setViewedNovel(_ postList: [PostsModel]) -> [PostsModel]
}
```

* MainViewController - 각 콜렉션 뷰의 Section별 Data Fetch

```swift
private func fetchDatas<T: MainSection>(
    sections: [T],
    resultList: [APIManager.ModelResult<GetPostsModel>]
) {
    var dataDict: [String:[PostsModel]] = [:]
    var noDataSection: T?
    resultList.enumerated().forEach { idx, result in
        switch result {
        case .success(let model):
            if model.data.count == 0 {
                noDataSection = sections[idx]
                return
            }
            let section = sections[idx]
            dataDict[section.value] = section.convertData(model.data)
        case .failure(let error):
            showToastToView(error)
        }
    }
    configDataSource(sections: sections, noDataSection: noDataSection)
    updateSnapShot(sections: sections, dataDict)
}
```


<br>

> ### RxSwift Single을 이용한 일회성의 EventStream으로 네트워크 통신 이벤트 관리  

* 네트워킹 요청
  
```swift
final class APIManager: APIManagerProvider {
  
    private init() { }
    
    static let shared = APIManager()
    
    typealias ModelResult<T:Decodable> = Result<T, APIError>
    typealias DataResult = Result<Data, APIError>
    typealias TokenHandler = (Decodable) -> Void
    
    func callRequestAPI<T: Decodable>(
        model: T.Type,
        router: APIRouter,
        tokenHandler: TokenHandler? = nil
    ) -> Single<ModelResult<T>> {
        return Single.create { single in
            APIClient.request(T.self, router: router) { model in
                if let tokenHandler { tokenHandler(model) }
                single(.success(.success(model)))
            } failure: { error in
                single(.success(.failure(error)))
            }
            return Disposables.create()
       }
    }

......

}

```

* 네트워킹 결과 패치
```swift
let episodes = input.episodes
    .map { [weak self] in // request Query 세팅
        HashTagsQuery(
            next: self?.cursor[0],
            limit: "50",
            productId: APIConstants.ProductId.novelEpisode,
            hashTag:  model.hashTags.first
        )
    }
    .flatMap { // REST API Request 
        APIManager.shared.callRequestAPI(
            model: GetPostsModel.self,
            router: .searchHashTags($0)
        )
    }

......

PublishSubject.combineLatest(novelInfo, episodes, viewedList)
    .bind(with: self) { owner, results in
        owner.output.fetchedModel.onNext(results.0)
        owner.output.fetchedModel.onCompleted()
        owner.output.episodes.onNext(results.1)
        owner.output.viewedList.onNext(results.2)
    }
    .disposed(by: disposeBag)

```
<br>
 
> ### enum으로 정의한 커스텀 에러로 네트워크 에러 예외처리 

```swift
final class APIClient {
    
    private init() { }
    
    typealias onSuccess<T> = ((T) -> Void)
    typealias onFailure = ((_ error: APIError) -> Void)
    
    static let session = Session(interceptor: RetryInterceptor())
        
    // MARK: - request.responseDecodable
    static func request<T>(
        _ object: T.Type,
        router: APIRouter,
        success: @escaping onSuccess<T>,
        failure: @escaping onFailure
    ) where T:Decodable {
        session.request(router)
            .validate(statusCode: 200...445)
            .responseDecodable(of: object) { response in
                responseHandler(response, success: success, failure: failure)
            }
    }

    ......

    // MARK: - 네트워크 응답값 처리
    private static func responseHandler<T: Decodable>(
        _ response: AFDataResponse<T>,
        success: @escaping (T) -> Void,
        failure: @escaping onFailure
    ) {
        if let error = responseErrorHandler(response) {
            return failure(error)
        }
        switch response.result  {
        case .success(let result):
            success(result)
        case .failure(let AFError):
            let error = convertAFErrorToAPIError(AFError)
            failure(error)
        }
    }
    
    // MARK: - Response 에러 처리
    private static func responseErrorHandler<T: Decodable>(_ response: AFDataResponse<T>) -> APIError? {
        if let statusCode = response.response?.statusCode, let statusError = convertResponseStatus(statusCode) {
            return statusError
        }
        return nil
    }
    
    // MARK: - Response 상태코드 변환
    private static func convertResponseStatus(_ statusCode: Int) -> APIError? {
        return switch statusCode {
        // API 명세에 정의된 상태 코드 예외처리 
        case 200: nil
        case 400: .invalidRequest

        ......

        case 445: .unAuthorizedRequest
        // 일반적인 상태코드 예외처리
        case 300 ..< 400: .redirectError
        case 402 ..< 500: .clientError
        case 500 ..< 600: .serverError
        default: .networkError
        }
    }
    
    // MARK: - AFError 변환
    private static func convertAFErrorToAPIError(_ error: AFError) -> APIError {
        return switch error {
        case .createUploadableFailed: .failedRequest

        ......

        case .urlRequestValidationFailed: .clientError
        }
    }

}

```
<br>

> ### URLRequestConvertible, TargetType 프로토콜을 채택한 Alamofire Router 패턴

* Query
```swift
import Foundation

struct LoginQuery: Encodable {

    let email: String
    let password: String
    
}

struct GetPostsQuery: Encodable {
    
    let next: String?
    let limit: String?
    let productId: String?
    
    enum CodingKeys: String, CodingKey {
        case next, limit
        case productId = "product_id"
    }
    
}
```

* Router
```swift
import Foundation
import Alamofire

enum APIRouter {
    ......
    case login(_ query: LoginQuery)
    ......
    case getPosts(_ query: GetPostsQuery)
    ......
}

extension APIRouter: TargetType {
   
    enum HeadersOption {
        case json
        case token
        case tokenAndRefresh
        case tokenAndMulipart
        case tokenAndJson
        
        var headers: [String: String] {
            return switch self {
            case .json:
                [ APIConstants.contentType : APIConstants.json ]
            case .token:
                [ APIConstants.authorization : UserDefaultsManager.token ]
            case .tokenAndRefresh:
                [ APIConstants.authorization : UserDefaultsManager.token,
                  APIConstants.refresh : UserDefaultsManager.refresh ]
            case .tokenAndMulipart:
                [ APIConstants.authorization : UserDefaultsManager.token,
                  APIConstants.contentType : APIConstants.multipart ]
            case .tokenAndJson:
                [ APIConstants.authorization : UserDefaultsManager.token,
                  APIConstants.contentType : APIConstants.json ]
            }
        }
        
        var combineHeaders: HTTPHeaders {
            let values = self.headers
            var headers = APIRouter.baseHeaders
            values.forEach { key, value in
                headers.add(name: key, value: value)
            }
            return headers
        }
    
    }
    
    // 열거형 asoociate value
    var baseURL: String {
        return APIConstants.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .emailValidation, .login, .uploadFiles, .uploadPosts, .uploadComments, .likePostsToggle, .likePostsToggleSub, .paymentValidation:
            return .post
        case .refreshAccessToken, .withdraw, .getPosts, .getPostsImage, .queryOnePosts, .getLikedPosts, .getLikedPostsSub, .getMyProfile, .searchHashTags, .paymentedList:
            return .get
        case .updatePosts, .updateComments, .updateMyProfile:
            return .put
        case .deletePosts, .deleteComments:
            return .delete
        }
    }
    
    static var baseHeaders: HTTPHeaders {
        [ APIConstants.key : APIKey.key ]
    }
    
    var headers: HTTPHeaders {
        switch self {
        ......
        case .getPosts:
            return HeadersOption.token.combineHeaders
        case .login:
            return HeadersOption.json.combineHeaders
        ......
        }
    }

    var path: String {
        return APIConstants.sesacPath(router: self)
    }
    
    var body: Data? {
        return switch self {
        ......
        case .login(let query): 
            encodeQuery(query)
        ......
        default: nil
        }
    }
    
    var parameters: Encodable? {
        switch self {
        case .getPosts(let query): query
        ......
        default: nil
        }
    }
    
    var encoder: ParameterEncoder {
        return URLEncodedFormParameterEncoder.default
    }
    
    var description: String {
        switch self {
        ......
        case .login: "login"
        ......
        case .getPosts: "getPosts"
        ......
        }
    }
    
    private func encodeQuery(_ query: Encodable) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(query)
    }
    
}
``` 

* TargetType
```swift
import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var body: Data? { get }
    var parameters: Encodable? { get }
    var encoder: ParameterEncoder { get }
}

extension TargetType {
    
    func asURLRequest() throws -> URLRequest {
        let url = try (baseURL + APIConstants.version.latest + path).asURL()
        var request = try URLRequest(url: url, method: method, headers: headers)
        if let body {
            request.httpBody = body
        }
        let combinedRequest = try parameters.map { try encoder.encode($0, into: request) } ?? request
        return combinedRequest
    }

}
```

<br>

> ### Alamofire Interceptor로 AccessToken 갱신 및 RefreshToken 만료 예외처리

![AccessToken 갱신 그래픽](https://github.com/user-attachments/assets/7654e0dc-25e4-4621-81c4-ea342fedbff1)

<br>

> ### 유료 컨텐츠 PG 결제와 결제 유효성 인증 구현

![유료 컨텐츠 결제 로직 그래픽](https://github.com/user-attachments/assets/77bd2620-65da-4846-bdbc-f417b6e69bf4)

<br>

> ### Alamofire로 Post 방식 파일 업로드 구현

![파일 업로드 다운로드 그래픽](https://github.com/user-attachments/assets/0ab45000-68d3-4612-8f55-b0f9c8cc34fc)

<br>

> ### PDFKit의 PDFView를 커스텀하여 웹소설 뷰어 구현

* PDFView
```swift
private let pdfView = {
        let view = PDFView()
        view.backgroundColor = .white
        view.displayMode = .singlePage
        view.displayDirection = .horizontal
        view.pageShadowsEnabled = false
        view.usePageViewController(true, withViewOptions: nil)
        view.maxScaleFactor = 0.5
        view.minScaleFactor = 1.0
        return view
    }()
```  
* AutoLayout
```swift
pdfView.snp.makeConstraints { make in
    make.verticalEdges.equalToSuperview()
    make.left.equalToSuperview().offset(-120)
    make.right.equalToSuperview().offset(120)
}
```

<br>


트러블 슈팅
-

<br>

> ### Response.result의 타입이 Data일 때 Alamofire RetryPolicy의 실행 실패 이슈
* 웹소설 감상에 사용되는 PDF파일을 다운로드 하는 API에서만 Token Refresh가 수행되지 않는 이슈 발생

<div align="center">
  <img src="https://github.com/user-attachments/assets/330de340-5ee0-4bfd-9272-09c0d808c239" width="230" height="500">
</div>

* Retry Policy 성공 case
  - RetryPolicy에 설정한 Limitation(설정값: 3)만큼 retry
  - 토큰 갱신 성공 후 기존 request 재수행하여 결과 반환
  
  ![스크린샷 2024-10-22 오전 2 10 38](https://github.com/user-attachments/assets/5e55d4f3-9d7a-45a8-a064-7a5e90b762ad)

* Retry Policy 실패 case
  - Limitation만큼 retry
  - 토큰 갱신이 성공하기 전에 AF.request.DataResponse의 결과를 래핑하는 Single Stream이 먼저 Dispose되고 있음
  
  ![스크린샷 2024-10-22 오전 2 37 33](https://github.com/user-attachments/assets/0ba5b024-6686-426a-927b-827544fee45d)

* 트러블 슈팅

* Token Referesh 정상 수행

<br>

회고
-

<br>

> ### 성취점

* RxSwift의 MVVM 아키텍처 구현
* AccessToken 인증 / 갱신 구현
* PG사 결제 및 결제 유효성 검증 구현
* 네트워크 통신수행하는 APIClient 객체와 통신결과를 RxSwift Single Stream으로 래핑하는 APIManager객체를 구분, ViewModel의 Stream에서 호출하기 용이한 NetworkManager 객체 구현
* Compositional Layout과 Diffable DataSource, RxDataSource를 모두 사용
* 복수의 section을 가진 여러 개의 콜렉션 뷰가 사용되는 ViewController의 네트워킹을 RxSwift Stream로 제어
    
<br>

> ### 개선사항
* View와 ViewModel, ViewModel과 DataSource간의 의존성 해소가 필요. POP를 적용해보자.
* 웹소설 뷰어 화면이 EPUB 파일까지 다룰 수 있으면 더 좋을 것.

<br> 
