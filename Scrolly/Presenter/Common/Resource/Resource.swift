//
//  Resource.swift
//  Scrolly
//
//  Created by 유철원 on 8/20/24.
//

import UIKit

enum Resource {
    
    enum UIConstants {
        
        enum Alpha {
            static let full = CGFloat(1.0)
            static let half = CGFloat(0.5)
        }
        
        enum Border {
            static let widthZero = CGFloat(0)
            static let width1 = CGFloat(1)
            static let width3 = CGFloat(3)
        }
        
        enum CornerRadious {
            static let startButton = CGFloat(20)
            static let profileImageView = CGFloat(60)
            static let cameraIcon = CGFloat(15)
            static let searchImage = CGFloat(16)
            static let likeButton = CGFloat(10)
            static let sortingButton = CGFloat(17)
            static let settingProfileImage = CGFloat(40)
            static let mbtiButton = CGFloat(26)
        }
        
        enum Text {
            static let appTitle = "Scrolly"
            static let alertOK = "확인"
            static let alertCancle = "취소"
            static let startButton = "시작하기"
            static let compeleteButton = "완료"
            static let searchTabBar = "검색"
            static let settingTabBar = "설정"
            
            static let profileSetting = "PROFILE SETTING"
            static let nickNamePlaceholder = "닉네임을 입력해주세요 :)"
            
            static let waitingFree = "기다무"
            
            static let settingViewTitle = "SETTING"
            static let saveNewProfile = "저장"
            static let secessionLabel = "회원탈퇴"
            static let secessionAlertTitle = "탈퇴하기"
            static let secessionAlertMessage = "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴하시겠습니까?"
            
            static let editProfileTitle = "EDIT PROFILE"
        }
    
    }
    
    enum Asset {

        enum SystemImage {
            static let stopwatch = UIImage(systemName: "stopwatch")
            static let lineThreeHorizontal = UIImage(systemName: "line.3.horizontal")
            static let magnifyingGlass = UIImage(systemName: "magnifyingglass")
            static let dolcPlaintext = UIImage(systemName: "doc.plaintext")
            static let eye = UIImage(systemName: "eye")
            static let star = UIImage(systemName: "star")
            static let starFill = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysTemplate)
            static let personCropCircle = UIImage(systemName: "person.crop.circle")
            static let chevronLeft = UIImage(systemName: "chevron.left")
            static let arrowDownToLine = UIImage(systemName: "arrow.down.to.line")
            static let xmark = UIImage(systemName: "xmark")
//            static let heart = UIImage(systemName: "heart")
//            static let cameraFill = UIImage(systemName: "camera.fill")
           
//            static let timerSquare = UIImage(systemName: "timer.square")
           
//            static let clock = UIImage(systemName: "clock")

//            static let person = UIImage(systemName: "person")
//            static let networkSlash = UIImage(systemName: "network.slash")
//            static let wifiExclamationmark = UIImage(systemName: "wifi.exclamationmark")?.withTintColor(Resource.Asset.CIColor.white, renderingMode: .alwaysOriginal)
        }
        
        enum NamedImage {
            static let gradationCover = UIImage(named: "background")
            
            static var splashImage: UIImage {
                let random = [1,2,5,6,7,8,13,14,15,19].randomElement() ?? 1
                return UIImage(named: "dummyImage_\(random)")!
            }
        }
        
        enum Font {
            static let system10 = UIFont.systemFont(ofSize: 10)
            static let system13 = UIFont.systemFont(ofSize: 13)
            static let system14 = UIFont.systemFont(ofSize: 14)
            static let system15 = UIFont.systemFont(ofSize: 15)
            static let system16 = UIFont.systemFont(ofSize: 16)
            static let system17 = UIFont.systemFont(ofSize: 17)
            static let system18 = UIFont.systemFont(ofSize: 18)
            static let system19 = UIFont.systemFont(ofSize: 19)
            static let system20 = UIFont.systemFont(ofSize: 20)
            static let boldSystem10 = UIFont.systemFont(ofSize: 10)
            static let boldSystem13 = UIFont.boldSystemFont(ofSize: 13)
            static let boldSystem14 = UIFont.boldSystemFont(ofSize: 14)
            static let boldSystem15 = UIFont.boldSystemFont(ofSize: 15)
            static let boldSystem16 = UIFont.boldSystemFont(ofSize: 16)
            static let boldSystem17 = UIFont.boldSystemFont(ofSize: 17)
            static let boldSystem18 = UIFont.boldSystemFont(ofSize: 18)
            static let boldSystem19 = UIFont.boldSystemFont(ofSize: 19)
            static let boldSystem20 = UIFont.boldSystemFont(ofSize: 20)
            static let boldSystem22 = UIFont.boldSystemFont(ofSize: 22)
            static let boldSystem25 = UIFont.boldSystemFont(ofSize: 25)
            static let boldSystem30 = UIFont.boldSystemFont(ofSize: 30)
        }
        
        enum CIColor {
            static let blue = UIColor(hexCode: "186FF2", alpha: Resource.UIConstants.Alpha.full)
            static let white = UIColor(hexCode: "FFFFFF", alpha: Resource.UIConstants.Alpha.full)
            static let lightGray = UIColor(hexCode: "F2F2F2", alpha: Resource.UIConstants.Alpha.full)
            static let gray = UIColor(hexCode: "8C8C8C", alpha: Resource.UIConstants.Alpha.half)
            static let darkGray = UIColor(hexCode: "4D5652", alpha: Resource.UIConstants.Alpha.full)
            static let black = UIColor(hexCode: "000000", alpha: Resource.UIConstants.Alpha.full)
            static let red = UIColor(hexCode: "F04452", alpha: Resource.UIConstants.Alpha.full)
            static let textBlack = UIColor.textPoint
            static let viewWhite = UIColor.viewPoint
        }
        
    }
}
