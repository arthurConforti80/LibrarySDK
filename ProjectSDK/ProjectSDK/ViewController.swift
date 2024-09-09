//
//  ViewController.swift
//  ProjectSDK
//
//  Created by Arthur Conforti on 07/09/2024.
//

import UIKit
import LibrarySDK

class ViewController: UIViewController {
    
    // MARK: - UI Components
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the word you want to save"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type here..."
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 4
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        title = "Library SDK"
        
        view.addSubview(instructionLabel)
        view.addSubview(inputTextField)
        view.addSubview(confirmButton)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {

        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 20),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 150),
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 20)
        ])
    }
    
    // MARK: - Actions
    @objc private func confirmButtonTapped() {
        guard let text = inputTextField.text, !text.isEmpty else {
            showAlert(message: "Please enter a word.", clearTextField: false)
            return
        }
        
        // Display loading indicator
        activityIndicator.startAnimating()
        confirmButton.isEnabled = false
        
        // Calls LibrarySDK to send the text
        LibraryService.shared.sendString(text) { [weak self] result in
            DispatchQueue.main.async {
                // Stop the loading indicator
                self?.activityIndicator.stopAnimating()
                self?.confirmButton.isEnabled = true
                
                switch result {
                case .success:
                    self?.showAlert(message: "\(text ?? "") was sent successfully!", clearTextField: true)
                case .failure(let error):
                    self?.showAlert(message: "Error sending: \(error.localizedDescription)", clearTextField: false)
                }
            }
        }
    }
    
    // MARK: - Alert
    private func showAlert(message: String, clearTextField: Bool) {
            let alertController = UIAlertController(title: "Resultado", message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                if clearTextField {
                    self?.inputTextField.text = "" // Clear the textfield
                }
            }
            
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
}
