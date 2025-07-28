# 🚦 SwiftUIRouter

A simple and powerful navigation system built for SwiftUI.

## Features

- Push/pop navigation between screens  
- Modal presentations (sheet, fullscreen)  
- Alerts  
- Popups  
- Deep link (URL) support  


## Installation

Initialize and inject `Router` as a `@StateObject` in your `@main` app struct. You can add the Router module directly from this repository:  
[https://github.com/hakankorhasan/SwiftUIRouter#](https://github.com/hakankorhasan/SwiftUIRouter#)

```swift
@main
struct AppMain: App {
    @StateObject private var router = Router.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(router)
                .onOpenURL { url in handleDeepLink(url) } // If you need
        }
    }
}
```

## Using the Router in Your Views

To access the router inside your SwiftUI views, you need to declare it as an environment object:

```swift
@EnvironmentObject var router: Router

// Preview
#Preview {
    HomeView()
        .environmentObject(Router.shared)
}
```


## Navigation Setup

Define your screens using enums (e.g. Screen, HomeScreen, ProfileScreen).
Use RouteTab to configure tabs and views inside your MainTabView.
Handle routing with a switch on the enum cases inside RouteTabView.

```swift
struct MainTabView: View {
    @EnvironmentObject var router: Router

    let tabs = [
        RouteTab(id: "home", title: "Home", icon: "house.fill") {
            HomeView()
        }.erased(),

        RouteTab(id: "profile", title: "Profile", icon: "person.crop.circle") {
            ProfileView()
        }.erased(),

        RouteTab(id: "favorite", title: "Favorite", icon: "star.fill") {
            FavoriteView()
        }.erased()
    ]

    var body: some View {
        RouteTabView<Screen>(router: router, tabs: tabs) { screen in
            switch screen {
            case .home(let homeScreen):
                
                }
                
            case .profile(let profileScreen):
                switch profileScreen {
                
                }

            case .favorite(let favoriteScreen):
                switch favoriteScreen {
                
                }
            }
        }
    }
}
```

## Router API Overview 

| Method                                                    | Description                 |
| --------------------------------------------------------- | --------------------------- |
| `router.push(screen)`                                     | Navigate to a new screen    |
| `router.pop()`                                            | Go back                     |
| `router.popToRoot()`                                      | Return to root screen       |
| `router.showSheet(view)`                                  | Present a sheet modal       |
| `router.showFullScreen(view)`                             | Present a full screen modal |
| `router.showAlert(title:message:button:)`                 | Show an alert               |
| `router.showPopup(view, backgroundColor:, cornerRadius:)` | Show a popup                |
| `router.dismissPopup()`                                   | Dismiss popup               |
| `router.dismissModal()`                                   | Dismiss modal               |
| `router.handleDeepLink(url)`                              | Handle deep link URL navigation |

## Navigating with `push`

The `push` method allows you to navigate forward to a new screen by pushing it onto the navigation stack. You can use it with or without parameters depending on your screen setup.

### Example with parameter

```swift
Button("Go to Detail A") {
    router.push(Screen.home(.detailHome(10)))
}
```

### Example without parameter

```swift
Button("Go to Detail B") {
    router.push(Screen.home(.detailHome)))
}
```

## Using Deep Links

You can handle incoming URLs for deep linking like this:

```swift
.onOpenURL { url in handleDeepLink(url) }

func handleDeepLink(_ url: URL) {
    guard url.scheme == "routertest", let host = url.host else {
        print("Invalid scheme or missing host")
        return
    }

    let pathComponents = url.pathComponents.filter { $0 != "/" }

    switch host {
       case "detailProfile":
          if let profileID = pathComponents.first {
              router.selectedTabID = "profile"
              router.popToRoot(tabID: "profile")
              router.deepLink([Screen.profile(.detailProfile(profileID))])
          }
       default:
          print("Unknown host")
    }
}
```

---

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to open a pull request or issue on GitHub.

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

Thanks for using **SwiftUIRouter**!  
If you find it helpful, please consider ⭐️ the repository and share it with the community.

Happy coding! 🚀


