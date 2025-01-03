# GithubRepoList

## Overview  
This is a simple iOS app that fetches data from the [GitHub Repositories API](https://api.github.com/repositories) and displays it in a table view. The app is built using **Swift**, leveraging modern iOS development practices and frameworks.  

## Features  
### Core Functionality  
1. Fetches a list of repositories from the GitHub API endpoint.  
2. Parses the JSON response using **`Codable`**.  
3. Displays repository names in a table view with a **clean, user-friendly UI**.  
4. Navigates to a detailed view when an item is tapped, showing *additional information* about the selected repository.  

### Bonus Functionality  
1. **Pull-to-Refresh:** Allows users to refresh the list of repositories by pulling down on the table view.  
2. **Pagination:** Dynamically loads more items as the user scrolls to the bottom of the table view.  
3. **Caching:** Implements local data caching to support offline usage. Previously fetched data is displayed if the app is launched without an internet connection.  

**Screenshots**
**Main View Controller**

<div align="center">
  <img src="https://github.com/user-attachments/assets/21969e9f-d9de-4596-a99f-fedc62a8d0cc" alt="dashboard" width="200">
</div>

**Details View Controller**

<div align="center">
  <img src="https://github.com/user-attachments/assets/69360927-c78b-4df6-ad65-11523b66cdf7" alt="details" width="200">
</div>

**App Functionality (GIF)**

<div align="center">
  <img src="https://github.com/user-attachments/assets/9f08639c-0e32-4a69-aa2f-b7013123a389" alt="gif" width="200">
</div>

## Tech Stack  
- **Programming Language:** *Swift*  
- **Frameworks:** *UIKit*, *Foundation*  
- **Networking:** **`URLSession`**  
- **Data Parsing:** **`Codable`**  
- **UI Design:** Based on the * No Figma design was provided...just freestyle*
- **Supported iOS Version**: iOS 13 and above

## Error Handling  
- Displays an alert with a **meaningful error message** if the API request fails or if there’s a connectivity issue.  
- Provides **retry options** for failed requests.  

## How to Run the Project  
1. Clone the repository or download the ZIP file.  
2. Open the `.xcodeproj` file in Xcode.  
3. Ensure your environment is set up with the **latest version of Xcode**.  
4. Build and run the app on a simulator or physical device.  

## Screenshots  
Include relevant screenshots or GIFs demonstrating the app’s key functionalities.  

## Future Improvements  
- Add unit tests to validate the app’s functionalities.  
- Extend caching to allow data expiration and refresh automatically.  
