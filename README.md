### Pokémon App

This README provides an overview of the implementation choices and design considerations for the Pokémon app developed as part of the Grip iOS test.

#### Project Overview
The goal of this project is to develop an iOS app that displays a list of Pokémon with images and names retrieved from the [PokéAPI](https://pokeapi.co/). Upon selecting a Pokémon, the app should display detailed information including the Pokémon's name, images, stats, and type.

#### Implementation Choices
1. **Swift Language**: Swift is the primary language used for iOS development, providing a modern and efficient platform for building iOS apps.
   
2. **Clean Architecture with MVVM**: Clean Architecture facilitates separation of concerns and maintainability by organizing code into distinct layers: Presentation, Domain, and Data. MVVM (Model-View-ViewModel) pattern is employed in the Presentation layer to manage the UI logic and data binding, ensuring a clear separation between the view and the underlying business logic.
   
3. **Dependency Injection**: Dependency Injection (DI) is used to facilitate loose coupling and improve testability. By injecting dependencies, components become easier to replace or mock, enabling more comprehensive unit testing.

4. **Dependency Management**: CocoaPods was utilized for dependency management, with SDWebImage being integrated for efficient network image downloading. However, considering the stability and maturity of Swift Package Manager (SPM), it could have been employed as an alternative.

#### Project Structure
- **Presentation Layer**: Contains the UI components, view controllers, view models, and any presentation-related logic. MVVM pattern is implemented here.
  
- **Domain Layer**: Defines the business logic and entities of the application, independent of any UI or data concerns.
  
- **Data Layer**: Handles data retrieval and storage, including network requests to the PokéAPI.

- **Unit Tests**: Included unit tests to ensure the correctness of critical components and functions. Test coverage focuses on the Presentation and Domain layers, verifying business logic and view model behavior.
   

#### Future Improvements
- **Error Handling**: Enhance error handling mechanisms to provide better feedback to users in case of network errors or API failures.
   
- **Pagination**: Implement pagination for the Pokémon list to optimize performance and reduce the initial load time, especially when dealing with a large number of Pokémon.

- **Offline Mode**: Introduce caching mechanisms to support offline mode, allowing users to access previously fetched Pokémon data even without an internet connection.

- **UI/UX Enhancements**: Improve the user interface and experience with animations, transitions, and visual feedback to make the app more engaging and intuitive.

