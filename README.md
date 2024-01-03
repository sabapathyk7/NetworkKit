# NetworkKit

Elevate your iOS app's connectivity with NetworkKit – a powerful network layer seamlessly integrating Combine Framework, Async/Await, and Closures.

The full Tutorial can be found on [Medium](https://sabapathy7.medium.com/how-to-create-a-network-layer-for-your-ios-app-623f99161677)

![image](https://github.com/sabapathyk7/NetworkKit/assets/40764138/2727acdc-a524-4806-8f33-7a691a5c8296)



## Features

- **Combine Framework Integration:** Leverage the power of Combine to streamline asynchronous operations and handle complex data flows effortlessly.

- **Async/Await Support:** Embrace modern Swift programming with async/await, simplifying asynchronous code and making your networking logic cleaner and more readable.

- **Closures for Flexibility:** Customize your networking calls with closures, providing a flexible and modular approach to handle responses, errors, and more.

## Examples

    public protocol Networkable {
       func sendRequest<T: Decodable>(endpoint: EndPoint) async throws -> T
       func sendRequest<T: Decodable>(endpoint: EndPoint, resultHandler: @escaping (Result<T, NetworkError>) -> Void)
       func sendRequest<T: Decodable>(endpoint: EndPoint, type: T.Type) -> AnyPublisher<T, NetworkError>
    }

### Installation

Simply add NetworkKit to your project using Swift Package Manager - https://github.com/sabapathyk7/NetworkKit.git

## Contributions

 Feel free to submit issues or pull requests to enhance the functionality of NetworkKit.

## Connect with Me

Stay updated on the latest features and releases by following me on [LinkedIn](https://www.linkedin.com/in/sabapathy7/).

