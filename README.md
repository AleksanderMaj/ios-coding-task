# ios-coding-task

Hi.

This project is a very naive implemenation of a map showing Donkey Republic pick-up locations (aka 'hubs'). The app fetches a list of hubs from the backend and displays these hubs as orange markers on the map. The number of available vehicles in a hub is displayed on each marker. Selecting a hub brings up a sheet with a detailed information about the hub. When you run the app, you should notice that there are some problems with it:
1. The map becomes unresponsive/laggy as soon as you try to display more than a few hubs on the screen.
2. Each time you pan the map the app fetches the list hubs from the backend.
3. With the map zoomed out, the hubs overlap each other which results in a poor UX.
4. Possibly more...

Your goal is to clone this repo and improve the app's UX focusing on optimizing performance. When you're done, please send me your code in an email. You can also fork this project as a private repo and send me the link at the end. This task shouldn't require you to spend much more than **4 hours** on it.

Here's a few rules/hints:
- Please make sure that the performance is smooth even when there are thousands of hubs present in the visible area. As of now, performance issues with the SwiftUI `Map` displaying many annotations can't really be fixed (as far as we know). To work around this, feel free to use a simple **annotation clustering** when there are too many annotations for the `Map` to handle. Please make each cluster show the number of available vehicles in the cluster's region. To kick-start you, the project comes with a simple function that divides a map region into subregions. See `MKCoordinateRegion.dividedIntoSubregions(rows:columns:)` and the below recording to get an idea:
https://user-images.githubusercontent.com/945421/210186140-5388f1d6-6844-42c8-b079-007764bcf9b9.mov
- Please don't switch to `MKMapView` (neither by rewriting the app into `UIKit` nor via your own `UIViewRepresentable`/`UIViewControllerRepresentable` implementation). SwiftUI's `Map`'s lack of maturity presents some specific challenges and we would like to see you dealing with them.
- Please try not to import any 3rd party dependencies other than these already imported. Again, this is because we want to see *you* understanding and dealing with the problems at a basic level and we are convinced it's perfectly possible to improve the UX without reaching for external solutions. If you feel strongly about using a 3rd party dependency please reach out to me beforehand.
- Exception to the above rule is [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture). If you feel comfortable you can restructure the app around TCA.
- Treat the exising code as a starting point, but feel free to modify/remove it if need be.

Additional tasks - pick **at least one** (or more if you have time and feel like it):
- `Hub` model comes with an `availableVehicles: [VehicleType: Int]` dictionary. Implement a simple UI+logic for filtering map annotations by vehicle types.
- The app supports deep-linking to a hub details screen using a custom URL scheme: `donkeybike://hub/:hub_id` e.g `donkeybike://hub/1262`. Currently this links to a fake `mock` hub. Implement deep-linking to a real hub. This would require fetching the hub data from the backend (see `Networking.swift/HubResource` for this purpose). When you get the hub data, show the hub details screen and zoom in on the hub's location on the map.

We'll be assessing you on:
- Performance of your code (e.g. how smooth the map works, threading)
- Quality of your code (no bugs)
- Readability of your code (e.g. adhering to Swift naming conventions)
- Proper separation of concerns. But please be mindful not to waste time overdoing it (e.g. don't put you business logic in the view later, but also maybe don't introduce a separate protocol for each interface in the codebase)
- General UX - try not confuse the "user"

We **won't** be assessing you on:
- UI - just stick to the absolute minimum and you'll be fine.
- Production-ready error handling - don't bother implementing UI alerts. A print-out in the console is good enough.

