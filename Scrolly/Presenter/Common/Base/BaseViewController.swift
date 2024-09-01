//
//  BaseViewController.swift
//  Scrolly
//
//  Created by 유철원 on 8/20/24.
//

import UIKit
import Toast

enum TitlePosition {
    case center
    case left
}

class BaseViewController<View: BaseView>: UIViewController, UIViewControllerProvider {
    
    var rootView: View?
    var viewModel: (any ViewModelProvider)?
    
    init(view: View, viewModel: (any ViewModelProvider)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.rootView = view
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit: ", self.self)
    }
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configInteraction()
        injectModelToView()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationbar()
    }
    
    func bindData() {
        
    }
    
    func configInteraction() {
        
    }
    
    func configNavigationbar(backgroundColor: UIColor = .clear, backButton: Bool = true, shadowImage: Bool = false, foregroundColor: UIColor = .black, barbuttonColor: UIColor = .black, showProfileButton: Bool = true, titlePosition: TitlePosition = .center) {
        navigationItem.backButtonTitle = ""
        navigationItem.backBarButtonItem?.isHidden = !backButton
        
        if showProfileButton {
            let profileButton = UIBarButtonItem(image: Resource.Asset.SystemImage.lineThreeHorizontal, style: .plain, target: self, action: #selector(profileButtonClicked))
            profileButton.tintColor = barbuttonColor
            navigationItem.rightBarButtonItems = [profileButton]
        }
        
        let textAttributes = [
            NSAttributedString.Key.foregroundColor : foregroundColor,
            NSAttributedString.Key.font : Resource.Asset.Font.boldSystem25
        ]
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = backgroundColor
        appearance.shadowImage = shadowImage ? nil : UIImage()
        appearance.shadowColor = shadowImage ? Resource.Asset.CIColor.lightGray : .clear
        appearance.titleTextAttributes = textAttributes
        if titlePosition == .left {
            appearance.titlePositionAdjustment = UIOffset(horizontal: -(view.frame.width/2),
                                                          vertical: 0)
        }
//        if backgroundColor == .clear {
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//            self.navigationController?.navigationBar.isTranslucent = false
//        }
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.tintColor = .black
        
    }
    
    func injectModelToView() {
        guard let model = viewModel?.model else {
            return
        }
        rootView?.configData(model)
    }
    
    func showToastToView(_ error: APIError) {
        rootView?.makeToast(error.message, duration: 3.0, position: .bottom)
    }
    
    @objc private func profileButtonClicked(_ sender: UIBarButtonItem) {
        print(#function, "클릭됨")
    }
}

