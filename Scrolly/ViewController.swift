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

final class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    let email = "scrollyTest@Scrolly.com"
    let password = "123456"
    let nick = "tester"
    let phoneNum = "01012345678"
    let birthDay = "19930101"
    let coverName = "dummyImage_1"
    let episodeName = "novel_f1"
    
    lazy var files = [
        UIImage(named: coverName)?.jpegData(compressionQuality: 1.0) ?? Data(),
        LocalFileManager.shared.loadPDFToDocument(filename: episodeName)?.dataRepresentation() ?? Data()
    ]
    
    lazy var signinQuery = SigninQuery(email: self.email, password: self.password, nick: self.nick, phoneNum: self.phoneNum, birthDay: self.birthDay)
    lazy var emailValidationQuery = EmailValidationQuery(email: self.email)
    lazy var loginQuery = LoginQuery(email: self.email, password: self.password)
    // 요청양식
    lazy var myProfileQuery = MyProfileQuery(nick: "secondTester", phoneNum: "01087654321", birthDay: "19951231", profile: Data())
    lazy var uploadfielsQuery = UploadFilesQuery(names: [coverName, episodeName], files: self.files)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        validateEmail()
//        signin()
//        login()
//        withDraw()
//        getMyProfile()
//        updateMyProfile()
//        uploadPostImage()
    }
    
    private func testSubscribe(single: Single<APIManager.APIResult>) {
        single.subscribe(with: self) { owner, result in
            switch result {
            case .success(let model):
                dump(model)
//                switch model {
//                case is LoginModel:
////                    owner.refreshToken()
//                    owner.updateMyProfile()
//                default: break
//                }
            case .failure(let error): print(error)
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func validateEmail() {
        let result = APIManager.shared.callRequestEmailValidation(emailValidationQuery)
        testSubscribe(single: result)
    }
    
    private func signin() {
        let result = APIManager.shared.callRequestSignin(signinQuery)
        testSubscribe(single: result)
    }
    
    private func login() {
        let result = APIManager.shared.callRequestLogin(loginQuery)
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
        let result = APIManager.shared.callRequestUpdateMyProfile(myProfileQuery)
        testSubscribe(single: result)
    }
    
    private func uploadPostImage() {
        let result = APIManager.shared.callRequestUploadPostImage(uploadfielsQuery)
        testSubscribe(single: result)
    }
   

}

