프로젝트 정보
-

<br>

<div align="center">
  <img src = "https://github.com/user-attachments/assets/61809e71-67b6-44e0-b6db-1bf0006333ed" width="200" height="200"/>
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
![title](https://github.com/tunastorm/Log4Day/blob/tunastorm/ReadmeResource/Apple%20iPhone%2011%20Pro%20Max%20Screenshot%20All.png?raw=true)   

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
  <img src="https://github.com/tunastorm/Log4Day/blob/tunastorm/ReadmeResource/%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AE%E1%84%89%E1%85%A5%E1%86%BC%E1%84%83%E1%85%A9.png?raw=true"/>
</div>

> ### UIKit과 RxSwift를 결합한 MVVM Architecture

<br> 

> ### 

<br>

> ### 

<br>

> ### 

<br>

> ### 

<br>

> ###

<br>

> ### 

<br>

> ### 

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
- 서비스 기획상 현재 2개의 뷰에서 지도 SDK를 사용해야만 하는 만큼 최소 200MB의 메모리 부하를 디폴트로 감당해야하는 상태
- 원본 이미지를 그대로 사용하게되면 지도뷰에서 장시간 또는 대량의 작업이 일어날 경우 쉽게 메모리에 과도한 부하발생 가능
- WWDC에서 SwiftUI에서 제공하는 Image의 resizable이나 UIGraphicsImageRenderer보다 더 효율적인 방법으로 소개된 ImageIO를 사용한 다운샘플링 구현
- 전 후 성능비교

<br>

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
* PDFKit으로 웹소설 뷰여 구현
    
<br>

> ### 개선사항
* View와 viewModel, ViewModel과 DataSource간의 의존성 해소
* 네트워크, Realm CRUD 등의 예외처리 및 alert등을 통한 결과 안내 로직 추가
* 커스텀으로 구현한 무한 페이지네이션 뷰의 딱딱한 스크롤 애니메이션을 SwiftUI에 어울리게 개선

<br>
