import UIKit
import Alamofire

class MainViewController: UIViewController {
    //MARK: - cardNumberField style and layout
    let cardNumberField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Entry Card Number"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.blue.cgColor
        textField.font = UIFont.systemFont(ofSize: 27)
        textField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        return textField
    }()
    
    
    //MARK: - validateButton style and layout
    let validateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Check", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    
    //MARK: - ResultLabel style and layout
    let resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.blue.cgColor
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //MARK: - This stackView including all class
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(cardNumberField)
        stackView.addArrangedSubview(validateButton)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        validateButton.addTarget(self, action: #selector(validateCard), for: .touchUpInside)
        
        view.addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
        ])
    }
    
    //MARK: - API stuffs
    @objc func validateCard() {
        guard let cardNumber = cardNumberField.text else {
            return
        }
        
        let formattedCardNumber = cardNumber.replacingOccurrences(of: " ", with: "")
        let binlistURL = "https://lookup.binlist.net/\(formattedCardNumber)"
        
        AF.request(binlistURL)
            .validate()
            .responseDecodable(of: CardInfo.self) { response in
                switch response.result {
                case .success(let cardInfo):
                    var resultText = ""
                    if let bankName = cardInfo.bank.name {
                        resultText += "Bank Name: \(bankName)\n"
                    } else {
                        resultText += "Can't access card brand.\n"
                    }
                    
                    resultText += "Scheme/Network: \(cardInfo.scheme )\n"
                    resultText += "Card Type: \(cardInfo.type )\n"
                    resultText += "Brand: \(cardInfo.brand )\n"
                    resultText += "Debit or Not: \(cardInfo.prepaid)\n"
                    
                    let countryInfo = cardInfo.country
                    resultText += "Country: \(countryInfo.name ) (Code: \(countryInfo.alpha2 ))"
                    
                    self.resultLabel.text = resultText
                case .failure(let error):
                    self.resultLabel.text = "API call error: \(error)"
                }
            }
    }
}
