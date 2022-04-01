/*
    TextFieldAlert.swift
    SwiftUITextFieldAlert

    Created by Jeff Spooner on 2022-03-17.

    TextFieldAlert is a UIViewControllerRepresentable used to present
    an alert with a interactable TextField.
*/

import SwiftUI


// MARK: - TextFieldAlert

struct TextFieldAlert: UIViewControllerRepresentable
  {
    // The title of the alert
    let alertTitle: String
    // The message presented by the alert
    let message: String
    // The binding for the value of the presented textfield
    @Binding var text: String
    // The binding for the flag which triggers presentation of the alert
    @Binding var isPresented: Bool
    // The completion callback executed when the alert's accept action is triggered
    let completion: () -> Void


    func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlert>) -> TextFieldAlertViewController
      {
        // Create and return an instance of the our custom UIViewController subclass
        TextFieldAlertViewController(alertTitle: alertTitle, message: message, text: $text, isPresented: $isPresented, completion: completion)
      }


    func updateUIViewController(_ alertController: TextFieldAlertViewController, context: Context)
      {
        // TextFieldAlert does not make use of the udpdateUIViewController(:context:) method
      }


    // MARK: - TextFieldAlertViewController

    class TextFieldAlertViewController: UIViewController, UITextFieldDelegate
      {
        let alertTitle: String
        let message: String
        var text: Binding<String>
        var isPresented: Binding<Bool>
        let completion: () -> Void

        // Maintain the accept action as an instance variable, in order to toggle its enabled state
        var acceptAction: UIAlertAction!


        init(alertTitle: String, message: String, text: Binding<String>, isPresented: Binding<Bool>, completion: @escaping () -> Void)
          {
            self.alertTitle = alertTitle
            self.message = message
            self.text = text
            self.isPresented = isPresented
            self.completion = completion

            super.init(nibName: nil, bundle: nil)
          }


        required init?(coder: NSCoder)
          {
            fatalError("init(coder:) has not been implemented")
          }


        override func viewWillAppear(_ animated: Bool)
          {
            super.viewWillAppear(animated)

            presentAlert()
          }


        func presentAlert()
          {
            // Create and configure an instance of UIAlertController
            let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)

            // Add a text field to the alert, setting ourself as the delegate
            alertController.addTextField { textField in
              textField.delegate = self
            }

            // The Cancel action dismisses the alert by setting the isPresented flag to false
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
              self.isPresented.wrappedValue = false
            }
            alertController.addAction(cancelAction)

            // The Accept action dismisses the alert and calls the completion callback specified at initialization
            acceptAction = UIAlertAction(title: "Accept", style: .default) { _ in
              self.isPresented.wrappedValue = false
              self.completion()
            }
            // Set the initial enabled state of the accept action to false, as the text field will be empty at this time
            acceptAction.isEnabled = false
            alertController.addAction(acceptAction)

            // Present the alert
            present(alertController, animated: true, completion: nil)
          }


        // MARK: - UITextFieldDelegate

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
          {
            // Generate the proposed text
            var proposedText = textField.text!
            proposedText.replaceSubrange(Range(range, in: textField.text!)!, with: string)

            // Disable the accept action if the proposed string is the empty string
            acceptAction.isEnabled = proposedText.isEmpty == false

            // Always return true
            return true
          }


        func textFieldDidEndEditing(_ textField: UITextField)
          {
            // Sanity checks
            guard let newText = textField.text else { fatalError("Unexpected state") }

            // Update the text binding with the value of the text field
            text.wrappedValue = newText
          }
      }
  }


// MARK: - View Extension

extension View
  {
    func textFieldAlert(title: String, message: String, text: Binding<String>, isPresented: Binding<Bool>, completion: @escaping () -> Void) -> some View
      {
        ZStack {
          if isPresented.wrappedValue {
            TextFieldAlert(alertTitle: title, message: message, text: text, isPresented: isPresented, completion: completion)
          }
          self
        }
      }
  }
