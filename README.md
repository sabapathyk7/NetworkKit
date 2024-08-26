## NetworkKit

Elevate your iOS app’s connectivity with NetworkKit – a powerful, modular network layer designed to seamlessly integrate the latest in Swift’s networking capabilities, including Combine Framework, Async/Await, and Closures.

### 📖 Full Tutorial

Dive deep into NetworkKit with the [full tutorial on Medium.](https://sabapathy7.medium.com/how-to-create-a-network-layer-for-your-ios-app-623f99161677)

### 🚀 Example Usage

Check out how to use NetworkKit in real-world applications:

• [iOS Network Example](https://github.com/sabapathyk7/iOSNetworkExample)

• [SOLID Principles Example](https://github.com/sabapathyk7/SOLIDPrinciplesExample)

• [Force Update App Example](https://github.com/sabapathyk7/ForceUpdateExample)

### ✨ Features

**• Combine Framework Integration**

 Leverage the power of Combine to streamline asynchronous operations and handle complex data flows effortlessly.
 
**• Async/Await Support**

Embrace modern Swift programming with async/await, simplifying asynchronous code and making your networking logic cleaner and more readable.

**• Closures for Flexibility**

Customize your networking calls with closures, offering a flexible and modular approach to handle responses, errors, and more.


### 📚 Code Examples

    public protocol Networkable {
       func sendRequest<T: Decodable>(endpoint: EndPoint) async throws -> T
       func sendRequest<T: Decodable>(endpoint: EndPoint, resultHandler: @escaping (Result<T, NetworkError>) -> Void)
       func sendRequest<T: Decodable>(endpoint: EndPoint, type: T.Type) -> AnyPublisher<T, NetworkError>
    }

### 🛠️ Installation

Add NetworkKit to your project using Swift Package Manager:
https://github.com/sabapathyk7/NetworkKit.git

### 🤝 Contributions

Have ideas or improvements? Feel free to submit issues or pull requests to help enhance NetworkKit.

### 🔗 Connect with Me

Stay updated on the latest features and releases by following me on [LinkedIn](https://www.linkedin.com/in/sabapathy7/).

