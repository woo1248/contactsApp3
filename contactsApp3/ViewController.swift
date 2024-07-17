//
//  ViewController.swift
//  contactsApp3
//
//  Created by t2023-m0119 on 7/17/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    let addButton = UIButton(type: .system)
    let titleLabel = UILabel()
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        
        // Setup Title Label
        titleLabel.text = "친구 목록"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        // Setup Add Button
        addButton.setTitle("추가", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        self.view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        
        // Setup TableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 80
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    @objc func addButtonTapped() {
        let phoneBookVC = PhoneBookViewController()
        phoneBookVC.onSave = { [weak self] contact in
            self?.contacts.append(contact)
            self?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(phoneBookVC, animated: true)
    }
    
    func loadContacts() {
        contacts = UserDefaultsHelper.shared.fetchContacts()
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let contact = contacts[indexPath.row]
        cell.nameLabel.text = contact.name
        cell.phoneNumberLabel.text = contact.phoneNumber
        if let imageData = contact.profileImageData {
            cell.profileImageView.image = UIImage(data: imageData)
        } else {
            cell.profileImageView.image = UIImage(named: "defaultProfileImage")
        }
        return cell
    }
}



class CustomTableViewCell: UITableViewCell {
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let phoneNumberLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 30
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.addSubview(profileImageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.contentView.addSubview(nameLabel)
        
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 16)
        phoneNumberLabel.textColor = .gray
        self.contentView.addSubview(phoneNumberLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            profileImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            
            phoneNumberLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            phoneNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5)
        ])
    }
}
