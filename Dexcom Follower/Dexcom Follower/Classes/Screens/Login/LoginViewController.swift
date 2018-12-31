//
//  LoginViewController.swift
//  Dexcom Follower
//
//  Created by James Furlong on 9/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import RxSwift
import RxCocoa
import SafariServices
import OAuthSwift

class LoginViewController: UIViewController, EnvironmentInjected {
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel: LoginViewModel = LoginViewModel()
    
    private let buttonHeight: CGFloat = 60
    
    enum alertType {
        case error
        case information
    }
    
    // MARK: - UI
    
    private let welcomeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.Color.loginWelcomeText
        label.textAlignment = .center
        label.font = Theme.Font.loginWelcomeText
        label.text = "Welcome to the better Dexcom Follow app"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let mainLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.Color.loginWelcomeText
        label.font = Theme.Font.logingMainText
        label.text = "Click the button below to login into your dexcom account. If you don't have a Dexcom account yet, you can set one up here"
        label.numberOfLines = 0
        label.textAlignment = .center
        // TODO: Hyperlink on the above string
        
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(Theme.Color.loginButtonBackground.toImage(), for: .normal)
        button.setTitleColor(Theme.Color.loginButtonText, for: .normal)
        button.titleLabel?.font = Theme.Font.loginButtonText
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        
        button.rx.tap
            .bind(to: viewModel.loginButtonTapped)
            .disposed(by: disposeBag)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(welcomeLabel)
        view.addSubview(mainLabel)
        view.addSubview(loginButton)

        setupLayout()
        setupBinding()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            welcomeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor),
            mainLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 300),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.viewLogin
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                let _ = self?.loadToken() { token in
                    // save token, move to dashboard and load
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func loadToken(successCallBack: @escaping(String) -> ()) {
        let redirectUri: String = Credentials.returnUri
        let url: String = "https://sandbox-api.dexcom.com/v2/oauth2/login"
        let oAuthSwift = OAuth2Swift(
            consumerKey: Credentials.clientId,
            consumerSecret: Credentials.clientSecret,
            authorizeUrl: url,
            accessTokenUrl: redirectUri,
            responseType: "code"
        )
        oAuthSwift.allowMissingStateCheck = true
        oAuthSwift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oAuthSwift)
        guard let rwURL: URL = URL(string: Credentials.returnUri) else { return}
        
        let handle = oAuthSwift.authorize(withCallbackURL: rwURL, scope: "offline_access", state: "", success: {
            (credential, response, parameters) in
            print("This is a \(response)")
            successCallBack("")
        }, failure: { (error) in
            self.presentAlert(type: .error, message: error.localizedDescription)
        })
    }
    
    private func presentAlert(type: alertType, message: String) {
        var title: String = ""
        var message: String = ""
        switch type {
            case .error:
                title = "Error"
                message = "Something went wrong"
            case .information:
                title = "Alert"
                message = "Please try again"
        }
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    }
}
