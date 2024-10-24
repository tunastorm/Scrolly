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

<div align="center">
  <img src="https://github.com/user-attachments/assets/082f3b90-7958-4308-a2ee-2c061f95e802" width="22%" height="auto"/>
  <img src="https://github.com/user-attachments/assets/cfad1e5c-14c8-4acc-b0d8-9656c4af9fbe" width="22%" height="auto"/>
  <img src="https://github.com/user-attachments/assets/ddd576cd-8396-4c16-8abe-eae9b0d8643c" width="22%" height="auto"/>
  <img src="https://github.com/user-attachments/assets/700d12d0-bf98-4f66-83e1-a77479dc9a61" width="22%" height="auto"/>
</div>

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
  <img src = "https://github.com/user-attachments/assets/fcd7a7ae-ed21-4d0a-8026-44f1f4261aa7" width="80%" height="auto">
</div>

<br>

> ### RxSwift와 Input/Output 패턴으로 단방향 데이터 흐름의 MVVM 아키텍처 설계

* 콘셉트
  - ViewModel에 UIKit을 import하지 않음
  - View와 ViewController의 역할을 분리

* ViewModel: Model 가공 및 비즈니스 로직 구현
  - Input과 Output 구조체에 Subject를 초기화하고 이를 ViewModel의 input, output 프로퍼티에 초기화
  - Input을 인자로 받고 Output을 반환하는 transform 메서드에 input Stream과 output Stream의 작업을 정의
  - transform 메서드가 최초 1회 실행되면 input과 output Stream의 구독 발생, 이후 input Stream 방출되면 연산 수행후 output Stream 방출
    
* ViewController: CollectionView의 DataSource와 화면전환 제어
  - bind 메서드에 viewModel의 transform 실행 및 이후 RxCocoa로 UIView 객체들에서 방출되는 Stream에 대한 로직 구현
  - viewDidLoad 시점에 bind 메서드 실행
  - rootView의 대리자로서 화면전환 제어

* View: UI
  - UIView 객체들을 소유하고 화면 구현 담당
  - UIView 객체들의 대리자로서 UI수준의 이벤트 제어
  
<br> 

> ### zip과 combineLatest로 복수의 Section을 가진 CollectionView들의 DataSource에 네트워크 통신 결과 패치하기

<div align = "center">
  <img src = "https://github.com/user-attachments/assets/2d5d5afa-897c-4ecc-bea8-d48a1c0778c3" width="80%" height="auto"/>
</div>

<br> 

> ### UICollectionView.CellRegistration과 SupplementaryRegistration으로 DiffableDataSource와 RxDataSource구성

* UICollectionView.CellRegistration
  - CellRegistration은 콜렉션뷰에 사용될 UICollectionViewCell을 정의하는데 사용됨
  - 콜렉션 뷰를 구성하는 여러 유형의 Cell을 정의하여 각 섹션에서 사용할 수 있음

* UICollectionView.SupplementaryRegistration
  - SupplementaryRegistration은 각 section의 헤더 뷰를 구성하는데 사용됨
  - 사용될 CollectionView에 register 되어야 함

* DiffableDataSource
  - 섹션의 헤더 뷰를 생성하는 SupplementaryRegistration과 콜렉션뷰에 사용되는 Cell 유형별 CellRegistration 객체를 생성
  - UICollectionViewDiffableDataSource의 생성시, dequeueConfiguredReusableCell함수에 CellRegistration을 넘겨 UICollectionViewCell 생성
  - UICollectionViewDiffableDataSource 인스턴스의 supplementaryViewProvider 프로퍼티에 클로저를 할당하고 내부에서 dequeueConfiguredReusableSupplementary 함수에 SupplementaryRegistration 주입해 UICollectionReusableView를 반환
  - Output Stream을 통해 ViewModel에서 데이터를 전달받을 때마다 NSDiffableDataSourceSnapshot을 생성한 후, 새로운 스냅샷을 UICollectionViewDiffableDataSource.apply로 적용해 콜렉션 뷰 다시 그림
  
