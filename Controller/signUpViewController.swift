import UIKit

class signUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fnameTextField: UITextField!
    @IBOutlet weak var lnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var goToSignin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: true)
        fnameTextField.delegate = self
        lnameTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self

        // Set placeholder attributes
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 16)
        ]

        fnameTextField.attributedPlaceholder = NSAttributedString(
            string: fnameTextField.placeholder ?? "",
            attributes: placeholderAttributes
        )
        lnameTextField.attributedPlaceholder = NSAttributedString(
            string: lnameTextField.placeholder ?? "",
            attributes: placeholderAttributes
        )
        phoneTextField.attributedPlaceholder = NSAttributedString(
            string: phoneTextField.placeholder ?? "",
            attributes: placeholderAttributes
        )
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: emailTextField.placeholder ?? "",
            attributes: placeholderAttributes
        )
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: passwordTextField.placeholder ?? "",
            attributes: placeholderAttributes
        )
    }

    @IBAction func backtap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func goToSigninTapped(_ sender: Any) {
            // Navigate to the SignIn screen without any conditions
            if let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "signInViewController") as? signInViewController {
                self.navigationController?.pushViewController(signInVC, animated: true)
            }
        }

    @IBAction func signInTap(_ sender: Any) {
        // Collect data from text fields
        guard let firstName = fnameTextField.text, !firstName.isEmpty,
              let lastName = lnameTextField.text, !lastName.isEmpty,
              let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // Handle empty fields (e.g., show an alert)
            print("Please fill in all fields.")
            return
        }
        
        // Call the registerUser method with collected data
        registerUser(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, password: password)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func registerUser(firstName: String, lastName: String, phoneNumber: String, email: String, password: String) {
        // API URL
        guard let url = URL(string: "https://glacial-depths-85419-a9bb2bb65cfe.herokuapp.com/api/register") else { return }
        
        // Request setup
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Parameters to send in the body
        let parameters = RegisterRequest(firstName: firstName,
                                         lastName: lastName,
                                         email: email,
                                         password: password,
                                         phoneNumber: phoneNumber)
        
        // Encode the parameters to JSON
        guard let httpBody = try? JSONEncoder().encode(parameters) else {
            print("Failed to encode parameters")
            return
        }
        request.httpBody = httpBody
        
        // Log request details
        print("Request URL: \(request.url?.absoluteString ?? "")")
        print("Request Method: \(request.httpMethod ?? "")")
        print("Request Body: \(String(data: httpBody, encoding: .utf8) ?? "")")
        
        // Create a data task
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Check status code
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    print("Failed with status code: \(httpResponse.statusCode)")
                }
            }
            
            // Check for response data
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Print raw data for debugging
            if let rawResponseData = String(data: data, encoding: .utf8) {
                print("Raw Response Data: \(rawResponseData)")
            }
            
            // Decode the response
            do {
                let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                
                // Save the access token to local storage (UserDefaults)
                UserDefaults.standard.set(registerResponse.accessToken, forKey: "access_token")
                
                print("Access Token Saved: \(registerResponse.accessToken)")
                print("User Info: \(registerResponse.user)")
                
                // Navigate to the next screen
                DispatchQueue.main.async {
                    if let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "signInViewController") as? signInViewController {
                        self.navigationController?.pushViewController(signInVC, animated: true)
                    }
                }
                
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct RegisterRequest: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case password
        case phoneNumber = "phone_number"
    }
}

struct User: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let updatedAt: String
    let createdAt: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}

struct RegisterResponse: Codable {
    let accessToken: String
    let user: User
    let tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case user
        case tokenType = "token_type"
    }
}
