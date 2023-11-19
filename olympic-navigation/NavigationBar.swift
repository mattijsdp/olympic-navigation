import UIKit

class NavigationBar: UIButton {
    
    var textField: UILabel = {
        let textField = UILabel()
        textField.contentMode = .scaleToFill
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor(named: "mapbox text")
        textField.font = Fonts.default(style: .body, traits: nil) // .systemFont(ofSize: 15)
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
