import UIKit

class LoginView: UIView {
    
    var loginAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        addSubview(backgroundImageView)
        addSubview(loginButton)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor))
        constraints.append(backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -200))
//        constraints.append(backgroundImageView.heightAnchor.constraint(equalTo: self.heightAnchor))
        constraints.append(backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        constraints.append(backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        
        // Activate (apply)
        NSLayoutConstraint.activate(constraints)
        
        loginButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
//        loginButton.topAnchor.constraint(eaul)
        loginButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 200).isActive = true
        
    }
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "olympic_logos")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
//        let attributedString = NSMutableAttributedString(attributedString:
//                                                            NSAttributedString(string: "Login - AccredConnect", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.black]))
//        
//        button.setAttributedTitle(attributedString, for: .normal)
        
        loginButton.backgroundColor = UIColor(named: "mapbox blue")
        loginButton.setTitle("Login - AccredConnect", for: .normal)
        loginButton.setTitleColor(UIColor(named: "mapbox background"), for: .normal)
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(red: 80/255, green: 151/255, blue: 164/255, alpha: 1).cgColor
        
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)

        return loginButton
    }()
    
    @objc func handleLogin() {
        loginAction?()
    }
    
//    let loginButton: UIButton = {
//        let button = UIButton()
//        let attributedString = NSMutableAttributedString(attributedString:
//                                    NSAttributedString(string: "Login", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.white]))
//        
//        button.setAttributedTitle(attributedString, for: .normal)
//        button.layer.cornerRadius = 5
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor(red: 80/255, green: 151/255, blue: 164/255, alpha: 1).cgColor
//        button.setAnchor(width: 0, height: 50)
////        button.translatesAutoresizingMaskIntoConstraints = false
////        button.titl
//        return button
//    }()
//    
//    func mainStackView() -> UIStackView {
//        let stackView = UIStackView(arrangedSubviews: [loginButton, loginButton])
//        stackView.axis = .horizontal
//        stackView.distribution = .fillProportionally
//        stackView.spacing = 10
//        return stackView
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
