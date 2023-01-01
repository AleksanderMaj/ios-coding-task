# ios-coding-task

## Hi.

This project is a very naive implemenation of a map showing Donkey Republic pick-up locations (aka 'hubs'). The app fetches a list of hubs from the backend and displays these hubs as orange markers on the map. The number of available vehicles in a hub is displayed on each marker. Selecting a hub brings up a sheet with a detailed information about the hub. When you run the app, you should notice that there are some problems with it:
1. The map becomes unresponsive/laggy as soon as you try to display more than a few hubs on the screen.
2. Each time you pan the map the app fetches the list hubs from the backend at least a few times.
3. With the map zoomed out, the hubs overlap each other which results in a poor UX.
4. Possibly more...

## Goal
Your goal is to clone this repo and improve the app's UX focusing on optimizing performance **and complete at least one additional task** from the [list](https://github.com/AleksanderMaj/ios-coding-task#additional-tasks---pick-at-least-one-or-more-if-you-have-time-and-feel-like-it) below. When you're done, please send me your code in an email. You can also fork this project as a private repo and invite me to collaborate. Just make sure you don't fork this repo as another public repository - keep your solution hidden from other candidates. This task shouldn't require you to spend much more than **4 hours** on it.

## Here's a few rules/hints:
- Please make sure that the performance is smooth even when there are thousands of hubs present in the visible area. As far as we know, for now the performance issues with the SwiftUI `Map` displaying many annotations can't really be fixed, because they're intrinsic to it's implementation. To work around this, implement a simple **annotation clustering** when there are too many annotations for the `Map` view to handle. Please make each cluster show the number of all available vehicles in the cluster's region. To kick-start you, the project comes with a simple function that divides a map region into subregions. See `MKCoordinateRegion.dividedIntoSubregions(rows:columns:)` and the below recording to get an idea:

https://user-images.githubusercontent.com/945421/210267836-84d0beda-bcb4-4cae-8d01-fd1922962b48.mov

- Please don't switch to `MKMapView` (neither by rewriting the app into `UIKit` nor via your own `UIViewRepresentable`/`UIViewControllerRepresentable` implementation). SwiftUI's `Map`'s lack of maturity presents some specific challenges and we would like to see you dealing with them.
- Please try not to import any 3rd party dependencies other than these already imported. Again, this is because we want to see *you* understanding and dealing with the problems at a basic level and we are convinced it's perfectly possible to improve the UX without reaching for external solutions. If you feel strongly about using a 3rd party dependency please reach out to me beforehand.
- Exception to the above rule is [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture). If you feel comfortable with it you can restructure the app around TCA.
- Treat the exising code as a starting point, but feel free to modify/remove it if need be.
- Running the app will print the following warning many times in the console: `[SwiftUI] Publishing changes from within view updates is not allowed, this will cause undefined behavior.` Please ignore it. This warning started occurring in Xcode 14 and it's kind of unclear how to deal with it.
- Don't get stuck! If you run into a problem that you feel we're responsible for (e.g. backend returning errors) let me know.

## Additional tasks - pick **at least one** (or more if you have time and feel like it):
- `Hub` model comes with an `availableVehicles: [VehicleType: Int]` dictionary. Implement a simple UI+logic for filtering map annotations by vehicle types.
- The app supports deep-linking to a hub details screen using a custom URL scheme: `donkeybike://hub/:hub_id` e.g `donkeybike://hub/1262`. Currently this links to a fake `mock` hub. Implement deep-linking to a real hub. This would require fetching the hub data from the backend (see `Networking.swift/HubResource` for this purpose). When you get the hub data, show the hub details screen and zoom in on the hub's location on the map.
- Implement a test suite that tests the `MapModel` logic by mocking the response from the backend. Make sure to cover the most critical paths (e.g. request debouncing, annotation clustering)

### We'll be assessing you on:
- Performance of your code (e.g. how smooth the map works, threading)
- Quality of your code (no bugs)
- Readability of your code (e.g. adhering to Swift naming conventions, reasonable indentation)
- Proper separation of concerns. But please be mindful not to waste time overdoing it (e.g. don't put your business logic in the view layer, but also maybe don't introduce a separate protocol for each interface in the codebase)
- General UX - try not confuse the "user"

### We **won't** be assessing you on:
- UI - just stick to the absolute minimum and you'll be fine.
- Production-ready error handling - don't bother implementing UI alerts. A print-out in the console is good enough.

