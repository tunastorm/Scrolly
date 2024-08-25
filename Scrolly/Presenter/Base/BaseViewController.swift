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

protocol UIViewControllerProvider {
    func bindData()
    func configInteraction()
    func configNavigationbar(navigationColor: UIColor, shadowImage: Bool, titlePosition: TitlePosition)
}

class BaseViewController<View: BaseView>: UIViewController, UIViewControllerProvider {
    
    var rootView: View?
    var viewModel: (any ViewModelProvider)?
    
    init(view: View, viewModel: (any ViewModelProvider)? = nil) {
        self.rootView = view
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationbar(navigationColor: .clear, shadowImage: false)
    }
    
    func bindData() {
        
    }
    
    func configInteraction() {
        
    }
    
    func configNavigationbar(navigationColor: UIColor, shadowImage: Bool, titlePosition: TitlePosition = .center) {
        let searchButton = UIBarButtonItem(image: Resource.Asset.SystemImage.magnifyingGlass, style: .plain, target: self, action: #selector(searchButtonClicked))
        let profileButton = UIBarButtonItem(image: Resource.Asset.SystemImage.lineThreeHorizontal, style: .plain, target: self, action: #selector(profileButtonClicked))
        
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: Resource.Asset.CIColor.black
        ]
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = navigationColor
        appearance.shadowImage = shadowImage ? nil : UIImage()
        appearance.shadowColor = shadowImage ? Resource.Asset.CIColor.lightGray : .clear
        appearance.titleTextAttributes = textAttributes
        if titlePosition == .left {
            appearance.titlePositionAdjustment = UIOffset(horizontal: -(view.frame.width/2),
                                                          vertical: 0)
        }
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItems = [profileButton, searchButton]
        navigationItem.backButtonTitle = ""
    }
    
    @objc private func searchButtonClicked(_ sender: UIBarButtonItem) {
        print(#function, "클릭됨")
    }
    
    @objc private func profileButtonClicked(_ sender: UIBarButtonItem) {
        print(#function, "클릭됨")
    }
}

