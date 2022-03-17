#  README

This Xcode project demonstrates the implementation of a custom SwiftUI alert which includes a text field.

---

While Apple does provide built in alert functionality within SwiftUI, it is insufficient in many cases as it explicitly disallows the inclusion of anything beyond static text. This is clearly a problem if you are trying to present an alert with a text field within your SwiftUI app.

Fortuantely we can work around this problem by creating a custom struct which conforms to the `UIViewControllerRepresentable` protocol. This struct will implement the `makeUIViewController(context:)` function to return a custom `UIViewController` that manages the presentation of a `UIAlertController`.

This extra level of indirection may seem unnecessary on the surface, however it is required as a `UIViewController` can only be presented by another `UIViewController`. Now the `UIViewControllerRepresentable` protocol handles the presentation of the managed `UIViewController` within our SwiftUI app, however `UIAlertController` does not allow for subclassing, and as a result we need a custom `UIViewController` to sit between the `UIViewControllerRepresentable` and the `UIAlertController`.

Please note that in this project I am not making use of the `updateUIViewController(_:context:)` function, as the user is prevented from interacting with any other part of the app while the alert is presented, and therefor no updates will be forthcoming.

Our custom `UIViewController` configures and presents a `UIAlertController`, which has the advantage over SwiftUI alerts in that it can handle the inclusion of any number of `UITextField` instances. Additionally, as we are now working with UIKit, we can make use of the `UITextFieldDelegate` protocol, to handle validation of the contents of the text field, and updating the SwiftUI binding for the managed text.

Finally we make our `UIViewControllerRepresentable` struct accessible in our SwiftUI app by extending `View` with an instance function which presents a `ZStack`, within which we conditionally render our custom alert, and unconditionally render the view to which the function is applied.
