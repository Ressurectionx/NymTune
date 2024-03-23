# NymTune: A Streamlined Music Player App

## Description:

NymTune is a user-friendly music player app built with Flutter that seamlessly integrates
with Firebase for data storage and authentication.
It offers a smooth user experience by leveraging streams
to fetch song details as soon as the user clicks play, eliminating wait times.

## Features:

### Streamlined Song Retrieval:

Enjoy uninterrupted music playback with on-demand song fetching using Firestore streams.
No more waiting for the entire song list to load!

### Clean Architecture:

The app adheres to a clean architecture pattern for better maintainability and modularity.
Code is organized into clear layers: domain, data, and presentation.

### Firebase Integration:

NymTune leverages the power of Firebase for:
User authentication
Song data storage in Firestore
Song files stored in Cloud Storage

### Provider-based State Management:

State management is effectively handled using the Provider package,
ensuring a consistent data flow throughout the app.

### Intuitive UI:

The app boasts a user-friendly interface with clear navigation,

making it easy to find and play songs.

### Additional Features:

The provided dependency list hints at functionalities like:

Signup/Signin pages
Home screen
Song details screen
Potentially a search screen (subject to confirmation based on your code)
Folder Structure:

The app adheres to a clean architecture, with code organized in the following directories (may vary slightly depending on your implementation):

#### domain:

Houses domain models representing song data (independent of any specific database).

#### data:

Contains logic for fetching song details from Firestore and retrieving song files from Storage.

#### presentation:

Implements the user interface and interacts with the data layer.

Supported Platforms:

NymTune is currently built for mobile and web platforms using Flutter. Run it on:

#### Android:

Ensure you have the Flutter development environment set up for Android.

#### Web Browser & iOS:

Set up the Flutter development environment for iOS/Web Browser if you plan to target those platforms.

Packages Used in NymTune

The table below details the packages utilized in the NymTune music player app, along with their descriptions:

| Package                               | Description                                                                                                                    |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| audioplayers                          | Enables audio playback functionality for a smooth listening experience.                                                        |
| cloud_firestore                       | Provides interaction with Firebase Firestore, allowing retrieval of song data.                                                 |
| cupertino_icons                       | Offers Cupertino-style icons for a consistent and visually appealing user interface.                                           |
| dartz                                 | Integrates functional programming concepts for potential code optimization.                                                    |
| firebase_app_check                    | Enhances app security by providing additional verification measures (consider including if implemented).                       |
| firebase_auth                         | Implements user authentication using Firebase, enabling features like login and signup.                                        |
| firebase_core                         | Core Firebase functionality, establishing the foundation for integration with other Firebase services.                         |
| firebase_storage                      | Grants access to Firebase Storage, facilitating storage and retrieval of song files.                                           |
| glassmorphism                         | Enables the implementation of a glassmorphism UI effect (consider including if implemented).                                   |
| http (consider alternatives like dio) | Used for making HTTP requests if needed (explore alternatives like `dio` for potentially better performance).                  |
| lottie                                | Allows for displaying Lottie animations, potentially enhancing the user interface (consider including if implemented).         |
| path_provider                         | Provides access to application storage directories, potentially enabling functionalities like saving downloaded songs locally. |
| provider                              | Handles state management within the app, ensuring consistent data flow throughout the UI.                                      |
| shared_preferences                    | Offers persistence of app data, potentially useful for storing user preferences (consider including if implemented).           |
| shimmer                               | Creates loading placeholders for a smoother user experience, minimizing wait times while data is being fetched.                |

![Screenshot of NymTune Home Screen](../assets/nymtune_poster.png)
