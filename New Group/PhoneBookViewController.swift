//
//  PhoneBookViewController.swift
//  contactsApp3
//
//  Created by t2023-m0119 on 7/17/24.
//

import UIKit

class PhoneBookViewController: UIViewController {
    
    var onSave: ((Contact) -> Void)?
    
    let profileImageView = UIImageView()
    let randomImageButton = UIButton(type: .system)
    let nameTextView = UITextView()
    let phoneNumberTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        
        // Setup Navigation Bar
        self.title = "연락처 추가"
        let applyButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(applyButtonTapped))
        self.navigationItem.rightBarButtonItem = applyButton
        
        // Setup Profile ImageView
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 60
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.backgroundColor = .lightGray
        self.view.addSubview(profileImageView)
        
        // Setup Random Image Button
        randomImageButton.setTitle("랜덤 이미지 생성", for: .normal)
        randomImageButton.translatesAutoresizingMaskIntoConstraints = false
        randomImageButton.addTarget(self, action: #selector(randomImageButtonTapped), for: .touchUpInside)
        self.view.addSubview(randomImageButton)
        
        // Setup Name TextView
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        nameTextView.layer.borderWidth = 1
        nameTextView.layer.borderColor = UIColor.lightGray.cgColor
        nameTextView.layer.cornerRadius = 5
        self.view.addSubview(nameTextView)
        
        // Setup Phone Number TextView
        phoneNumberTextView.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextView.layer.borderWidth = 1
        phoneNumberTextView.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberTextView.layer.cornerRadius = 5
        self.view.addSubview(phoneNumberTextView)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            randomImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            randomImageButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            nameTextView.topAnchor.constraint(equalTo: randomImageButton.bottomAnchor, constant: 20),
            nameTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nameTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            nameTextView.heightAnchor.constraint(equalToConstant: 40),
            
            phoneNumberTextView.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: 20),
            phoneNumberTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            phoneNumberTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            phoneNumberTextView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func applyButtonTapped() {
        // 적용 버튼 눌렀을 때의 동작 정의
                guard let name = nameTextView.text, !name.isEmpty,
                      let phoneNumber = phoneNumberTextView.text, !phoneNumber.isEmpty else {
                    // Alert or validation feedback
                    return
                }
                
                let contact = Contact(name: name, phoneNumber: phoneNumber, profileImageData: profileImageView.image?.pngData())
                UserDefaultsHelper.shared.saveContact(contact)
                onSave?(contact)
                self.navigationController?.popViewController(animated: true)
            }
    
    @objc func randomImageButtonTapped() {
        // 랜덤 이미지 생성 버튼 눌렀을 때의 동작 정의
        fetchRandomPokemonImage()
    }
    
    func fetchRandomPokemonImage() {
        let randomID = Int.random(in: 1...1000)
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(randomID)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching Pokémon data: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let sprites = json["sprites"] as? [String: Any],
                   let imageUrlString = sprites["front_default"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    
                    DispatchQueue.global().async {
                        if let imageData = try? Data(contentsOf: imageUrl) {
                            DispatchQueue.main.async {
                                self.profileImageView.image = UIImage(data: imageData)
                            }
                        }
                    }
                }
            } catch {
                print("Error parsing Pokémon data: \(error)")
            }
        }.resume()
    }
}

