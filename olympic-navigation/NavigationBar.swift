import UIKit

class NavigationBar: UIView {
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.contentMode = .scaleToFill
        textField.contentHorizontalAlignment = .left
        textField.contentVerticalAlignment = .center
        textField.placeholder = "Where to?"
        textField.textAlignment = .left
        textField.minimumFontSize = 17
        textField.clearButtonMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor(named: "mapbox text")
        textField.font = .systemFont(ofSize: 15)
        textField.backgroundColor = UIColor(named: "mapbox search background")
        return textField
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.text = "None"
        label.font = Fonts.bold(style: .body, traits: nil)
        label.contentMode = .scaleAspectFit
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = UIColor(named: "mapbox inactive segment text")
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("Required init called")
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(named: "mapbox searchbar background")
        layer.cornerRadius = 5
                
        self.addSubview(textField)
        self.addSubview(label)
        
        addConstraints()
    }
    
    private func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        // Add
        constraints.append(label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12))
        constraints.append(label.centerYAnchor.constraint(equalTo: textField.centerYAnchor))
        constraints.append(label.topAnchor.constraint(equalTo: self.topAnchor, constant: 12))
        constraints.append(label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12))
                
        constraints.append(textField.topAnchor.constraint(equalTo: label.topAnchor))
        constraints.append(textField.bottomAnchor.constraint(equalTo: label.bottomAnchor))
        constraints.append(textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60))
        constraints.append(textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12))
          
        // Activate (apply)
        NSLayoutConstraint.activate(constraints)
    }
}
