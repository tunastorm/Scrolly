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

<br>

> ### 스크린샷
![스크린샷 ALL](https://github.com/user-attachments/assets/fa8b7866-7a06-4f62-a79f-6eeb70082d62)

<br>

> ### 개발기간 
 2024.08.14 ~ 2024.08.31

<br>

> ### 개발인원
- 클라이언트 1명
- 서버 1명
<br>

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

<br>

> ### 작품 상세 정보 조회
- 유료 작품 구매
- 회차 감상

<br>
 
> ### 작품 감상
- 웹소설 뷰어
- 댓글 작성 / 삭제

<br>

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

> ### UIKit과 RxSwift를 결합한 MVVM Architecture

<br> 

> ### 복수의 Section을 가진 CollectionView들의 DataSource에 동시에 네트워킹 결과값 패치하기

 ![카테고리별 콜렉션 뷰 페이징 그래픽](https://github.com/user-attachments/assets/2d5d5afa-897c-4ecc-bea8-d48a1c0778c3)

<br>

> ### AccessToken 갱신 및 RefreshToken 만료 예외처리

![AccessToken 갱신 그래픽](https://github.com/user-attachments/assets/7654e0dc-25e4-4621-81c4-ea342fedbff1)

<br>

> ### 유료컨텐츠 PG 결제

![유료 컨텐츠 결제 로직 그래픽](https://github.com/user-attachments/assets/77bd2620-65da-4846-bdbc-f417b6e69bf4)

<br>

> ### Post 방식 파일 업로드 / 다운로드

![파일 업로드 다운로드 그래픽](https://github.com/user-attachments/assets/0ab45000-68d3-4612-8f55-b0f9c8cc34fc)

<br>

> ### URLRequestConvertible, TargetType 프로토콜을 채택한 Alamofire Router 패턴



<br>
 
> ### 네트워크 통신 객체에서의 에러 예외처리 

```swift
final class APIClient {
    
    private init() { }
    
    typealias onSuccess<T> = ((T) -> Void)
    typealias onFailure = ((_ error: APIError) -> Void)
    
    static let session = Session(interceptor: RetryInterceptor())
        
    // MARK: - request.responseDecodable
    static func request<T>(_ object: T.Type,
                           router: APIRouter,
                           success: @escaping onSuccess<T>,
                           failure: @escaping onFailure) where T:Decodable {
        
        session.request(router)
            .validate(statusCode: 200...445)
            .responseDecodable(of: object) { response in
                responseHandler(response, success: success, failure: failure)
            }
        
    }

......

    // MARK: - 네트워크 응답값 처리
    private static func responseHandler<T: Decodable>(_ response: AFDataResponse<T>, success: @escaping (T) -> Void, failure: @escaping onFailure) {
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
        case 200: nil
        case 400: .invalidRequest
        case 401: .invalidToken
        case 402: .invalidNick
        case 403: .accessForbidden
        case 409: .validationFaild
        case 410: .taskFailed
        case 418: .expiredRefreshToken
        case 419: .expiredToken
        case 420: .invalidKey
        case 429: .tooManyRequest
        case 444: .invalidURL
        case 445: .unAuthorizedRequest
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
        case .createURLRequestFailed: .clientError
        case .downloadedFileMoveFailed: .invalidData
        case .explicitlyCancelled: .canceled
        case .invalidURL: .clientError
        case .multipartEncodingFailed: .failedRequest
        case .parameterEncodingFailed: .failedRequest
        case .parameterEncoderFailed:  .failedRequest
        case .requestAdaptationFailed:  .failedRequest
        case .requestRetryFailed: .failedRequest
        case .responseValidationFailed: .invalidResponse
        case .responseSerializationFailed: .invalidData
        case .serverTrustEvaluationFailed: .networkError
        case .sessionDeinitialized: .invalidSession
        case .sessionInvalidated: .invalidSession
        case .sessionTaskFailed: .networkError
        case .urlRequestValidationFailed: .clientError
        }
    }
}

```

<br>

> ### Single을 이용한 RxSwift Networking Stream 구현

* Call API Client
  
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

* DataFetchStream
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
```



<br>

> ### PDFViewer로 구현하는 웹소설 뷰어

<br>

> ### DiffableDataSource와 RxDataSource

<br>

> ### Network 상태코드, AFError 예외처리

<br> 

> ### MainViewController의 각 CollectionView가 사용하는 Section enum들의 인터페이스 구현

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
private func fetchDatas<T: MainSection>(sections: [T], resultList: [APIManager.ModelResult<GetPostsModel>]) {
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

트러블 슈팅
-

<br>

> ### Response.result의 타입이 Data일 때 Alamofire RetryPolicy의 실행 실패 이슈
- 웹소설 감상에 사용되는 PDF파일을 다운로드 하는 API에서만 Token Refresh가 수행되지 않는 이슈 발생
- 확인 결과 AF.request.DataResponse에서 Retry Policy가 실행되기 전에 Network 통신 결과를 래핑하는 Single Stream이 먼저 Dispose되고 있음
- <트러블 슈팅>
- Token Referesh 정상 수행

<br>

> ### 


회고
-

<br>

> ### 성취점

* UIKit과 RxSwift를 결합한 MVVM 아키텍처 구현
* accessToken 인증 및 Alamofire Interceptor로 Token Refresh 구현
* PG사 결제 구현
* 네트워크 통신수행하는 APIClient 객체와 통신결과를 RxSwift Single Stream으로 래핑하는 APIManager객체를 구분, ViewModel의 Stream에서 호출하기 용이한 NetworkManager 객체 구현
* Compositional Layout과 Diffable DataSource, RxDataSource를 모두 사용
* 복수의 section을 가진 여러 개의 콜렉션 뷰가 사용되는 ViewController의 네트워킹을 RxSwiftStream로 제어
    
<br>

> ### 개선사항
* View와 viewModel, ViewModel과 DataSource간의 의존성 해소
*   

<br> 
