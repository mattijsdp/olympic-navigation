import UIKit

class NavigationBar: UIView {
    
    func field(text: String) -> UILabel {
        let textField = UILabel()
        textField.text = text
        textField.contentMode = .scaleToFill
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor(named: "mapbox text")
        textField.font = Fonts.default(style: .body, traits: nil) // .systemFont(ofSize: 15)
        return textField
    }
    
    func label(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Fonts.bold(style: .body, traits: nil)
        label.contentMode = .scaleAspectFit
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = UIColor(named: "mapbox inactive segment text")
        return label
    }
    
    var startButton: UIButton = {
        let startButton = UIButton()
        startButton.translatesAutoresizingMaskIntoConstraints = false
        return startButton
    }()
    var endButton: UIButton = {
        let endButton = UIButton()
        endButton.translatesAutoresizingMaskIntoConstraints = false
        return endButton
    }()
    
    var startField: UILabel = UILabel()
    var startLabel: UILabel = UILabel()
    
    var endField: UILabel = UILabel()
    var endLabel: UILabel = UILabel()
    
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
//        backgroundColor = UIColor(named: "mapbox background")
        
        startButton.backgroundColor = UIColor(.white)
        endButton.backgroundColor = UIColor(.white)
        
        startLabel = label(text: "Start")
        startField = field(text: "Where from?")
        
        startButton.addSubview(startLabel)
        startButton.addSubview(startField)
        
        endLabel = label(text: "End")
        endField = field(text: "Where to?")
        
        endButton.addSubview(endLabel)
        endButton.addSubview(endField)
        
        startButton.layer.cornerRadius = 5
        endButton.layer.cornerRadius = 5
        layer.cornerRadius = 5
        
        self.addSubview(startButton)
        self.addSubview(endButton)
        
        addConstraints()
    }
    
    private func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        let button_lead_trail: CGFloat = 20
        let boundary_width: CGFloat = 12
        
        constraints.append(startButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: button_lead_trail))
        constraints.append(startButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -button_lead_trail))
        constraints.append(startButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 12))
        constraints.append(startButton.heightAnchor.constraint(equalToConstant: 50))
        
        constraints.append(endButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: button_lead_trail))
        constraints.append(endButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -button_lead_trail))
        constraints.append(endButton.heightAnchor.constraint(equalToConstant: 50))
        constraints.append(endButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 8))

        constraints.append(startLabel.leadingAnchor.constraint(equalTo: startButton.leadingAnchor, constant: boundary_width))
        constraints.append(startLabel.centerYAnchor.constraint(equalTo: startField.centerYAnchor))
        constraints.append(startLabel.topAnchor.constraint(equalTo: startButton.topAnchor, constant: 12))
        constraints.append(startLabel.bottomAnchor.constraint(equalTo: startButton.bottomAnchor, constant: -12))
                
        constraints.append(startField.topAnchor.constraint(equalTo: startButton.topAnchor))
        constraints.append(startField.bottomAnchor.constraint(equalTo: startButton.bottomAnchor))
        constraints.append(startField.leadingAnchor.constraint(equalTo: startLabel.leadingAnchor, constant: 60))
        constraints.append(startField.trailingAnchor.constraint(equalTo: startButton.trailingAnchor, constant: -boundary_width))
        
        constraints.append(endLabel.leadingAnchor.constraint(equalTo: endButton.leadingAnchor, constant: boundary_width))
        constraints.append(endLabel.centerYAnchor.constraint(equalTo: endField.centerYAnchor))
        constraints.append(endLabel.topAnchor.constraint(equalTo: endButton.topAnchor, constant: 12))
        constraints.append(endLabel.bottomAnchor.constraint(equalTo: endButton.bottomAnchor, constant: -12))
                
        constraints.append(endField.topAnchor.constraint(equalTo: endButton.topAnchor))
        constraints.append(endField.bottomAnchor.constraint(equalTo: endButton.bottomAnchor))
        constraints.append(endField.leadingAnchor.constraint(equalTo: endLabel.leadingAnchor, constant: 60))
        constraints.append(endField.trailingAnchor.constraint(equalTo: startButton.trailingAnchor, constant: -boundary_width))
          
        // Activate (apply)
        NSLayoutConstraint.activate(constraints)
    }
}