* RxDataSource
  - DataSource를 생성할 때 CellRegistration과 SupplementaryRegistration을 동시에 받음
  - 데아터를 패치할 때 snapshot을 apply하지 않음
  - RxDataSource와 Differentiator에서 제공하는 SectionModelType 프로토콜의 구현체에서 콜렉션 뷰의 각 섹션이 표현할 데이터를 정의
  - OutputStream에서 SectionModelType 구현체들의 배열을 RxDataSorce에 바인딩하여 콜렉션 뷰를 다시 그림

* DiffableDataSource와 RxDataSource을 갱신하기 위한 데이터가 콜렉션뷰의 전체 데이터일 수 있게 비동기로 처리되는 네트워크 통신들이 마무리되는 시점을 combineLatest나 zip으로 제어

<br>

> ### DiffableDataSource와 CompositionalLayout으로 구성된 각 콜렉션 뷰에 필요한 섹션 enum들의 인터페이스 구현
 
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

* Alamofire로 네트워크 통신을 수행하는 기능을 네트워크 매니저에서 분리해 네트워크 클라이언트 객체 구성
  
* 매니저에서는 클라이언트가 반환하는 Result를 SingleStream으로 래핑해서 ViewModel의 데이터 갱신 Stream으로 반환
* ViewModel의 데이터 갱신 Stream에서는 flatMap으로 Result가 담긴 SingleStream을 언래핑하여 OutputStream으로 방출
  - 네트워킹 Stream은 1회성으로 소비되고, ViewModel의 데이터 갱신 Stream은 계속해서 유지되는 구조  
* Request를 위한 Query 구조체와 Router를 선택하는 부분까지 데이터 갱신 Stream의 map안 에서 수행한 후 flatMap에서 네트워크 매니저를 호출
* 네트워크 통신 작업이 온전히 RxSwift Stream 내에서 이루어지는 구조  

<br>
 
> ### enum으로 정의한 커스텀 에러로 네트워크 에러 예외처리

* 네트워크 클라이언트에서 사용되는 session.request.responseDecodable, session.upload.responseDecodable, session.request.responseData 메서드의 응답값에 대한 처리를 responseHandler라는 메서드로 일원화
* responseHandler의 내부에서 네트워크 상태코드 예외처리, AFError의 예외처리를 수행해 enum으로 정의한 커스텀 에러로 변환
* 상태코드의 예외처리 시에는 API 명세에 정의된 에러 상태코드들의 예외처리도 구현

<br>

> ### URLRequestConvertible, TargetType 프로토콜을 채택한 Alamofire Router 패턴

* 네트워크 통신 Router의 case가 비대해질 것을 고려하여 URLRequestConvertible과 직접 구현한 TargetType 프로토콜 채택
* Router는 각 case별로 필요한 baseURL, HTTPHeader, HTTPMethod, Body, Parameter, encoder를 연산프로퍼티를 통해 반환받도록 설계
* 파라미터의 경우 필요한 값들을 Query 구조체에 정의하고 Router의 case에 연관값으로 선언해 case를 선택할 때 함께 전달받도록 설계
* TargetType 프로토콜의 구현체에서 Router의 case에 해당하는 연산프로퍼티들의 반환값을 조합해 URLRequest객체를 생성하여 네트워크 클라이언트로 반환  

<br>

> ### Alamofire Interceptor로 AccessToken 갱신 및 RefreshToken 만료 예외처리

<div align = "center">
  <img src="https://github.com/user-attachments/assets/7654e0dc-25e4-4621-81c4-ea342fedbff1" width="80%" height="auto">
</div>

<br>

> ### 유료 컨텐츠 PG 결제와 결제 유효성 인증 구현

<div align="center">
  <img src="https://github.com/user-attachments/assets/77bd2620-65da-4846-bdbc-f417b6e69bf4" width="80%" height="auto"/>
</div>

<br>

> ### Alamofire로 Post 방식 파일 업로드 구현

<div align="center">
  <img src="https://github.com/user-attachments/assets/0ab45000-68d3-4612-8f55-b0f9c8cc34fc" width="80%" height="auto"/>
</div>

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
  - 토큰 갱신이 성공하기 전에 session.request.DataResponse의 결과를 래핑하는 Single Stream이 먼저 Dispose되고 있음
  
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
