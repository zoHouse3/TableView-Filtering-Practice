//
//  CountryTableViewCell.swift
//  Countries
//
//  Created by Eric Barnes - iOS on 2/14/24.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    static let identifier = String(describing: CountryTableViewCell.self)
    
    // MARK: UI Components
    private lazy var nameLblContainer: UIView = {
        let v = UIView()
        v.layer.borderWidth = 1.5
        v.layer.borderColor = UIColor.gray.cgColor
        v.layer.cornerRadius = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private lazy var codeLblContainer: UIView = {
        let v = UIView()
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.blue.cgColor
        v.layer.cornerRadius = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    private lazy var nameAndRegionLbl: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 2
        l.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    private lazy var codeLbl: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    private lazy var capitalLbl: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // MARK: Functions
    func configure(for country: Country) {
        nameAndRegionLbl.text = country.nameRegionText
        codeLbl.text = country.code
        capitalLbl.text = country.capital
        
        drawUI()
    }
    
    private func drawUI() {
        addSubview(nameLblContainer)
        nameLblContainer.addSubview(stackView)
        stackView.addArrangedSubview(nameAndRegionLbl)
        stackView.addArrangedSubview(capitalLbl)
       
        addSubview(codeLblContainer)
        codeLblContainer.addSubview(codeLbl)
        
        NSLayoutConstraint.activate([
            nameLblContainer.topAnchor.constraint(equalTo: topAnchor),
            nameLblContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLblContainer.heightAnchor.constraint(equalTo: heightAnchor),
            nameLblContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            
            stackView.topAnchor.constraint(equalTo: nameLblContainer.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: nameLblContainer.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: nameLblContainer.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: nameLblContainer.trailingAnchor),
            
            codeLblContainer.topAnchor.constraint(equalTo: topAnchor),
            codeLblContainer.leadingAnchor.constraint(equalTo: stackView.trailingAnchor),
            codeLblContainer.heightAnchor.constraint(equalTo: heightAnchor),
            codeLblContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            codeLbl.centerXAnchor.constraint(equalTo: codeLblContainer.centerXAnchor),
            codeLbl.centerYAnchor.constraint(equalTo: codeLblContainer.centerYAnchor)
        ])
    }
}
